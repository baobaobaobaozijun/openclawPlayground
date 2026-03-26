# Agent 流水线状态恢复脚本
# 版本：v3.0
# 用途：系统启动/会话启动时自动执行流水线状态恢复检查
# 位置：F:\openclaw\agent\workspace-guantang\scripts\restore-pipeline.ps1

$ErrorActionPreference = "Stop"

# ============================================
# 配置
# ============================================
$scriptDir = Split-Path $MyInvocation.MyCommand.Path -Parent
$localConfig = "F:\openclaw\agent\.local\pipeline-db-config.ps1"

if (Test-Path $localConfig) {
    . $localConfig
} else {
    $dbHost = "localhost"
    $dbPort = "3306"
    $dbName = "baozipu"
    $dbUser = "root"
    $dbPass = "root123"
}

$workspaceBase = "F:\openclaw\agent"
$workinglogBase = "$workspaceBase\workinglog"

# ============================================
# 辅助函数
# ============================================

function Invoke-MySqlQuery {
    param(
        [string]$Host,
        [string]$Port,
        [string]$Database,
        [string]$User,
        [string]$Password,
        [string]$Query
    )
    
    # 使用 MySQL CLI 执行查询（避免 PowerShell MySQL 模块依赖）
    $connectionString = "-h $Host -P $Port -u $User -p$Password $Database"
    $result = mysql $connectionString -N -e "$Query" 2>$null
    return $result
}

function Test-Deliverable {
    param([string]$path)
    return Test-Path $path
}

function Test-WorkingLog {
    param(
        [string]$agent,
        [string]$taskName,
        [datetime]$expectedTime
    )
    
    $logPath = "$workinglogBase\$agent\*.md"
    $latest = Get-ChildItem $logPath -ErrorAction SilentlyContinue | 
        Sort-Object LastWriteTime -Descending | 
        Select-Object -First 1
    
    if ($null -eq $latest) {
        return $false
    }
    
    # 检查日志是否在预期时间范围内
    $timeDiff = (Get-Date) - $latest.LastWriteTime
    return $timeDiff.TotalMinutes -lt 30
}

function Write-Log {
    param([string]$message)
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[$timestamp] $message"
}

# ============================================
# 主恢复流程
# ============================================

Write-Log "🔍 开始流水线状态恢复检查..."

# 查询进行中的计划
$planQuery = @"
SELECT plan_id, plan_name, current_round, total_rounds, status
FROM pipeline_plans
WHERE status = 'executing'
LIMIT 1;
"@

try {
    $planResult = Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
        -User $dbUser -Password $dbPass -Query $planQuery
} catch {
    Write-Log "❌ 数据库连接失败：$_"
    Write-Log "⚠️ 跳过恢复检查，等待人工介入"
    exit 1
}

if ([string]::IsNullOrWhiteSpace($planResult)) {
    Write-Log "✅ 无进行中的计划，HEARTBEAT_OK"
    exit 0
}

Write-Log "🚀 发现进行中的计划：$planResult"

# 解析计划信息（假设返回格式：plan_id|plan_name|current_round|total_rounds|status）
$planParts = $planResult -split '\|'
$planId = $planParts[0]
$planName = $planParts[1]
$currentRound = $planParts[2]
$totalRounds = $planParts[3]

Write-Log "📋 计划详情：$planName (第 $currentRound/$totalRounds 轮)"

# 查询最后一轮状态
$roundQuery = @"
SELECT round_id, status, interrupt_reason
FROM pipeline_rounds
WHERE plan_id = '$planId'
ORDER BY round_id DESC
LIMIT 1;
"@

$roundResult = Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
    -User $dbUser -Password $dbPass -Query $roundQuery

if ([string]::IsNullOrWhiteSpace($roundResult)) {
    Write-Log "⚠️ 未找到轮次记录，可能计划刚创建"
    exit 0
}

$roundParts = $roundResult -split '\|'
$roundId = $roundParts[0]
$roundStatus = $roundParts[1]
$interruptReason = $roundParts[2]

Write-Log "📊 最后一轮状态：$roundStatus (第 $roundId 轮)"

