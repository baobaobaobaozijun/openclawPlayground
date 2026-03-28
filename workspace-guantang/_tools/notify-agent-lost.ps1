# Agent 失联自动提醒脚本

# 用途：发现 Agent 失联超过 35 分钟，自动发送 sessions_spawn 提醒

param(
    [string]$agent,
    [int]$minutesLost
)

$agentNames = @{
    "jiangrou" = "酱肉"
    "dousha" = "豆沙"
    "suancai" = "酸菜"
}

$agentName = $agentNames[$agent]

# 根据失联时长决定警告级别
if ($minutesLost -gt 60) {
    $level = "严重警告 🔴"
    $deadline = "5 分钟"
} elseif ($minutesLost -gt 35) {
    $level = "提醒 🟡"
    $deadline = "10 分钟"
} else {
    return  # 未达阈值
}

$task = @"
【PM 灌汤 — 进度检查 $level】

$agentName，系统检测到你已失联 $minutesLost 分钟。

**立即汇报：**
1. 当前任务进度（%）
2. 是否有技术阻碍
3. 预计完成时间

**$deadline 内回复。**
"@

Write-Host "📤 发送 $level 给 $agentName（失联 $minutesLost 分钟）"
Write-Host "任务内容：$task"

# 注意：实际执行需要调用 sessions_spawn 工具
# 此处仅输出提醒内容
