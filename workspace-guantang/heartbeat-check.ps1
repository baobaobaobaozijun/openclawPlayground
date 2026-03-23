$now = Get-Date
foreach ($a in 'jiangrou','dousha','suancai') {
    $f = Get-ChildItem "F:\openclaw\agent\workinglog\$a" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($f) {
        $mins = [math]::Round(($now - $f.LastWriteTime).TotalMinutes)
        Write-Host "$a | $($f.Name) | ${mins}min ago"
    } else {
        Write-Host "$a | NO FILES"
    }
}
