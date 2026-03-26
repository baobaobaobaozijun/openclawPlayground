# ============================================
# 任务完成时更新数据库
# 用法：.\update-db-task-completed.ps1 -planId "plan-006" -roundId 1 -agentId "jiangrou"
# ============================================

param(
    [Parameter(Mandatory=$true)][string]$planId,
    [Parameter(Mandatory=$true)][int]$roundId,
    [Parameter(Mandatory=$true)][string]$agentId,
    [string]$gitCommitHash = ""
)

$mysqlUser = "root"
$mysqlHost = "localhost"
$database = "baozipu"

# 更新 Agent 任务状态
$updateTask = @"
UPDATE pipeline_agent_tasks 
SET status = 'completed', completed_at = NOW(), verified = 1, verified_at = NOW()
WHERE plan_id = '$planId' AND round_id = $roundId AND agent_id = '$agentId';
"@

# 更新轮次状态
$updateRound = @"
UPDATE pipeline_rounds 
SET status = 'completed', completed_at = NOW(), verified = 1, verified_at = NOW()
WHERE plan_id = '$planId' AND round_id = $roundId;
"@

# 记录状态变更历史
$insertHistory = @"
INSERT INTO pipeline_state_history (plan_id, round_id, old_status, new_status, change_reason, changed_by)
VALUES ('$planId', $roundId, 'executing', 'completed', 'Task completed', 'system');
"@

# 执行 SQL
try {
    $sql = "$updateTask $updateRound $insertHistory"
    $sql | mysql -h $mysqlHost -u $mysqlUser $database 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Database updated: $planId round $roundId completed by $agentId" -ForegroundColor Green
    } else {
        Write-Host "❌ Database update failed" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    exit 1
}
