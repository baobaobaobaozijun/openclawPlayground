# Agent 心跳监控机制

**版本:** v1.0  
**创建日期:** 2026-03-16 15:06  
**负责人:** 灌汤 (PM)  
**触发频率:** 每 10 分钟自动检查

---

## 🎯 机制目标

1. **主动发现失联 Agent** - 不依赖被动响应
2. **自动唤醒失联 Agent** - 通过 subagent 调用
3. **强制状态汇报** - 要求失联 Agent 立即汇报进度
4. **记录心跳日志** - 追踪每个 Agent 的活动状态

---

## 🔍 心跳检查流程

### 检查频率
- **常规检查:** 每 10 分钟一次
- **工作时间:** 08:00 - 22:00 (Asia/Shanghai)
- **非工作时间:** 每 30 分钟一次（仅监控，不唤醒）

### 检查步骤

```
每次心跳检查
  ↓
1. 读取各 Agent 状态文件
   - workspace-{agent}/status.md (最后更新时间)
   - workspace-{agent}/MEMORY.md (最后活动时间)
   - workinglog/{agent}/ (最新日志时间)
  ↓
2. 判断是否失联
   - 最后活动时间 > 30 分钟 → 🟢 正常
   - 最后活动时间 > 60 分钟 → 🟡 警告
   - 最后活动时间 > 120 分钟 → 🔴 失联
  ↓
3. 针对失联 Agent 执行唤醒
   - 使用 sessions_spawn 直接调用
   - 要求立即汇报当前状态
   - 限时 10 分钟内回复
  ↓
4. 记录心跳日志
   - doc/progress/agent-heartbeat-log.md
   - 记录检查时间、结果、采取的行动
```

---

## 📞 失联 Agent 唤醒流程

### 判定标准

| 指标 | 阈值 | 状态 |
|------|------|------|
| 最后活动时间 | < 30 分钟 | 🟢 正常 |
| 最后活动时间 | 30-60 分钟 | 🟡 警告 |
| 最后活动时间 | > 60 分钟 | 🔴 失联 |

### 唤醒方式

**使用 sessions_spawn 直接调用:**

```
sessions_spawn(
  agentId: "{agent_id}",
  task: "【心跳检查 - 立即汇报】\n\n灌汤 PM 心跳检查发现你已失联 {X} 分钟。\n\n请立即汇报：\n1. 当前任务及进度\n2. 最后活动时间及内容\n3. 是否有技术阻碍\n4. 预计下次汇报时间\n\n限时 10 分钟内回复。",
  mode: "run",
  runtime: "subagent",
  timeoutSeconds: 600
)
```

### 回复处理

**Agent 回复后:**
1. ✅ 检查工作日志是否补录
2. ✅ 更新心跳日志
3. ✅ 如有阻碍，立即协调解决
4. ✅ 分配新任务（如当前任务已完成）

**Agent 未回复（超时 10 分钟）:**
1. 🔴 升级处理 - 记录到风险日志
2. 🔴 第二次唤醒（紧急）
3. 🔴 如仍无响应，标记为"严重失联"
4. 🔴 通知 PM 人工介入

---

## 📝 心跳日志格式

**文件:** `doc/progress/agent-heartbeat-log.md`

```markdown
## 2026-03-16 心跳日志

### 15:10 检查

| Agent | 最后活动 | 状态 | 行动 |
|-------|---------|------|------|
| 酱肉 | 03-12 18:51 | 🔴 失联 | 已唤醒 (sessions_spawn) |
| 豆沙 | 03-12 08:30 | 🔴 失联 | 已唤醒 (sessions_spawn) |
| 酸菜 | 03-12 18:46 | 🔴 失联 | 已唤醒 (sessions_spawn) |

**行动记录:**
- 15:10 - 发送心跳检查通知给酱肉/豆沙/酸菜
- 15:15 - 酱肉回复（补录日志，汇报进度 30%）
- 15:18 - 豆沙回复（补录日志，汇报进度 45%）
- 15:20 - 酸菜回复（补录日志，汇报进度 60%）

**遗留问题:**
- 无

---

### 15:20 检查

| Agent | 最后活动 | 状态 | 行动 |
|-------|---------|------|------|
| 酱肉 | 15:15 | 🟢 正常 | 无需行动 |
| 豆沙 | 15:18 | 🟢 正常 | 无需行动 |
| 酸菜 | 15:20 | 🟢 正常 | 无需行动 |

**行动记录:**
- 无

---
```

---

## 🔧 自动化脚本

### PowerShell 心跳检查脚本

**位置:** `scripts/heartbeat-check.ps1`

