# ============================================
# 任务派发时更新数据库（带幂等检查）
# 用法：.\update-db-task-assigned.ps1 -planId "plan-006" -roundId 1 -agentId "jiangrou" -taskName "Task Name"
# ============================================

param(
    [Parameter(Mandatory=$true)][string]$planId,
    [Parameter(Mandatory=$true)][int]$roundId,
    [Parameter(Mandatory=$true)][string]$agentId,
    [Parameter(Mandatory=$true)][string]$taskName,
    [string]$taskDescription = "",
    [string]$deliverablePath = ""
)

$mysqlUser = "root"
$mysqlHost = "localhost"
$database = "baozipu"

Write-Host "🔍 执行幂等检查..." -ForegroundColor Yellow

# 步骤 1: 幂等检查
$checkResult = & "$PSScriptRoot\check-idempotency.ps1" -planId $planId -roundId $roundId -agentId $agentId

if (-not $checkResult.CanDispatch) {
    Write-Host "⏭️  跳过派发：$($checkResult.Reason)" -ForegroundColor Yellow
    exit 0
}

# 步骤 2: 根据检查结果决定操作
$action = if ($checkResult.Action) { $checkResult.Action } else { "new" }
Write-Host "📋 操作类型：$action" -ForegroundColor Yellow

# 更新计划状态
$updatePlan = @"
UPDATE pipeline_plans 
SET status = 'executing', current_round = $roundId
WHERE plan_id = '$planId';
"@

# 更新/插入轮次状态
$updateRound = @"
INSERT INTO pipeline_rounds (plan_id, round_id, round_name, status, started_at)
VALUES ('$planId', $roundId, '$taskName', 'executing', NOW())
ON DUPLICATE KEY UPDATE status = 'executing', started_at = NOW();
"@

# 插入/更新 Agent 任务（根据操作类型）
if ($action -eq "redo" -or $action -eq "retry" -or $action -eq "redispatch") {
    $taskId = $checkResult.TaskId
    $insertTask = @"
UPDATE pipeline_agent_tasks 
SET status = 'assigned', 
    assigned_at = NOW(), 
    retry_count = retry_count + 1,
    task_description = '$taskDescription',
    deliverable_path = '$deliverablePath'
WHERE id = $taskId;
"@
    $oldStatus = "failed"
} else {
    $insertTask = @"
INSERT INTO pipeline_agent_tasks (plan_id, round_id, agent_id, task_name, task_description, deliverable_path, status, assigned_at)
VALUES ('$planId', $roundId, '$agentId', '$taskName', '$taskDescription', '$deliverablePath', 'assigned', NOW())
ON DUPLICATE KEY UPDATE 
    status = 'assigned',
    assigned_at = NOW(),
    task_description = '$taskDescription',
    deliverable_path = '$deliverablePath';
"@
    $oldStatus = "pending"
}

# 记录状态变更历史
$insertHistory = @"
INSERT INTO pipeline_state_history (plan_id, round_id, old_status, new_status, change_reason, changed_by)
VALUES ('$planId', $roundId, '$oldStatus', 'assigned', 'Task dispatched ($action)', 'guantang');
"@

# 执行 SQL
try {
    $sql = "$updatePlan $updateRound $insertTask $insertHistory"
    $sql | mysql -h $mysqlHost -u $mysqlUser $database 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Database updated: $planId round $roundId assigned to $agentId ($action)" -ForegroundColor Green
    } else {
        Write-Host "❌ Database update failed" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    exit 1
}
