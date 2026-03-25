$now = Get-Date
foreach ($agent in @('jiangrou','dousha','suancai')) {
    $dir = "F:\openclaw\agent\workinglog\$agent"
    $latest = Get-ChildItem $dir -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($latest) {
        $diff = [math]::Round(($now - $latest.LastWriteTime).TotalMinutes, 0)
        Write-Output ('{0} | {1}min | {2}' -f $agent, $diff, $latest.Name)
    } else {
        Write-Output ('{0} | NO_FILES' -f $agent)
    }
}
