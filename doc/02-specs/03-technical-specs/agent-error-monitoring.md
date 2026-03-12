<!-- Last Modified: 2026-03-10 -->

# Agent 错误监控与故障处理机制

**版本:** v1.0  
**生效日期:** 2026-03-10  
**维护者:**灌汤 (PM)  
**状态:** ✅ 新增功能

---

## 📋 目录

1. [错误监控架构](#错误监控架构)
2. [错误类型与检测](#错误类型与检测)
3. [实时监控机制](#实时监控机制)
4. [故障自动处理](#故障自动处理)
5. [告警通知流程](#告警通知流程)
6. [恢复策略](#恢复策略)
7. [操作手册](#操作手册)

---

## 错误监控架构

### 架构图

```
┌─────────────────────────────────────────────────────┐
│           灌汤错误监控与故障处理中心                │
├─────────────────────────────────────────────────────┤
│                                                     │
│  ┌──────────────────────────────────────────────┐  │
│  │         监控层 (Monitoring Layer)            │  │
│  ├──────────────────────────────────────────────┤  │
│  │  ✓ Gateway 健康检查   ✓ Token 余量监控      │  │
│  │  ✓ Docker 容器状态    ✓ 消息队列监控       │  │
│  │  ✓ 错误日志收集     ✓ 响应时间监控       │  │
│  └──────────────────────────────────────────────┘  │
│                      ↓                              │
│  ┌──────────────────────────────────────────────┐  │
│  │         分析层 (Analysis Layer)              │  │
│  ├──────────────────────────────────────────────┤  │
│  │  ✓ 错误分类        ✓ 严重程度评估        │  │
│  │  ✓ 根因分析        ✓ 影响范围判断        │  │
│  └──────────────────────────────────────────────┘  │
│                      ↓                              │
│  ┌──────────────────────────────────────────────┐  │
│  │         处理层 (Response Layer)              │  │
│  ├──────────────────────────────────────────────┤  │
│  │  ✓ 自动重试        ✓ 降级切换            │  │
│  │  ✓ 容器重启        ✓ 告警通知            │  │
│  └──────────────────────────────────────────────┘  │
│                                                     │
└─────────────────────────────────────────────────────┘
```

---

## 错误类型与检测

### 1. Token 相关错误 🔴

#### Token 耗尽

**检测方式:**
```json
{
  "error_type": "token_exhausted",
  "agent": "酱肉",
  "timestamp": "2026-03-10T14:30:00Z",
  "details": {
    "current_token": "4aa59ed646303abc8fdeb18147ab277c8f17b2ddff626a39",
    "error_code": "AUTH_FAILED",
    "message": "API key quota exceeded"
  }
}
```

**监控指标:**
- API 调用次数接近配额限制
- API 返回 429 (Too Many Requests)
- API 返回 401 (Unauthorized)

**检测频率:**每 5 分钟检查一次

---

#### Token 过期/无效

**检测方式:**
```json
{
  "error_type": "token_invalid",
  "agent": "豆沙",
  "timestamp": "2026-03-10T14:35:00Z",
  "details": {
    "error_code": "AUTH_FAILED",
    "message": "Invalid API key"
  }
}
```

---

### 2. 进程运行错误 🔴

#### 进程异常退出

**检测方式:**
```powershell
# PowerShell 监控脚本
$process = Get-Process | Where-Object { $_.ProcessName -like "*openclaw*" }
if ($null -eq $process) {
    # 发送告警
    Send-Alert "OpenClaw Gateway 进程已退出"
}
```

**监控指标:**
- Gateway 进程不存在
- 进程 CPU 使用率异常
- 进程内存泄漏

**检测频率:** 每 1 分钟检查一次

---

#### 进程资源耗尽

**监控指标:**
- CPU 使用率 > 90%
- 内存使用率 > 95%
- 磁盘空间不足

**检测命令:**
```powershell
Get-Process openclaw | Select-Object CPU,WorkingSet,Handles
```

---

### 3. Gateway 通信错误 🟡

#### Gateway 离线

**检测方式:**
```powershell
$gatewayUrl = "http://localhost:18789"
try {
    $response = Invoke-RestMethod -Uri "$gatewayUrl/api/v1/health" -TimeoutSec 5
    if ($response.status -ne "ok") {
        Send-Alert"Gateway 状态异常"
    }
}
catch {
    Send-Alert"Gateway 无法连接"
}
```

**监控指标:**
- HTTP 请求超时
- 返回状态码非 200
- 响应时间 > 3 秒

**检测频率:** 每 30 秒检查一次

---

#### 消息投递失败

**检测方式:**
```json
{
  "error_type": "message_delivery_failed",
  "from": "灌汤",
  "to": "酱肉",
  "message_id": "MSG_20260310_001",
  "error": "Agent unreachable after 3 retries"
}
```

**监控指标:**
- 消息在 outbox 中停留超过 5 分钟
- 重试次数达到上限 (3 次)
- 连续多次投递失败

---

### 4. Agent 业务错误 🟡

#### 任务执行超时

**检测方式:**
```json
{
  "error_type": "task_timeout",
  "agent": "酱肉",
  "task_id": "TASK_20260310_001",
  "expected_duration": "2h",
  "actual_duration": "4h",
  "status": "still_in_progress"
}
```

---

#### 连续错误报告

**检测方式:**
- 同一 Agent 在短时间内连续发送 errorReport
- 错误率超过阈值 (如 10%)

---

## 实时监控机制

### 1. 监控仪表板

**文件位置:** `workspace-guantang/monitoring/dashboard.md`

**更新频率:**每 5 分钟自动更新

**内容:**
```markdown
# Agent 监控仪表板

**更新时间:** 2026-03-10 14:40:00

## 整体状态
- ✅ 灌汤 (本地): 正常运行
- ✅ 酱肉 (Docker): 健康运行
- ⚠️ 豆沙 (Docker): API 调用频繁
- ✅ 酸菜 (Docker): 健康运行

## Gateway 状态
- ✅ Gateway: 在线 (响应时间：45ms)
- ✅ Token 余量：充足 (剩余 85%)

## Docker 容器
| 容器 | 状态 | CPU | 内存 | 运行时间 |
|------|------|-----|------|---------|
| 酱肉 | healthy | 23% | 45% | 2h 15m |
| 豆沙 | healthy | 67% | 52% | 2h 14m |
| 酸菜 | healthy | 12% | 38% | 2h 13m |

## 消息队列
- 待处理消息：3
- 失败消息：0
- 平均响应时间：1.2s

## 最近告警
- 14:30- 豆沙 API 调用频繁 (已处理)
- 12:15 - 酱肉短暂网络波动 (已恢复)
```

---

### 2. 自动化监控脚本

**文件:** `workspace-guantang/scripts/monitor-agents.ps1`

**脚本内容:**
```powershell
# Agent 监控主脚本
# 执行频率：每 1 分钟

param(
    [int]$checkInterval = 60,
    [string]$logPath = "F:\openclaw\agent\workspace-guantang\logs\monitoring"
)

function Check-GatewayHealth {
    $gatewayUrl = "http://localhost:18789"
    try {
        $response = Invoke-RestMethod -Uri "$gatewayUrl/api/v1/health" -TimeoutSec 5
       return @{ Status = "online"; ResponseTime = $response.responseTime }
    }
    catch {
       return @{ Status = "offline"; Error = $_.Exception.Message }
    }
}

function Check-DockerContainers {
    $containers = docker ps --filter "name=openclaw-instance" --format "{{.Names}}\t{{.Status}}\t{{.CPUPerc}}\t{{.MemPerc}}"
    $results = @()
    
    foreach ($container in $containers) {
        $parts = $container -split "\t"
        $status = if ($parts[1] -match "healthy") { "healthy" } else { "unhealthy" }
        
        $results += @{
            Name = $parts[0]
            Status = $status
            CPU = $parts[2]
            Memory = $parts[3]
        }
        
        # 如果状态异常，发送告警
        if ($status -eq "unhealthy") {
            Send-Alert -Agent $parts[0] -Message "容器状态异常：$($parts[1])"
        }
    }
    
   return $results
}

function Check-TokenUsage {
    # 检查 API 调用统计
    $statsPath = "F:\openclaw\agent\workinglog\api-stats.json"
    if (Test-Path $statsPath) {
        $stats = Get-Content $statsPath | ConvertFrom-Json
        foreach ($agent in $stats.agents) {
            if ($agent.usage_percent-gt 90) {
                Send-Alert -Agent $agent.name -Message"Token 余量不足：剩余 $($agent.usage_percent)%"
            }
        }
    }
}

function Send-Alert {
    param(
        [string]$Agent,
        [string]$Message,
        [ValidateSet("low", "medium", "high", "critical")]
        [string]$Level = "medium"
    )
    
    $alert = @{
        timestamp = Get-Date -Format "yyyy-MM-ddTHH:mm:ssZ"
       agent = $Agent
        level = $Level
        message = $Message
    }
    
    # 写入告警文件
    $alert | ConvertTo-Json | Add-Content "F:\openclaw\agent\communication\inbox\guantang\alerts\$((Get-Date).ToString('yyyyMMdd-HHmmss')).json"
    
    # 如果是紧急告警，立即通知
    if ($Level -eq "critical") {
        # TODO: 发送邮件/短信通知
        Write-Host"🚨 紧急告警：$Message" -ForegroundColor Red
    }
}

# 主循环
while ($true) {
    Write-Host "[$(Get-Date)] 开始检查..."
    
    # 1. 检查 Gateway
    $gateway = Check-GatewayHealth
    Write-Host "Gateway: $($gateway.Status)"
    
    # 2. 检查 Docker 容器
    $containers = Check-DockerContainers
    foreach ($c in $containers) {
        Write-Host "$($c.Name): $($c.Status) (CPU: $($c.CPU), Mem: $($c.Memory))"
    }
    
    # 3. 检查 Token 使用
    Check-TokenUsage
    
    # 4. 等待下次检查
    Start-Sleep -Seconds $checkInterval
}
```

---

## 故障自动处理

### 1. Token 耗尽处理流程

```powershell
function Handle-TokenExhausted {
    param([string]$AgentName)
    
    Write-Host"🔴 检测到 $AgentName Token 耗尽，开始处理..." -ForegroundColor Yellow
    
    # Step 1: 暂停该 Agent 的任务接收
    Suspend-AgentTasks -Agent $AgentName
    
    # Step 2: 尝试切换到备用 Token
    $backupToken = Get-BackupToken -Agent $AgentName
    if ($backupToken) {
        Update-AgentConfig -Agent $AgentName -Token $backupToken
        Write-Host"✅ 已切换到备用 Token" -ForegroundColor Green
        
        # Step 3: 恢复 Agent
        Resume-AgentTasks -Agent $AgentName
       return $true
    }
    
    # Step 4: 如果没有备用 Token，通知管理员
    Send-AdminNotification-Message "$AgentName Token 已耗尽，需要补充 API Key" -Level "high"
    
   return $false
}
```

---

### 2. 容器故障处理流程

```powershell
function Handle-ContainerIssue {
    param([string]$ContainerName)
    
    $issueType = Get-ContainerIssue -Container $ContainerName
    
    switch ($issueType) {
        "stopped" {
            # 容器停止 - 尝试重启
            Write-Host "🔴 容器 $ContainerName 已停止，尝试重启..." -ForegroundColor Yellow
           docker start $ContainerName
            
            # 等待 30 秒检查是否成功
            Start-Sleep -Seconds 30
            $status = docker inspect -f '{{.State.Health.Status}}' $ContainerName
            
            if ($status -ne "healthy") {
                # 重启失败，尝试重建容器
                Rebuild-Container-Container $ContainerName
            }
        }
        
        "unhealthy" {
            # 容器不健康 - 诊断原因
            $logs = docker logs --tail 100 $ContainerName
            
            if ($logs -match "Out of memory") {
                # 内存不足 - 增加限制并重启
                Write-Host"⚠️ 容器内存不足，调整配置..." -ForegroundColor Yellow
               docker update --memory=2g $ContainerName
               docker restart $ContainerName
            }
            elseif ($logs -match "Connection refused") {
                # 网络问题 - 检查网络配置
                Write-Host"⚠️ 容器网络异常，检查网络..." -ForegroundColor Yellow
                Test-ContainerNetwork -Container $ContainerName
            }
        }
        
        "high_cpu" {
            # CPU 过高 - 限流
            Write-Host"⚠️ 容器 CPU 使用率过高，实施限流..." -ForegroundColor Yellow
           docker update --cpus=1.5 $ContainerName
        }
    }
}
```

---

### 3. Gateway 故障处理流程

```powershell
function Handle-GatewayOffline {
    Write-Host"🔴 Gateway 离线，启动应急方案..." -ForegroundColor Red
    
    # Step 1: 尝试重启 Gateway 服务
    Write-Host "Step 1: 尝试重启 Gateway..." -ForegroundColor Yellow
    Restart-GatewayService
    
    # Step 2: 等待 30 秒检查
    Start-Sleep -Seconds 30
    $status = Check-GatewayHealth
    
    if ($status.Status -eq "online") {
        Write-Host"✅ Gateway 已恢复" -ForegroundColor Green
       return
    }
    
    # Step 3: 切换到降级模式 (文件系统通信)
    Write-Host "⚠️ Gateway 无法启动，切换到降级模式..." -ForegroundColor Yellow
    Enable-FallbackMode
    
    # Step 4: 通知所有 Agent
    Notify-AllAgents -Message "Gateway 故障，已切换到文件系统通信模式"
    
    # Step 5: 发送紧急告警给管理员
    Send-EmergencyAlert -Message "Gateway 严重故障，需要人工干预"
}
```

---

## 告警通知流程

### 告警级别定义

| 级别 | 颜色 | 说明 | 响应时间 | 处理方式 |
|------|------|------|----------|----------|
| **low** | 🔵 蓝色 | 提示信息 | 24 小时 | 记录日志 |
| **medium** | 🟡 黄色 | 警告信息 | 4 小时 | 自动处理 + 记录 |
| **high** | 🟠 橙色 | 严重警告 | 1 小时 | 自动处理 + 通知 |
| **critical** | 🔴 红色 | 紧急故障 | 15 分钟 | 立即处理 + 电话通知 |

---

### 告警通知渠道

#### 1. 工作空间告警 (所有级别)

**路径:** `F:\openclaw\agent\communication\inbox\guantang\alerts\`

**文件格式:**
```json
{
  "alert_id": "ALERT_20260310_001",
  "timestamp": "2026-03-10T14:30:00Z",
  "level": "high",
  "agent": "酱肉",
  "type": "token_exhausted",
  "message": "酱肉 Token 已耗尽，正在使用备用 Token",
  "action_taken": "已自动切换到备用 Token",
  "requires_attention": false
}
```

---

#### 2. 邮件通知 (high/critical 级别)

**模板:**
```
主题：【OpenClaw 告警】[级别] - [Agent 名称] - [问题简述]

正文:
尊敬的 Admin,

OpenClaw 系统检测到以下问题:

【告警详情】
- 时间：2026-03-10 14:30:00
- Agent: 酱肉
- 级别：high
- 类型：Token 耗尽
- 描述：酱肉的 API Token 已耗尽，正在使用备用 Token

【已采取措施】
✓ 已自动切换到备用 Token
✓ 任务执行已恢复

【后续建议】
请尽快补充主 Token 的配额

--
OpenClaw 监控系统
```

---

#### 3. 短信/即时通讯 (critical 级别)

**模板:**
```
🚨 OpenClaw 紧急告警

酱肉容器宕机，已尝试重启 3 次失败

时间：14:30
影响：后端开发暂停
建议：立即检查 Docker 日志

查看详情：http://localhost:18789/monitoring
```

---

## 恢复策略

### 1. 自动恢复

**适用场景:**
- 短暂网络波动
- 临时资源不足
- 单次请求失败

**恢复步骤:**
1. 自动重试 (最多 3 次)
2. 切换备用资源 (Token、容器等)
3. 降级到备份方案

---

### 2. 半自动恢复

**适用场景:**
- 配置错误
- 持续资源不足
- 多次重试失败

**恢复步骤:**
1. 自动诊断问题
2. 生成恢复建议
3. 等待管理员确认
4. 执行恢复操作

---

### 3. 人工干预

**适用场景:**
- 硬件故障
- 数据损坏
- 复杂系统问题

**恢复步骤:**
1. 发送紧急告警
2. 提供详细诊断报告
3. 建议恢复方案
4. 协助人工恢复

---

## 操作手册

### 日常监控检查清单

**每日检查 (灌汤自动执行):**

- [ ] 检查 Gateway 健康状态
- [ ] 检查所有 Agent 在线状态
- [ ] 检查 Token 使用量
- [ ] 检查 Docker 容器资源使用
- [ ] 检查消息队列积压情况
- [ ] 检查错误日志数量

**每周检查 (人工):**

- [ ] 审查告警历史
- [ ] 分析错误趋势
- [ ] 优化监控阈值
- [ ] 更新应急预案
- [ ] 备份配置文件

---

### 应急响应流程

#### P0 级故障 (critical)

**响应时间:** 15 分钟内

**流程:**
```
1. 监控系统检测到故障
   ↓
2. 立即发送短信/电话告警
   ↓
3. 自动启动应急预案
   ↓
4. 管理员介入处理
   ↓
5. 问题解决，发送恢复通知
   ↓
6. 生成故障报告
```

---

### 常用诊断命令

#### 检查 Gateway 状态
```bash
curl http://localhost:18789/api/v1/health
```

#### 查看容器日志
```bash
docker logs --tail 200 openclaw-instance-1
```

#### 检查网络连接
```bash
docker exec openclaw-instance-1 ping host.docker.internal
```

#### 查看消息队列
```bash
dir F:\openclaw\agent\communication\outbox /s
```

---

## 📊 监控指标汇总

### Gateway 指标
- ✅ 在线状态
- ✅ 响应时间 (< 100ms)
- ✅ 请求成功率 (> 99.9%)
- ✅ 并发连接数

### Docker 容器指标
- ✅ 容器状态 (healthy/unhealthy)
- ✅ CPU 使用率 (< 80%)
- ✅ 内存使用率 (< 90%)
- ✅ 重启次数 (< 3 次/小时)

### Token 指标
- ✅ 剩余配额 (> 10%)
- ✅ 调用频率 (< 限制值)
- ✅ 错误率 (< 5%)

### 消息指标
- ✅ 队列长度 (< 100)
- ✅ 平均响应时间 (< 2s)
- ✅ 投递成功率 (> 95%)

---

**状态:** ✅ 新增功能  
**版本:** v1.0  
**最后更新:** 2026-03-10  
**维护者:**灌汤 (PM)
