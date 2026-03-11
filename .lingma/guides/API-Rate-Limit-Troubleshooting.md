# API Rate Limit 问题分析与解决方案

## 📊 问题描述

**错误信息:**
```
runId=c9943555-e7dc-4f88-ae6b-312638d15440 
isError=true 
error=⚠️ API rate limit reached. Please try again later.
```

**含义:** API 调用频率达到限制，需要等待一段时间后才能继续使用

---

## 🔍 可能的原因

### 1. 单个 API Key 的调用频率过高

虽然我们有 3 个不同的 API Key，但每个 Key 都有自己的速率限制：

| API Key | 拥有者 | 可能的限制 |
|---------|--------|-----------|
| `sk-0101...b4db` | 酱肉 | QPM（每分钟查询数）限制 |
| `sk-dc74...999c` | 豆沙 | QPM 限制 |
| `sk-1ede...f577` | 酸菜 | QPM 限制 |

**通义千问 API 的典型限制:**
- **免费版/QPS:** 1-2 次/秒
- **付费版/QPS:** 5-10 次/秒
- **QPM（每分钟）:** 60-300 次/分钟

### 2. 短时间内大量请求

可能触发限流的操作：
- ❌ 连续执行多个复杂任务
- ❌ 批量处理大量文件
- ❌ Auto-Push 频繁触发（每次 commit 都推送）
- ❌ 循环调用 API（代码中的递归或循环）

### 3. 多个 Agent 同时高负载运行

如果 3 个容器同时运行：
```bash
# 每个容器都在调用 API
openclaw-instance-1 (jiangrou) → 高频调用 → ⚠️
openclaw-instance-2 (dousha)   → 高频调用 → ⚠️
openclaw-instance-3 (suancai)  → 高频调用 → ⚠️
```

---

## 💡 解决方案

### 方案 1: 检查并优化 API 使用

#### 1.1 查看当前运行的容器

```bash
# 检查哪些容器在运行
docker ps --filter "name=openclaw"

# 查看容器的资源使用情况
docker stats openclaw-instance-1 openclaw-instance-2 openclaw-instance-3
```

#### 1.2 暂停不需要的容器

如果只需要灌汤运行，可以暂停其他 Agent：

```bash
# 停止其他 Agent 容器
docker stop openclaw-instance-2  # 豆沙
docker stop openclaw-instance-3  # 酸菜

# 只保留酱肉运行
docker stop openclaw-instance-1  # 如果需要也可以停止
```

#### 1.3 重启容器清除状态

```bash
# 重启遇到问题的容器
docker restart openclaw-instance-1
```

---

### 方案 2: 调整 Auto-Push 配置

如果 Auto-Push 技能触发太频繁，可以修改配置：

**文件:** `.lingma/skills/auto-push-agent/SKILL.md`

**建议修改:**
```markdown
### Trigger Conditions

Instead of triggering on every file change:

- ✅ Only push when explicitly requested
- ✅ Batch multiple changes together
- ✅ Add delay between pushes (e.g., wait 5 minutes after last change)
```

或者手动控制推送：
```powershell
# 禁用自动推送，改为手动
# 在 agent 运行时不要启用 auto-push 技能
```

---

### 方案 3: 增加 API Key 配额

#### 3.1 升级阿里云账号

访问阿里云控制台：
1. 登录 https://dashscope.console.aliyun.com/
2. 进入"配额管理"
3. 申请提高 QPS/QPM限制

#### 3.2 使用多个 API Key 轮询

创建配置文件 `.lingma/api-keys.json`:

```json
{
  "apiKeys": [
    "sk-0101b7d3672245ac8cd15d454198b4db",
    "sk-dc74719ea21348f183cbabb87f01999c",
    "sk-1edeed01f7104f75b0c4c69237b7f577",
    "sk-new-key-1",
    "sk-new-key-2"
  ],
  "rotationStrategy": "round-robin"
}
```

---

### 方案 4: 添加重试机制

修改脚本或代码，添加指数退避重试：

**示例 PowerShell 脚本:**

