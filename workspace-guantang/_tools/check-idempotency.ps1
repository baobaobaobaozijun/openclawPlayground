# ============================================
# 任务派发幂等检查脚本
# 用途：派发前检查数据库，防止重复派发同一任务
# 用法：.\check-idempotency.ps1 -planId "plan-006" -roundId 1 -agentId "jiangrou"
# ============================================

param(
    [Parameter(Mandatory=$true)][string]$planId,
    [Parameter(Mandatory=$true)][int]$roundId,
    [Parameter(Mandatory=$true)][string]$agentId
)

$mysqlHost = "localhost"
$mysqlUser = "root"
$database = "baozipu"

# 查询任务状态
$checkQuery = @"
SELECT id, status, task_name, deliverable_path, retry_count, assigned_at
FROM pipeline_agent_tasks
WHERE plan_id = '$planId' AND round_id = $roundId AND agent_id = '$agentId';
"@

try {
    $result = $checkQuery | mysql -h $mysqlHost -u $mysqlUser $database -N 2>&1
    
    if ($null -eq $result -or $result -eq "") {
        # 任务不存在，可以安全派发
        Write-Host "✅ 幂等检查通过：任务不存在，可以派发" -ForegroundColor Green
        return @{ CanDispatch = $true; Reason = "Task not exists" }
    }
    
    # 解析结果
    $parts = $result -split "`t"
    $taskId = $parts[0]
    $status = $parts[1]
    $taskName = $parts[2]
    $deliverablePath = $parts[3]
    $retryCount = $parts[4]
    $assignedAt = $parts[5]
    
    Write-Host "📋 数据库中存在任务记录:" -ForegroundColor Yellow
    Write-Host "   任务 ID: $taskId" -ForegroundColor Gray
    Write-Host "   状态：$status" -ForegroundColor Gray
    Write-Host "   重试次数：$retryCount" -ForegroundColor Gray
    
    switch ($status) {
        'completed' {
            # 任务已完成，检查交付物是否存在
            if ($deliverablePath -and (Test-Path $deliverablePath)) {
                Write-Host "✅ 任务已完成，交付物存在，跳过派发" -ForegroundColor Green
                return @{ CanDispatch = $false; Reason = "Task completed"; TaskId = $taskId }
            } else {
                Write-Host "⚠️ 任务标记为完成但交付物不存在，需要重做" -ForegroundColor Yellow
                return @{ CanDispatch = $true; Reason = "Redo: completed but no deliverable"; TaskId = $taskId; Action = "redo" }
            }
        }
        'executing' {
            # 任务执行中，检查是否超时（>60 分钟）
            $timeoutQuery = @"
            SELECT TIMESTAMPDIFF(MINUTE, assigned_at, NOW()) as minutes
            FROM pipeline_agent_tasks
            WHERE id = $taskId;
"@
            $minutes = ($timeoutQuery | mysql -h $mysqlHost -u $mysqlUser $database -N 2>&1).Trim()
            
            if ([int]$minutes -gt 60) {
                Write-Host "⚠️ 任务执行超时 ($minutes 分钟)，需要重做" -ForegroundColor Yellow
                return @{ CanDispatch = $true; Reason = "Redo: timeout ($minutes min)"; TaskId = $taskId; Action = "redo" }
            } else {
                Write-Host "⏳ 任务正在执行中 ($minutes 分钟)，跳过派发" -ForegroundColor Yellow
                return @{ CanDispatch = $false; Reason = "Task executing ($minutes min)"; TaskId = $taskId }
            }
        }
        'failed' {
            # 任务失败，检查重试次数
            if ([int]$retryCount -ge 2) {
                Write-Host "❌ 任务已重试 2 次仍失败，需要 PM 介入" -ForegroundColor Red
                return @{ CanDispatch = $false; Reason = "Failed after 2 retries, need PM intervention"; TaskId = $taskId }
            } else {
                Write-Host "⚠️ 任务失败，可以重试 (第 $($retryCount + 1) 次)" -ForegroundColor Yellow
                return @{ CanDispatch = $true; Reason = "Retry after failure"; TaskId = $taskId; Action = "retry" }
            }
        }
        'assigned' {
            # 已分配但未开始，检查是否超时（>30 分钟）
            $timeoutQuery = @"
            SELECT TIMESTAMPDIFF(MINUTE, assigned_at, NOW()) as minutes
            FROM pipeline_agent_tasks
            WHERE id = $taskId;
"@
            $minutes = ($timeoutQuery | mysql -h $mysqlHost -u $mysqlUser $database -N 2>&1).Trim()
            
            if ([int]$minutes -gt 30) {
                Write-Host "⚠️ 任务已分配但未开始 ($minutes 分钟)，需要重新派发" -ForegroundColor Yellow
                return @{ CanDispatch = $true; Reason = "Re-dispatch: assigned but not started ($minutes min)"; TaskId = $taskId; Action = "redispatch" }
            } else {
                Write-Host "⏳ 任务已分配，等待 Agent 开始 ($minutes 分钟)" -ForegroundColor Yellow
                return @{ CanDispatch = $false; Reason = "Task assigned, waiting ($minutes min)"; TaskId = $taskId }
            }
        }
        default {
            Write-Host "⚠️ 未知状态 '$status'，可以派发" -ForegroundColor Yellow
            return @{ CanDispatch = $true; Reason = "Unknown status: $status" }
        }
    }
} catch {
    Write-Host "❌ 幂等检查失败：$_" -ForegroundColor Red
    # 检查失败时，默认允许派发（保守策略）
    return @{ CanDispatch = $true; Reason = "Check failed, allow dispatch"; Error = $_ }
}
