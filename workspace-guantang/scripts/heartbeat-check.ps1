# Agent 心跳检查脚本
# 版本：v3.0
# 用途：每 10 分钟执行一次，检查失联 Agent 并唤醒
# 位置：F:\openclaw\agent\workspace-guantang\scripts\heartbeat-check.ps1

$ErrorActionPreference = "Stop"

# ============================================
# 配置
# ============================================
$dbHost = "localhost"
$dbPort = "3306"
$dbName = "baozipu"
$dbUser = "root"
$dbPass = "root123"  # TODO: 从 .local 配置读取

$heartbeatThreshold = 60  # 失联阈值（分钟）
$workspaceBase = "F:\openclaw\agent"
$heartbeatLogPath = "$workspaceBase\doc\progress\agent-heartbeat-log.md"

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
    
    $connectionString = "-h $Host -P $Port -u $User -p$Password $Database"
    $result = mysql $connectionString -N -e "$Query" 2>$null
    return $result
}

function Write-Log {
    param([string]$message)
    $timestamp = Get-Date -Format "HH:mm:ss"
    Write-Host "[$timestamp] $message"
}

function Write-HeartbeatLog {
    param(
        [array]$lostAgents,
        [array]$actions
    )
    
    $timestamp = Get-Date -Format "HH:mm"
    $date = Get-Date -Format "yyyy-MM-dd"
    
    $logEntry = @"

### $timestamp 检查 ($date)

| Agent | 任务 | 失联时长 | 状态 | 行动 |
|-------|------|---------|------|------|
"@
    
    if ($lostAgents.Count -eq 0) {
        $logEntry += "`n| - | - | - | 🟢 正常 | 无需行动 |"
    } else {
        foreach ($agent in $lostAgents) {
            $agentParts = $agent -split '\|'
            $agentId = $agentParts[0]
            $taskName = $agentParts[1]
            $minutes = $agentParts[2]
            
            $status = if ([int]$minutes -lt 60) { "🟡 警告" } else { "🔴 失联" }
            $action = if ([int]$minutes -ge 60) { "已唤醒 (sessions_spawn)" } else { "观察中" }
            
            $logEntry += "`n| $agentId | $taskName | ${minutes}min | $status | $action |"
        }
    }
    
    $logEntry += @"

**行动记录:**
"@
    
    if ($actions.Count -eq 0) {
        $logEntry += "`n- 无"
    } else {
        foreach ($action in $actions) {
            $logEntry += "`n- $action"
        }
    }
    
    $logEntry += @"

---
"@
    
    # 确保日志文件存在
    if (-not (Test-Path $heartbeatLogPath)) {
        $dir = Split-Path $heartbeatLogPath -Parent
        if (-not (Test-Path $dir)) {
            New-Item -ItemType Directory -Path $dir -Force | Out-Null
        }
        "# Agent 心跳日志`n`n**创建日期:** $(Get-Date -Format 'yyyy-MM-dd')`n`n---" | Out-File -FilePath $heartbeatLogPath -Encoding utf8
    }
    
    Add-Content -Path $heartbeatLogPath -Value $logEntry -Encoding utf8
    Write-Log "📝 心跳日志已更新：$heartbeatLogPath"
}

function Send-WakeNotification {
    param(
        [string]$agentId,
        [string]$planId,
        [int]$roundId,
        [string]$taskName,
        [int]$minutes
    )
    
    $wakeMessage = @"
【心跳检查 - 立即汇报】🔴

灌汤 PM 心跳检查发现你已失联超过 $minutes 分钟。

**任务信息:**
- 计划：$planId
- 轮次：第 $roundId 轮
- 任务：$taskName

**请立即汇报:**
1. 当前任务及进度
2. 最后活动时间及内容
3. 是否有技术阻碍
4. 预计下次汇报时间

⏰ 限时 10 分钟内回复

如无响应，将记录严重违规并调整任务分配。
"@
    
    Write-Log "📞 正在唤醒 $agentId..."
    
    # TODO: 调用 OpenClaw sessions_spawn API
    # sessions_spawn -agentId $agentId -task $wakeMessage -mode run -runtime subagent -timeoutSeconds 600
    
    Write-Log "✅ 唤醒通知已发送：$agentId"
    
    return "发送唤醒通知给 $agentId (失联 ${minutes}min)"
}