```powershell
function Invoke-WithRetry {
    param(
        [scriptblock]$Action,
        [int]$maxRetries = 3
    )
    
    $retryCount = 0
    $delay = 5
    
    while ($retryCount -lt $maxRetries) {
       try {
            & $Action
           return
        } catch {
           if ($_.Exception.Message -match "rate limit") {
                $retryCount++
               Write-Host "Rate limit hit. Waiting ${delay}s before retry..." -Yellow
                Start-Sleep -Seconds $delay
                $delay = $delay * 2  # 指数退避
            } else {
                throw
            }
        }
    }
    
    throw "Max retries reached"
}

# 使用示例
Invoke-WithRetry -Action {
    # 你的 API 调用代码
}
```

---

### 方案 5: 监控和告警

#### 5.1 创建监控脚本

`.lingma/scripts/Monitor-APIUsage.ps1`:

```powershell
# 监控 API 调用频率
$callCount = 0
$windowStart = Get-Date
$limit = 60  # 每分钟 60 次

function Test-APILimit {
   if ((Get-Date) - $windowStart).TotalMinutes -ge 1 {
        $callCount = 0
        $windowStart = Get-Date
    }
    
   if ($callCount-ge $limit) {
       Write-Warning "API rate limit approaching! Current: $callCount/$limit"
       return $false
    }
    
    $callCount++
   return $true
}
```

#### 5.2 设置告警

当 API 调用接近限制时发送通知：

```powershell
if (-not (Test-APILimit)) {
    # 发送通知
   Write-Host "⚠️ API rate limit reached. Pausing operations..." -ForegroundColor Red
    
    # 暂停操作
    Start-Sleep -Seconds 60
}
```

---

## 🎯 立即执行的步骤

### Step 1: 检查当前状态

```bash
# 1. 查看所有运行中的容器
docker ps -a

# 2. 查看容器日志
docker logs openclaw-instance-1 --tail 50

# 3. 停止所有容器（如果需要）
docker-compose -f docker-compose-agents.yml down
```

### Step 2: 等待恢复

**API Rate Limit 通常会在以下时间后自动解除:**
- ⏳ **短期限制:** 1-5 分钟
- ⏳ **中期限制:** 15-30 分钟
- ⏳ **严重限制:** 1-24 小时

### Step 3: 重新启动（降低频率）

```bash
# 只启动需要的容器
docker-compose -f docker-compose-agents.yml up -d jiangrou

# 或者逐个启动
docker start openclaw-instance-1
# 等待几分钟
docker start openclaw-instance-2
# 再等待几分钟
docker start openclaw-instance-3
```

---

## 📝 长期优化建议

### 1. 任务调度优化

- ✅ 避免同时执行多个任务
- ✅ 在任务之间添加延迟
- ✅ 使用任务队列管理

### 2. 缓存策略

- ✅ 缓存常用查询结果
- ✅ 避免重复调用相同的 API
- ✅ 本地存储中间结果

### 3. 批量处理

- ✅ 合并多个小任务为一个大任务
- ✅ 减少 API 调用次数
- ✅ 使用批量接口（如果有）

### 4. 监控仪表板

创建 Grafana 或 Prometheus 监控：
- API 调用频率
- 响应时间
- 错误率
- 剩余配额

---

## 🔗 相关资源

- **阿里云文档:** https://help.aliyun.com/document_detail/dashscope.html
- **配额管理:** https://dashscope.console.aliyun.com/quota
- **API 文档:** https://help.aliyun.com/zh/dashscope/developer-reference/

---

## ✅ 检查清单

- [ ] 确认哪个 API Key 达到限制
- [ ] 检查当前运行的容器数量
- [ ] 暂停不必要的 Agent 容器
- [ ] 等待 5-15 分钟让限制解除
- [ ] 重新启动时降低调用频率
- [ ] 考虑升级 API 配额
- [ ] 实施监控和告警机制
- [ ] 优化代码减少不必要的 API 调用

---

*创建时间：2026-03-09*  
*状态：⚠️ API Rate Limit 已触发*  
*建议：等待 5-15 分钟后重试*
