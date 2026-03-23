$now = Get-Date
foreach ($agent in @('jiangrou','dousha','suancai')) {
    $dir = "F:\openclaw\agent\workinglog\$agent"
    if (Test-Path $dir) {
        $f = Get-ChildItem $dir -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($f) {
            $diff = ($now - $f.LastWriteTime).TotalMinutes
            $status = if ($diff -lt 60) { 'OK' } elseif ($diff -lt 120) { 'WARN' } else { 'LOST' }
            Write-Output "$agent | $status | $([int]$diff)m | $($f.Name)"
        } else {
            Write-Output "$agent | EMPTY | no files"
        }
    } else {
        Write-Output "$agent | NODIR"
    }
}
