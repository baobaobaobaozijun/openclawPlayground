# ============================================
# 流水线状态恢复脚本
# 用途：系统启动/会话启动时自动执行，恢复中断的任务状态
# 触发：Gateway 启动时自动执行
# ============================================

$ErrorActionPreference = "Stop"
$mysqlHost = "localhost"
$mysqlUser = "root"
$database = "baozipu"

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  流水线状态恢复检查" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan

# 记录系统启动事件
$eventQuery = @"
INSERT INTO pipeline_system_events (event_type, event_data, recovery_status)
VALUES ('system_startup', '{"timestamp": "$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"}', 'recovering');
"@
$eventQuery | mysql -h $mysqlHost -u $mysqlUser $database 2>&1 | Out-Null

# 查询进行中的计划
$planQuery = @"
SELECT plan_id, plan_name, status, current_round, total_rounds
FROM pipeline_plans
WHERE status = 'executing'
ORDER BY created_at DESC
LIMIT 1;
"@

Write-Host "🔍 查询进行中的计划..." -ForegroundColor Yellow
$planResult = ($planQuery | mysql -h $mysqlHost -u $mysqlUser $database -N 2>&1)

if ($null -eq $planResult -or $planResult -eq "") {
    Write-Host "✅ 无进行中的计划，HEARTBEAT_OK" -ForegroundColor Green
    Write-Host "`n========================================`n" -ForegroundColor Cyan
    exit 0
}

$planParts = $planResult -split "`t"
$planId = $planParts[0]
$planName = $planParts[1]
$currentRound = $planParts[3]
$totalRounds = $planParts[4]

Write-Host "📋 发现进行中的计划：" -ForegroundColor Yellow
Write-Host "   计划 ID: $planId" -ForegroundColor Gray
Write-Host "   计划名称：$planName" -ForegroundColor Gray
Write-Host "   进度：$currentRound/$totalRounds 轮" -ForegroundColor Gray

# 查询最后一轮状态
$roundQuery = @"
SELECT round_id, status, interrupt_reason
FROM pipeline_rounds
WHERE plan_id = '$planId'
ORDER BY round_id DESC
LIMIT 1;
"@

$roundResult = ($roundQuery | mysql -h $mysqlHost -u $mysqlUser $database -N 2>&1)
$roundParts = $roundResult -split "`t"
$roundId = $roundParts[0]
$roundStatus = $roundParts[1]
$interruptReason = $roundParts[2]

Write-Host "`n📋 最后一轮状态：" -ForegroundColor Yellow
Write-Host "   轮次：$roundId" -ForegroundColor Gray
Write-Host "   状态：$roundStatus" -ForegroundColor Gray
if ($interruptReason) {
    Write-Host "   中断原因：$interruptReason" -ForegroundColor Gray
}

