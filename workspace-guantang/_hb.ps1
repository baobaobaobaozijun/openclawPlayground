$now = Get-Date
$agents = @('jiangrou','dousha','suancai')
foreach ($a in $agents) {
    $dir = "F:\openclaw\agent\workinglog\$a"
    if (Test-Path $dir) {
        $f = Get-ChildItem $dir -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($f) {
            $m = [math]::Round(($now - $f.LastWriteTime).TotalMinutes)
            Write-Output "$a | ${m}min | $($f.Name)"
        } else {
            Write-Output "$a | NO_FILES"
        }
    } else {
        Write-Output "$a | DIR_MISSING"
    }
}
