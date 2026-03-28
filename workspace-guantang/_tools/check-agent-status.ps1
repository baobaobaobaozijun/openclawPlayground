# Agent 状态检查脚本

$statusDir = "F:\openclaw\agent\status"
$dashboardPath = "F:\openclaw\agent\doc\05-progress\agent-status-dashboard.md"
$agents = @("jiangrou", "dousha", "suancai")

$currentTime = Get-Date -Format "yyyy-MM-dd HH:mm"
$nextTime = ((Get-Date).AddMinutes(5)).ToString("yyyy-MM-dd HH:mm")

$tableRows = @()

foreach ($agent in $agents) {
    $statusFile = "$statusDir\$agent-status.json"
    
    if (Test-Path $statusFile) {
        $status = Get-Content $statusFile | ConvertFrom-Json
        $lastUpdate = [DateTime]::Parse($status.lastUpdate)
        $diff = (Get-Date) - $lastUpdate
        $minutesAgo = [math]::Round($diff.TotalMinutes)
        
        if ($status.status -eq "executing") { $icon = "[OK]" }
        elseif ($status.status -eq "blocked") { $icon = "[WARN]" }
        elseif ($status.status -eq "completed") { $icon = "[DONE]" }
        else { $icon = "[IDLE]" }
        
        if ($minutesAgo -gt 35) {
            $icon = "[LOST]"
        }
        
        $row = "| " + $agent + " | " + $icon + " | " + $status.currentTask + " | " + $status.progress + "% | " + $minutesAgo + " 分钟前 | " + $status.estimatedCompletion + " | - |"
    } else {
        $row = "| " + $agent + " | [LOST] | - | - | 状态文件不存在 | - | - |"
    }
    $tableRows += $row
}

$dashboard = @"
<!-- Last Modified: $currentTime -->

# Agent 实时状态面板

**刷新频率：** 每 5 分钟自动刷新  
**负责人：** 灌汤 (PM)

---

## 实时状态

| Agent | 状态 | 当前任务 | 进度 | 最后更新 | 预计完成 | 下次汇报 |
|-------|------|---------|------|---------|---------|---------|
$($tableRows -join "`n")

---

## 状态说明

| 状态 | 图标 | 说明 |
|------|------|------|
| 执行中 | [OK] | 任务正常进行 |
| 阻塞 | [WARN] | 遇到阻碍，需要 PM 协调 |
| 空闲 | [IDLE] | 无任务 |
| 失联 | [LOST] | 超过 35 分钟未汇报 |
| 完成 | [DONE] | 任务完成，等待验收 |

---

*最后刷新：$currentTime*  
*下次刷新：$nextTime*
"@

$dashboard | Out-File -FilePath $dashboardPath -Encoding utf8
Write-Host "Agent 状态面板已更新：$currentTime"
