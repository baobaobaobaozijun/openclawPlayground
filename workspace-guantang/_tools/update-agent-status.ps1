# Agent 状态更新脚本
# 用途：Agent 任务开始/进度更新/任务完成时调用此脚本更新状态

param(
    [string]$agent,
    [string]$status,
    [string]$currentTask,
    [int]$progress,
    [string]$blockReason,
    [string]$estimatedCompletion
)

$statusDir = "F:\openclaw\agent\status"
if (!(Test-Path $statusDir)) {
    New-Item -ItemType Directory -Force -Path $statusDir | Out-Null
}

$statusFile = "$statusDir\$agent-status.json"
$lastUpdate = (Get-Date -Format "o")
$blocked = "false"
if ($status -eq "blocked") { $blocked = "true" }

$json = @"
{
  "agent": "$agent",
  "lastUpdate": "$lastUpdate",
  "status": "$status",
  "currentTask": "$currentTask",
  "progress": $progress,
  "subtasks": [],
  "blocked": $blocked,
  "blockReason": "$blockReason",
  "estimatedCompletion": "$estimatedCompletion"
}
"@

$json | Out-File -FilePath $statusFile -Encoding utf8
Write-Host "Agent $agent status updated: $status (progress: $progress%)"
