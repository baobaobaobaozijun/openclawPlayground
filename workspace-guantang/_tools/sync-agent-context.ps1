# Agent 上下文同步脚本

# 用途：从数据库读取计划状态，更新 TOOLS-CONTEXT.md

$contextFile = "F:\openclaw\agent\workspace-guantang\TOOLS-CONTEXT.md"
$currentTime = Get-Date -Format "yyyy-MM-dd HH:mm"

# 从数据库读取计划状态
$planProgress = mysql -h localhost -u root openclaw -N -e "SELECT plan_id, plan_name, status, current_round FROM plan_progress WHERE status='executing' LIMIT 1;" 2>$null
$stepExecutions = mysql -h localhost -u root openclaw -N -e "SELECT plan_id, round, agent_id, step_name, status FROM step_execution WHERE plan_id='plan-014';" 2>$null

# 解析数据
$planId = $planProgress[0].Split("`t")[0]
$planName = $planProgress[0].Split("`t")[1]
$planStatus = $planProgress[0].Split("`t")[2]
$currentRound = $planProgress[0].Split("`t")[3]

# 生成 Agent 状态
$agentStatus = @{}
foreach ($step in $stepExecutions) {
    $parts = $step.Split("`t")
    $agentId = $parts[2]
    $stepName = $parts[3]
    $status = $parts[4]
    $agentStatus[$agentId] = @{
        stepName = $stepName
        status = $status
    }
}

# 生成上下文文档
$context = @"
<!-- Last Modified: $currentTime -->

# TOOLS.md - 灌汤的本地笔记

## 📋 当前计划上下文（$currentTime 更新）

**⚠️ 重要：** 此章节是团队协作的基础，所有 Agent 必须阅读并理解。

### 活跃计划

| 计划 ID | 计划名称 | 优先级 | 当前轮次 | 状态 | 开始时间 |
|--------|---------|--------|---------|------|---------|
| $planId | $planName | P0 | R$currentRound | $planStatus | $currentTime |

---

### 各 Agent 当前任务

#### 🍖 酱肉 (后端)
- **当前计划:** $planId $planName
- **当前轮次:** R$currentRound
- **任务状态:** $($agentStatus['jiangrou'].status)
- **依赖:** 无
- **阻塞:** 无

#### 🍡 豆沙 (前端)
- **当前计划:** $planId $planName
- **当前轮次:** R$currentRound
- **任务状态:** $($agentStatus['dousha'].status)
- **依赖:** 无
- **阻塞:** 无

#### 🥬 酸菜 (运维)
- **当前计划:** $planId $planName
- **当前轮次:** R$currentRound
- **任务状态:** $($agentStatus['suancai'].status)
- **依赖:** 无
- **阻塞:** 无

---

### Agent 行为规范

**每次会话开始必须：**
1. 阅读此章节，了解当前计划上下文
2. 确认自己的任务和进度
3. 如有阻塞，立即更新状态并通知 PM

**任务执行中必须：**
1. 每 30 分钟主动汇报进度
2. 任务完成立即通知 PM 验收
3. 遇到阻塞立即上报

**任务完成后必须：**
1. 更新状态文件
2. 提交交付物
3. 等待 PM 分配下一轮任务

---

*计划上下文版本：v1.0 | 最后同步：$currentTime*
"@

$context | Out-File -FilePath $contextFile -Encoding utf8
Write-Host "Agent 上下文已同步：$currentTime"