if ($roundStatus -ne 'interrupted') {
    Write-Log "✅ 最后一轮状态正常，无需恢复"
    exit 0
}

Write-Log "⚠️ 最后一轮被中断：原因 = $interruptReason"

# 查询需要恢复检查的 Agent 任务
$taskQuery = @"
SELECT id, agent_id, task_name, deliverable_path, status, retry_count
FROM pipeline_agent_tasks
WHERE plan_id = '$planId' AND round_id = $roundId
  AND status IN ('unknown', 'executing', 'assigned');
"@

$tasks = Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
    -User $dbUser -Password $dbPass -Query $taskQuery

if ([string]::IsNullOrWhiteSpace($tasks)) {
    Write-Log "✅ 无需恢复的 Agent 任务"
    exit 0
}

Write-Log "📋 发现 $($tasks.Count) 个需要恢复检查的任务"

# 逐个检查任务
foreach ($task in $tasks) {
    $taskParts = $task -split '\|'
    $taskId = $taskParts[0]
    $agentId = $taskParts[1]
    $taskName = $taskParts[2]
    $deliverablePath = $taskParts[3]
    $currentStatus = $taskParts[4]
    $retryCount = $taskParts[5]
    
    Write-Log "  🔍 检查 $agentId 任务：$taskName"
    
    $newStatus = "unknown"
    $changeReason = ""
    
    # 检查交付文件
    if (Test-Deliverable -path $deliverablePath) {
        Write-Log "    ✅ 文件存在：$deliverablePath"
        
        # 检查工作日志
        if (Test-WorkingLog -agent $agentId -taskName $taskName -expectedTime (Get-Date)) {
            Write-Log "    ✅ 工作日志存在"
            $newStatus = "completed"
            $changeReason = "file_and_log_exist_after_shutdown"
        } else {
            Write-Log "    ⚠️ 工作日志缺失，标记为需补录"
            $newStatus = "completed"
            $changeReason = "file_exists_but_log_missing"
        }
    } else {
        Write-Log "    ❌ 文件不存在"
        $newStatus = "failed"
        $changeReason = "file_missing_after_shutdown"
    }
    
    # 更新数据库状态
    if ($newStatus -eq "completed") {
        $updateQuery = @"
        UPDATE pipeline_agent_tasks
        SET status = 'completed', verified = FALSE
        WHERE id = $taskId;
"@
    } elseif ($newStatus -eq "failed") {
        $updateQuery = @"
        UPDATE pipeline_agent_tasks
        SET status = 'failed', retry_count = retry_count + 1,
            failure_reason = '$changeReason'
        WHERE id = $taskId;
"@
    } else {
        $updateQuery = @"
        UPDATE pipeline_agent_tasks
        SET status = 'unknown'
        WHERE id = $taskId;
"@
    }
    
    try {
        Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
            -User $dbUser -Password $dbPass -Query $updateQuery
        Write-Log "    📝 状态已更新：$newStatus"
    } catch {
        Write-Log "    ❌ 更新失败：$_"
    }
    
    # 记录状态变更历史
    $historyQuery = @"
    INSERT INTO pipeline_state_history (plan_id, round_id, agent_task_id, old_status, new_status, change_reason)
    VALUES ('$planId', $roundId, $taskId, '$currentStatus', '$newStatus', '$changeReason');
"@
    
    try {
        Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
            -User $dbUser -Password $dbPass -Query $historyQuery
    } catch {
        Write-Log "    ⚠️ 历史记录写入失败：$_"
    }
}

# 记录系统事件
$eventQuery = @"
INSERT INTO pipeline_system_events (event_type, event_data, recovery_status)
VALUES ('system_startup', '{"plan_id": "$planId", "round_id": $roundId, "tasks_checked": true}', 'recovering');
"@

try {
    Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
        -User $dbUser -Password $dbPass -Query $eventQuery
    Write-Log "📝 系统事件已记录"
} catch {
    Write-Log "⚠️ 系统事件记录失败：$_"
}

Write-Log "✅ 恢复检查完成"
Write-Log "📊 下一步：根据恢复结果派发任务或通知 PM"

exit 0
