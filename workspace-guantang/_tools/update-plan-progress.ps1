# 更新计划进度脚本
# 参数：$planId, $round, $agentId, $status, $deliveryPath

param(
    [string]$planId = $(throw "-planId is required"),
    [int]$round = $(throw "-round is required"),
    [string]$agentId = $(throw "-agentId is required"),
    [string]$status = $(throw "-status is required"),  # completed/failed
    [string]$deliveryPath = "",
    [string]$verifyResult = "pass"
)

# 数据库连接信息
$dbHost = "localhost"
$dbPort = "3306"
$dbUser = "root"
$dbPassword = ""
$dbName = "openclaw"

# 构建 MySQL 命令
$mysqlCmd = "mysql -h $dbHost -P $dbPort -u $dbUser"
if ($dbPassword) {
    $mysqlCmd += " -p$dbPassword"
}
$mysqlCmd += " $dbName -e"

# 更新 step_execution 的 SQL 语句
if ($status -eq "completed") {
    $updateStepSql = @"
UPDATE step_execution 
SET status = 'completed', 
    completed_at = NOW(), 
    verify_result = '$verifyResult',
    delivery_path = '$deliveryPath'
WHERE plan_id = '$planId' AND round = $round AND agent_id = '$agentId';
"@
    
    # 更新 plan_progress 的 SQL 语句
    $updatePlanSql = @"
UPDATE plan_progress 
SET current_round = current_round + 1,
    status = CASE 
      WHEN current_round >= total_rounds THEN 'completed'
      ELSE 'executing'
    END
WHERE plan_id = '$planId';
"@
} else {
    $updateStepSql = @"
UPDATE step_execution 
SET status = '$status', 
    error_message = '$deliveryPath'
WHERE plan_id = '$planId' AND round = $round AND agent_id = '$agentId';
"@
    
    $updatePlanSql = @"
UPDATE plan_progress 
SET status = 'blocked'
WHERE plan_id = '$planId';
"@
}

try {
    # 开启事务
    Invoke-Expression "$mysqlCmd `"START TRANSACTION;`""
    
    # 执行更新 SQL
    Invoke-Expression "$mysqlCmd `"$updateStepSql`""
    if ($status -eq "completed") {
        Invoke-Expression "$mysqlCmd `"$updatePlanSql`""
    }
    
    # 提交事务
    Invoke-Expression "$mysqlCmd `"COMMIT;`""
    
    Write-Output "Plan progress updated successfully (transaction committed)"
    exit 0
}
catch {
    # 回滚事务
    try {
        Invoke-Expression "$mysqlCmd `"ROLLBACK;`""
        Write-Warning "Transaction rolled back due to error"
    }
    catch {
        Write-Warning "Failed to rollback transaction"
    }
    Write-Error "Error updating plan progress: $($_.Exception.Message)"
    exit 1
}