# 如果最后一轮被中断，需要恢复检查
if ($roundStatus -eq 'interrupted') {
    Write-Host "`n⚠️ 最后一轮被中断，开始恢复检查..." -ForegroundColor Yellow
    
    # 查询需要恢复检查的 Agent 任务
    $taskQuery = @"
    SELECT id, agent_id, task_name, deliverable_path, status, retry_count
    FROM pipeline_agent_tasks
    WHERE plan_id = '$planId' AND round_id = $roundId
      AND status IN ('unknown', 'executing', 'assigned');
    "@
    
    $tasks = ($taskQuery | mysql -h $mysqlHost -u $mysqlUser $database -N 2>&1)
    
    $completedCount = 0
    $failedCount = 0
    $recoveredTasks = @()
    
    foreach ($taskLine in $tasks) {
        $taskParts = $taskLine -split "`t"
        $taskId = $taskParts[0]
        $agentId = $taskParts[1]
        $taskName = $taskParts[2]
        $deliverablePath = $taskParts[3]
        $status = $taskParts[4]
        $retryCount = $taskParts[5]
        
        Write-Host "`n📋 检查任务：$taskName ($agentId)" -ForegroundColor Yellow
        
        if ($deliverablePath -and (Test-Path $deliverablePath)) {
            Write-Host "   ✅ 交付物存在，标记为 completed" -ForegroundColor Green
            
            # 更新数据库状态
            $updateQuery = @"
            UPDATE pipeline_agent_tasks
            SET status = 'completed', 
                completed_at = NOW(), 
                verified = FALSE
            WHERE id = $taskId;
"@
            $updateQuery | mysql -h $mysqlHost -u $mysqlUser $database 2>&1 | Out-Null
            
            # 记录状态变更历史
            $historyQuery = @"
            INSERT INTO pipeline_state_history (plan_id, round_id, agent_task_id, old_status, new_status, change_reason)
            VALUES ('$planId', $roundId, $taskId, '$status', 'completed', 'Recovery: file exists');
"@
            $historyQuery | mysql -h $mysqlHost -u $mysqlUser $database 2>&1 | Out-Null
            
            $completedCount++
            $recoveredTasks += @{ AgentId = $agentId; TaskName = $taskName; Action = "completed" }
        } else {
            Write-Host "   ❌ 交付物不存在" -ForegroundColor Red
            
            if ([int]$retryCount -ge 2) {
                Write-Host "   ⚠️ 已重试 2 次，标记为 failed，需要 PM 介入" -ForegroundColor Yellow
                
                $updateQuery = @"
                UPDATE pipeline_agent_tasks
                SET status = 'failed', 
                    failure_reason = 'Recovery: file missing after $retryCount retries'
                WHERE id = $taskId;
"@
                $updateQuery | mysql -h $mysqlHost -u $mysqlUser $database 2>&1 | Out-Null
                
                $failedCount++
                $recoveredTasks += @{ AgentId = $agentId; TaskName = $taskName; Action = "failed_need_pm" }
            } else {
                Write-Host "   ⚠️ 标记为 failed，可以重试" -ForegroundColor Yellow
                
                $updateQuery = @"
                UPDATE pipeline_agent_tasks
                SET status = 'failed', 
                    retry_count = retry_count + 1,
                    failure_reason = 'Recovery: file missing'
                WHERE id = $taskId;
"@
                $updateQuery | mysql -h $mysqlHost -u $mysqlUser $database 2>&1 | Out-Null
                
                $failedCount++
                $recoveredTasks += @{ AgentId = $agentId; TaskName = $taskName; Action = "failed_retry" }
            }
        }
    }
    
    # 更新轮次状态
    if ($failedCount -eq 0 -and $completedCount -gt 0) {
        # 所有任务都恢复了，可以进入下一轮
        $updateRoundQuery = @"
        UPDATE pipeline_rounds
        SET status = 'completed', 
            verified = TRUE, 
            completed_at = NOW(),
            interrupted_at = NULL,
            interrupt_reason = NULL
        WHERE plan_id = '$planId' AND round_id = $roundId;
"@
        $updateRoundQuery | mysql -h $mysqlHost -u $mysqlUser $database 2>&1 | Out-Null
        
        Write-Host "`n✅ 所有任务恢复成功，轮次标记为 completed" -ForegroundColor Green
    } else {
        # 有失败的任务，轮次保持 interrupted
        Write-Host "`n⚠️ 有 $failedCount 个任务失败，轮次保持 interrupted" -ForegroundColor Yellow
    }
    
    # 更新系统事件
    $updateEventQuery = @"
    UPDATE pipeline_system_events
    SET recovery_status = 'recovered',
        recovery_log = 'Recovered $completedCount tasks, $failedCount failed'
    WHERE event_type = 'system_startup' AND recovery_status = 'recovering'
    ORDER BY detected_at DESC
    LIMIT 1;
"@
    $updateEventQuery | mysql -h $mysqlHost -u $mysqlUser $database 2>&1 | Out-Null
    
    # 输出恢复报告
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "  恢复检查完成" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  恢复成功：$completedCount 个任务" -ForegroundColor Green
    Write-Host "  失败：$failedCount 个任务" -ForegroundColor $(if ($failedCount -gt 0) { "Red" } else { "Green" })
    Write-Host "`n  恢复详情:" -ForegroundColor Cyan
    foreach ($task in $recoveredTasks) {
        Write-Host "    - $($task.AgentId): $($task.TaskName) → $($task.Action)" -ForegroundColor Gray
    }
    Write-Host "========================================`n" -ForegroundColor Cyan
    
} else {
    Write-Host "`n✅ 最后一轮状态正常：$roundStatus" -ForegroundColor Green
}

Write-Host "`n========================================" -ForegroundColor Cyan
Write-Host "  流水线恢复检查完成" -ForegroundColor Cyan
Write-Host "========================================`n" -ForegroundColor Cyan
