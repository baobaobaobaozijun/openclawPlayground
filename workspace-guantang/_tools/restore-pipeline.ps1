# Pipeline State Recovery Script
# Triggered on Gateway startup

$ErrorActionPreference = "Stop"
$mysqlHost = "localhost"
$mysqlUser = "root"
$database = "baozipu"

Write-Host "`n========================================"
Write-Host "  Pipeline Recovery Check"
Write-Host "========================================`n"

# Query executing plans
$planQuery = "SELECT plan_id, plan_name, status, current_round, total_rounds FROM pipeline_plans WHERE status = 'executing' ORDER BY created_at DESC LIMIT 1;"

Write-Host "  Checking executing plans..."
$planResult = ($planQuery | mysql -h $mysqlHost -u $mysqlUser $database -N 2>&1)

if ($null -eq $planResult -or $planResult -eq "") {
    Write-Host "  No executing plans, HEARTBEAT_OK"
    Write-Host "`n========================================`n"
    exit 0
}

$planParts = $planResult -split "`t"
$planId = $planParts[0]
$planName = $planParts[1]
$currentRound = $planParts[3]
$totalRounds = $planParts[4]

Write-Host "  Found executing plan: $planId ($planName)"
Write-Host "  Progress: $currentRound/$totalRounds rounds"

# Query last round status
$roundQuery = "SELECT round_id, status, interrupt_reason FROM pipeline_rounds WHERE plan_id = '$planId' ORDER BY round_id DESC LIMIT 1;"
$roundResult = ($roundQuery | mysql -h $mysqlHost -u $mysqlUser $database -N 2>&1)
$roundParts = $roundResult -split "`t"
$roundId = $roundParts[0]
$roundStatus = $roundParts[1]

Write-Host "  Last round: $roundId, Status: $roundStatus"

if ($roundStatus -eq 'interrupted') {
    Write-Host "  Round interrupted, starting recovery..."
    
    $taskQuery = "SELECT id, agent_id, task_name, deliverable_path, status, retry_count FROM pipeline_agent_tasks WHERE plan_id = '$planId' AND round_id = $roundId AND status IN ('unknown', 'executing', 'assigned');"
    $tasks = ($taskQuery | mysql -h $mysqlHost -u $mysqlUser $database -N 2>&1)
    
    $completedCount = 0
    $failedCount = 0
    
    foreach ($taskLine in $tasks) {
        $taskParts = $taskLine -split "`t"
        $taskId = $taskParts[0]
        $agentId = $taskParts[1]
        $taskName = $taskParts[2]
        $deliverablePath = $taskParts[3]
        $retryCount = $taskParts[5]
        
        Write-Host "  Checking task: $taskName ($agentId)"
        
        if ($deliverablePath -and (Test-Path $deliverablePath)) {
            Write-Host "    Deliverable exists, marking completed"
            $updateQuery = "UPDATE pipeline_agent_tasks SET status = 'completed', completed_at = NOW() WHERE id = $taskId;"
            $updateQuery | mysql -h $mysqlHost -u $mysqlUser $database 2>&1 | Out-Null
            $completedCount++
        } else {
            Write-Host "    Deliverable missing"
            if ([int]$retryCount -ge 2) {
                Write-Host "    Already retried 2x, marking failed (PM intervention needed)"
                $updateQuery = "UPDATE pipeline_agent_tasks SET status = 'failed', failure_reason = 'File missing after $retryCount retries' WHERE id = $taskId;"
                $updateQuery | mysql -h $mysqlHost -u $mysqlUser $database 2>&1 | Out-Null
                $failedCount++
            } else {
                Write-Host "    Marking failed for retry"
                $updateQuery = "UPDATE pipeline_agent_tasks SET status = 'failed', retry_count = retry_count + 1 WHERE id = $taskId;"
                $updateQuery | mysql -h $mysqlHost -u $mysqlUser $database 2>&1 | Out-Null
                $failedCount++
            }
        }
    }
    
    if ($failedCount -eq 0 -and $completedCount -gt 0) {
        $updateRoundQuery = "UPDATE pipeline_rounds SET status = 'completed', verified = TRUE, completed_at = NOW() WHERE plan_id = '$planId' AND round_id = $roundId;"
        $updateRoundQuery | mysql -h $mysqlHost -u $mysqlUser $database 2>&1 | Out-Null
        Write-Host "  All tasks recovered, round marked completed"
    } else {
        Write-Host "  $failedCount tasks failed, round remains interrupted"
    }
    
    Write-Host "`n========================================"
    Write-Host "  Recovery Complete"
    Write-Host "========================================"
    Write-Host "  Recovered: $completedCount tasks"
    Write-Host "  Failed: $failedCount tasks"
    Write-Host "========================================`n"
    
} else {
    Write-Host "  Round status normal: $roundStatus"
}

Write-Host "`n========================================"
Write-Host "  Pipeline Recovery Done"
Write-Host "========================================`n"
