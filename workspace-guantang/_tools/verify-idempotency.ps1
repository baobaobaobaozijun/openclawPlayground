# ============================================
# 验证幂等机制
# ============================================

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  幂等机制验证" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

$mysqlHost = "localhost"
$mysqlUser = "root"
$database = "baozipu"

# 1. 检查唯一约束
Write-Host "1. 检查唯一约束..." -ForegroundColor Yellow
$indexResult = "SHOW INDEX FROM pipeline_agent_tasks WHERE Key_name = 'uk_plan_round_agent';" | mysql -h $mysqlHost -u $mysqlUser $database 2>&1

if ($indexResult -match "uk_plan_round_agent") {
    Write-Host "   ✅ 唯一约束已添加 (uk_plan_round_agent)" -ForegroundColor Green
} else {
    Write-Host "   ❌ 唯一约束不存在" -ForegroundColor Red
}

# 2. 检查计划数据
Write-Host "`n2. 检查计划数据..." -ForegroundColor Yellow
$planResult = "SELECT plan_id, status, current_round, total_rounds FROM pipeline_plans ORDER BY plan_id;" | mysql -h $mysqlHost -u $mysqlUser $database 2>&1
Write-Host $planResult -ForegroundColor Gray

# 3. 检查任务数据
Write-Host "`n3. 检查任务数据..." -ForegroundColor Yellow
$taskResult = "SELECT plan_id, round_id, agent_id, status FROM pipeline_agent_tasks LIMIT 10;" | mysql -h $mysqlHost -u $mysqlUser $database 2>&1
Write-Host $taskResult -ForegroundColor Gray

# 4. 测试幂等插入
Write-Host "`n4. 测试幂等插入..." -ForegroundColor Yellow
$testQuery = @"
INSERT INTO pipeline_agent_tasks (plan_id, round_id, agent_id, task_name, status, assigned_at)
VALUES ('plan-test', 1, 'jiangrou', 'Test Task', 'assigned', NOW())
ON DUPLICATE KEY UPDATE status='assigned', assigned_at=NOW();
"@

$testQuery | mysql -h $mysqlHost -u $mysqlUser $database 2>&1
Write-Host "   第一次插入..." -ForegroundColor Gray

$testQuery | mysql -h $mysqlHost -u $mysqlUser $database 2>&1
Write-Host "   第二次插入（应该触发 ON DUPLICATE KEY UPDATE）..." -ForegroundColor Gray

$checkResult = "SELECT * FROM pipeline_agent_tasks WHERE plan_id='plan-test';" | mysql -h $mysqlHost -u $mysqlUser $database 2>&1
Write-Host "   查询结果：" -ForegroundColor Gray
Write-Host "   $checkResult" -ForegroundColor Gray

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  验证完成" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan
