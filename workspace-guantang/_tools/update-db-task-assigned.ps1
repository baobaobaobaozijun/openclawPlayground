# ============================================
# 任务派发时更新数据库
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

# 插入 Agent 任务
$insertTask = @"
INSERT INTO pipeline_agent_tasks (plan_id, round_id, agent_id, task_name, task_description, deliverable_path, status, assigned_at)
VALUES ('$planId', $roundId, '$agentId', '$taskName', '$taskDescription', '$deliverablePath', 'assigned', NOW());
"@

# 记录状态变更历史
$insertHistory = @"
INSERT INTO pipeline_state_history (plan_id, round_id, old_status, new_status, change_reason, changed_by)
VALUES ('$planId', $roundId, 'pending', 'executing', 'Task dispatched', 'guantang');
"@

# 执行 SQL
try {
    $sql = "$updatePlan $updateRound $insertTask $insertHistory"
    $sql | mysql -h $mysqlHost -u $mysqlUser $database 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Database updated: $planId round $roundId assigned to $agentId" -ForegroundColor Green
    } else {
        Write-Host "❌ Database update failed" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    exit 1
}
