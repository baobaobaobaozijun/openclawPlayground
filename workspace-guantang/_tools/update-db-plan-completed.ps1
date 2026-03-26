# ============================================
# 计划完成时更新数据库
# 用法：.\update-db-plan-completed.ps1 -planId "plan-006" -planName "My Plan"
# ============================================

param(
    [Parameter(Mandatory=$true)][string]$planId,
    [string]$planName = ""
)

$mysqlUser = "root"
$mysqlHost = "localhost"
$database = "baozipu"

# 更新计划状态
$updatePlan = @"
UPDATE pipeline_plans 
SET status = 'completed', completed_at = NOW()
WHERE plan_id = '$planId';
"@

# 记录状态变更历史
$insertHistory = @"
INSERT INTO pipeline_state_history (plan_id, old_status, new_status, change_reason, changed_by)
VALUES ('$planId', 'executing', 'completed', 'All rounds completed', 'guantang');
"@

# 执行 SQL
try {
    $sql = "$updatePlan $insertHistory"
    $sql | mysql -h $mysqlHost -u $mysqlUser $database 2>&1
    
    if ($LASTEXITCODE -eq 0) {
        Write-Host "✅ Database updated: $planId completed" -ForegroundColor Green
    } else {
        Write-Host "❌ Database update failed" -ForegroundColor Red
        exit 1
    }
} catch {
    Write-Host "❌ Error: $_" -ForegroundColor Red
    exit 1
}
