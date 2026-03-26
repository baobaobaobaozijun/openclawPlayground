# Plan Manager v2 - 查询计划（从数据库）
# 用法：.\query-plan.ps1 -plan-id "007"

param(
    [Parameter(Mandatory=$true)]
    [string]$planId
)

$ErrorActionPreference = "Stop"

# 配置
$dbConfig = "F:\openclaw\agent\.local\pipeline-db-config.ps1"

# 加载数据库配置
if (Test-Path $dbConfig) {
    . $dbConfig
} else {
    Write-Host "错误：数据库配置文件不存在" -ForegroundColor Red
    exit 1
}

Write-Host "查询计划：Plan-$planId" -ForegroundColor Cyan
Write-Host ""

# 1. 查询计划主表
$planQuery = @"
SELECT plan_id, plan_name, priority, status, current_round, total_rounds, created_at, updated_at, completed_at
FROM pipeline_plans
WHERE plan_id = 'plan-$planId';
"@

try {
    $planResult = mysql -h $dbHost -P $dbPort -u $dbUser -p$dbPass $dbName -N -e $planQuery 2>$null
} catch {
    Write-Host "错误：数据库查询失败：$_" -ForegroundColor Red
    exit 1
}

if ([string]::IsNullOrWhiteSpace($planResult)) {
    Write-Host "未找到计划：Plan-$planId" -ForegroundColor Yellow
    Write-Host "提示：计划可能是在 v1 版本创建的（无数据库记录）" -ForegroundColor Yellow
    exit 0
}

# 解析结果
$plan = $planResult -split '\|'
$planId = $plan[0]
$planName = $plan[1]
$priority = $plan[2]
$status = $plan[3]
$currentRound = $plan[4]
$totalRounds = $plan[5]
$createdAt = $plan[6]
$updatedAt = $plan[7]
$completedAt = $plan[8]

# 状态图标
$statusIcon = switch ($status) {
    "pending" { "⏳ 等待" }
    "executing" { "🟢 执行中" }
    "completed" { "✅ 完成" }
    "blocked" { "🔴 阻塞" }
    "cancelled" { "❌ 取消" }
    default { $status }
}

# 输出计划信息
Write-Host "计划编号：$planId" -ForegroundColor White
Write-Host "计划名称：$priority - $planName" -ForegroundColor White
Write-Host "优先级：$priority" -ForegroundColor White
Write-Host "状态：$statusIcon" -ForegroundColor $(if ($status -eq "completed") { "Green" } else { "Yellow" })
Write-Host "当前轮次：$currentRound / $totalRounds" -ForegroundColor White
Write-Host "创建时间：$createdAt" -ForegroundColor Gray
Write-Host "更新时间：$(if ($updatedAt) { $updatedAt } else { "-" })" -ForegroundColor Gray
if ($completedAt) {
    Write-Host "完成时间：$completedAt" -ForegroundColor Green
}
Write-Host ""

# 2. 查询轮次进度
Write-Host "轮次进度:" -ForegroundColor Cyan

$roundQuery = @"
SELECT round_id, round_name, status, verified, started_at, completed_at
FROM pipeline_rounds
WHERE plan_id = 'plan-$planId'
ORDER BY round_id;
"@

$rounds = mysql -h $dbHost -P $dbPort -u $dbUser -p$dbPass $dbName -N -e $roundQuery 2>$null

foreach ($round in $rounds) {
    $r = $round -split '\|'
    $roundId = $r[0]
    $roundName = $r[1]
    $roundStatus = $r[2]
    $verified = $r[3]
    $completedAt = $r[5]
    
    $icon = switch ($roundStatus) {
        "pending" { "⏳" }
        "executing" { "🟢" }
        "completed" { "✅" }
        "failed" { "❌" }
        "interrupted" { "⚠️" }
        default { "⏳" }
    }
    
    $timeInfo = ""
    if ($completedAt) {
        $timeInfo = " ($(Get-Date $completedAt -Format 'MM-dd HH:mm'))"
    }
    
    Write-Host "  第$roundId 轮：$icon $roundName$timeInfo" -ForegroundColor $(if ($roundStatus -eq "completed") { "Green" } else { "Gray" })
}

Write-Host ""

# 3. 查询 Agent 任务（如有）
$taskQuery = @"
SELECT agent_id, task_name, status, completed_at
FROM pipeline_agent_tasks
WHERE plan_id = 'plan-$planId'
ORDER BY round_id, agent_id;
"@

$tasks = mysql -h $dbHost -P $dbPort -u $dbUser -p$dbPass $dbName -N -e $taskQuery 2>$null

if (-not [string]::IsNullOrWhiteSpace($tasks)) {
    Write-Host "Agent 任务:" -ForegroundColor Cyan
    
    foreach ($task in $tasks) {
        $t = $task -split '\|'
        $agentId = $t[0]
        $taskName = $t[1]
        $taskStatus = $t[2]
        
        $icon = switch ($taskStatus) {
            "pending" { "⏳" }
            "executing" { "🟢" }
            "completed" { "✅" }
            "failed" { "❌" }
            "unknown" { "⚠️" }
            default { "⏳" }
        }
        
        Write-Host "  $agentId : $taskName - $icon" -ForegroundColor $(if ($taskStatus -eq "completed") { "Green" } else { "Gray" })
    }
    Write-Host ""
}

# 4. 查询状态历史（最近 5 条）
$historyQuery = @"
SELECT old_status, new_status, change_reason, changed_at
FROM pipeline_state_history
WHERE plan_id = 'plan-$planId'
ORDER BY changed_at DESC
LIMIT 5;
"@

$history = mysql -h $dbHost -P $dbPort -u $dbUser -p$dbPass $dbName -N -e $historyQuery 2>$null

if (-not [string]::IsNullOrWhiteSpace($history)) {
    Write-Host "最近变更:" -ForegroundColor Cyan
    
    foreach ($h in $history) {
        $parts = $h -split '\|'
        $oldStatus = $parts[0]
        $newStatus = $parts[1]
        $reason = $parts[2]
        $changedAt = $parts[3]
        
        Write-Host "  $changedAt : $oldStatus → $newStatus ($reason)" -ForegroundColor Gray
    }
}

Write-Host ""
Write-Host "数据库状态：✅ 已同步" -ForegroundColor Green
