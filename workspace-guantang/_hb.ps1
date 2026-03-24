$now = Get-Date
foreach ($a in @('jiangrou','dousha','suancai')) {
    $dir = "F:\openclaw\agent\workinglog\$a"
    $f = Get-ChildItem $dir -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($f) {
        $d = [math]::Round(($now - $f.LastWriteTime).TotalMinutes)
        Write-Output "${a}: $($f.Name) (${d}min ago)"
    } else {
        Write-Output "${a}: NO FILES"
    }
}