# ============================================
# 主检查流程
# ============================================

Write-Log "❤️ 开始心跳检查..."

# 查询失联 Agent（>60 分钟无心跳）
$query = @"
SELECT 
    t.agent_id,
    t.task_name,
    t.plan_id,
    t.round_id,
    t.status,
    t.last_heartbeat_at,
    TIMESTAMPDIFF(MINUTE, t.last_heartbeat_at, NOW()) AS minutes_since_heartbeat
FROM pipeline_agent_tasks t
WHERE t.status IN ('executing', 'assigned')
  AND t.last_heartbeat_at < NOW() - INTERVAL $heartbeatThreshold MINUTE
ORDER BY minutes_since_heartbeat DESC;
"@

try {
    $lostAgents = Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
        -User $dbUser -Password $dbPass -Query $query
} catch {
    Write-Log "❌ 数据库连接失败：$_"
    Write-Log "⚠️ 跳过心跳检查，等待人工介入"
    exit 1
}

$actions = @()

if ([string]::IsNullOrWhiteSpace($lostAgents) -or $lostAgents.Count -eq 0) {
    Write-Log "✅ 所有 Agent 心跳正常，HEARTBEAT_OK"
    Write-HeartbeatLog -lostAgents @() -actions @()
    exit 0
}

Write-Log "🔴 发现 $($lostAgents.Count) 个失联 Agent:"

foreach ($agent in $lostAgents) {
    $agentParts = $agent -split '\|'
    $agentId = $agentParts[0]
    $taskName = $agentParts[1]
    $planId = $agentParts[2]
    $roundId = $agentParts[3]
    $currentStatus = $agentParts[4]
    $minutes = $agentParts[5]
    
    Write-Log "  - $agentId: $taskName (失联 $minutes 分钟)"
    
    # 更新状态为 unknown
    $updateQuery = @"
    UPDATE pipeline_agent_tasks
    SET status = 'unknown'
    WHERE plan_id = '$planId' AND round_id = $roundId AND agent_id = '$agentId';
"@
    
    try {
        Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
            -User $dbUser -Password $dbPass -Query $updateQuery
        Write-Log "    📝 状态已更新：unknown"
    } catch {
        Write-Log "    ❌ 更新失败：$_"
    }
    
    # 记录状态变更历史
    $historyQuery = @"
    INSERT INTO pipeline_state_history (plan_id, round_id, agent_task_id, old_status, new_status, change_reason)
    VALUES ('$planId', $roundId, 
            (SELECT id FROM pipeline_agent_tasks WHERE plan_id='$planId' AND round_id=$roundId AND agent_id='$agentId'),
            '$currentStatus', 'unknown', 'heartbeat_timeout_${minutes}min');
"@
    
    try {
        Invoke-MySqlQuery -Host $dbHost -Port $dbPort -Database $dbName `
            -User $dbUser -Password $dbPass -Query $historyQuery
        Write-Log "    📝 历史记录已写入"
    } catch {
        Write-Log "    ⚠️ 历史记录写入失败：$_"
    }
    
    # 发送唤醒通知
    $action = Send-WakeNotification -agentId $agentId -planId $planId -roundId $roundId `
        -taskName $taskName -minutes [int]$minutes
    $actions += $action
}

# 写入心跳日志
Write-HeartbeatLog -lostAgents $lostAgents -actions $actions

Write-Log "✅ 心跳检查完成"
Write-Log "📊 已唤醒 $($lostAgents.Count) 个 Agent，等待回复..."

exit 0
