param(
    [string]$checkTime,
    [string]$jiangrouStatus,
    [string]$doushaStatus,
    [string]$suancaiStatus,
    [string]$action
)

$file = "F:\openclaw\agent\doc\05-progress\agent-heartbeat-dashboard.md"

if (-not (Test-Path $file)) {
    Write-Host "Dashboard file not found"
    exit 1
}

$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm"
$entry = @"

---

## 🔴 $checkTime 心跳检查 - 全员失联唤醒

**检查时间:** $timestamp
**检查结果:** 3/3 Agent 失联

| Agent | 失联时长 | 唤醒方式 | 响应状态 |
|-------|---------|---------|----------|
| 🍖 酱肉 | 67 分钟 | sessions_spawn | $jiangrouStatus |
| 🍡 豆沙 | 67 分钟 | sessions_spawn | $doushaStatus |
| 🥬 酸菜 | 68 分钟 | sessions_spawn | $suancaiStatus |

**行动:** $action

"@

$content = Get-Content $file -Raw -Encoding UTF8
$content + $entry | Set-Content $file -Encoding UTF8 -NoNewline
Write-Host "Dashboard updated successfully"
