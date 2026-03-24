$now = Get-Date
foreach ($a in @('jiangrou','dousha','suancai')) {
    $f = Get-ChildItem "F:\openclaw\agent\workinglog\$a" -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if ($f) {
        $d = ($now - $f.LastWriteTime).TotalMinutes
        if ($d -lt 60) { $s = 'G' } elseif ($d -lt 120) { $s = 'Y' } else { $s = 'R' }
        Write-Output "$a|$s|$([math]::Round($d))|$($f.Name)"
    } else {
        Write-Output "$a|R|9999|none"
    }
}