```powershell
# Agent 心跳检查脚本
# 每 10 分钟执行一次

$agents = @("jiangrou", "dousha", "suancai")
$workspaceBase = "F:\openclaw\agent"
$heartbeatLog = "$workspaceBase\doc\progress\agent-heartbeat-log.md"
$thresholdMinutes = 60

function Get-LastActivity {
    param([string]$agent)
    $workinglogPath = "$workspaceBase\workinglog\$agent\*.md"
    $latest = Get-ChildItem $workinglogPath -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($latest) {
        return $latest.LastWriteTime
    }
    return $null
}

function Write-HeartbeatLog {
    param(
        [string]$timestamp,
        [array]$results,
        [array]$actions
    )
    $logEntry = @"
### $timestamp 检查

| Agent | 最后活动 | 状态 | 行动 |
|-------|---------|------|------|
"@
    foreach ($result in $results) {
        $status = if ($result.minutes -lt 30) { "🟢 正常" }
                  elseif ($result.minutes -lt 60) { "🟡 警告" }
                  else { "🔴 失联" }
        $action = if ($result.minutes -gt 60) { "已唤醒 (sessions_spawn)" } else { "无需行动" }
        $logEntry += "`n| $($result.agent) | $($result.lastActivity) | $status | $action |"
    }
    
    Add-Content -Path $heartbeatLog -Value $logEntry
}

# 主检查逻辑
$timestamp = Get-Date -Format "HH:mm"
$results = @()

foreach ($agent in $agents) {
    $lastActivity = Get-LastActivity -agent $agent
    if ($lastActivity) {
        $minutes = (New-TimeSpan -Start $lastActivity -End (Get-Date)).TotalMinutes
        $results += @{
            agent = $agent
            lastActivity = $lastActivity.ToString("MM-dd HH:mm")
            minutes = [int]$minutes
        }
    } else {
        $results += @{
            agent = $agent
            lastActivity = "无记录"
            minutes = 999
        }
    }
}

Write-HeartbeatLog -timestamp $timestamp -results $results -actions @()
```

---

## ⚠️ 异常处理

### 场景 1: Agent 持续失联（> 2 小时）

**处理方式:**
1. 每 30 分钟唤醒一次
2. 记录到风险日志 `issues/active-issues.md`
3. 通知 PM 人工介入
4. 考虑重新分配任务

### 场景 2: Agent 回复但无工作日志

**处理方式:**
1. 要求立即补录日志（10 分钟截止）
2. 如未补录，升级为第 2 次违规
3. 第 3 次违规调整任务分配

### 场景 3: Agent 汇报有技术阻碍

**处理方式:**
1. 立即记录到 `issues/active-issues.md`
2. 协调资源解决（15 分钟内响应）
3. 如无法解决，调整任务优先级
4. 必要时组织技术讨论

---

## 📊 心跳监控仪表板

**位置:** `doc/progress/agent-heartbeat-dashboard.md`

```markdown
# Agent 心跳监控仪表板

**最后更新:** 2026-03-16 15:10  
**检查频率:** 每 10 分钟

## 实时状态

| Agent | 状态 | 最后活动 | 连续正常次数 | 今日心跳合格率 |
|-------|------|---------|-------------|---------------|
| 酱肉 | 🔴 失联 | 03-12 18:51 | 0/6 | 0% |
| 豆沙 | 🔴 失联 | 03-12 08:30 | 0/6 | 0% |
| 酸菜 | 🔴 失联 | 03-12 18:46 | 0/6 | 0% |

## 今日统计

- **总检查次数:** 1 次
- **正常次数:** 0 次
- **警告次数:** 0 次
- **失联次数:** 3 次
- **唤醒成功:** 0 次
- **唤醒失败:** 0 次

## 趋势图

（待实现：使用图表展示 7 天心跳合格率趋势）

---

*自动更新，下次检查：15:20*
```

---

## 🎯 心跳机制启用检查清单

- [x] 创建心跳机制文档 (`doc/guides/agent-heartbeat-mechanism.md`)
- [ ] 创建心跳日志文件 (`doc/progress/agent-heartbeat-log.md`)
- [ ] 创建心跳仪表板 (`doc/progress/agent-heartbeat-dashboard.md`)
- [ ] 创建 PowerShell 检查脚本 (`scripts/heartbeat-check.ps1`)
- [ ] 配置定时任务（每 10 分钟执行）
- [ ] 测试唤醒流程（sessions_spawn 调用）
- [ ] 通知各 Agent 心跳机制已启用

---

**文档位置:** `F:\openclaw\agent\doc\guides\agent-heartbeat-mechanism.md`  
**维护者:** 灌汤 (PM)  
**最后更新:** 2026-03-16 15:06
