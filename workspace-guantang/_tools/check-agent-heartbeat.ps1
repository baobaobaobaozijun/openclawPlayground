$agents = @('jiangrou','dousha','suancai')
$allNormal = $true

foreach ($agent in $agents) {
    $dir = "F:\openclaw\agent\workinglog\$agent"
    if (Test-Path $dir) {
        $latest = Get-ChildItem $dir -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if ($latest) {
            $mins = [math]::Round(((Get-Date) - $latest.LastWriteTime).TotalMinutes)
            if ($mins -gt 60) {
                Write-Host "$agent : LOST ($mins min)"
                $allNormal = $false
            } else {
                Write-Host "$agent : OK ($mins min)"
            }
        } else {
            Write-Host "$agent : NO_FILES"
            $allNormal = $false
        }
    } else {
        Write-Host "$agent : DIR_NOT_FOUND"
        $allNormal = $false
    }
}

if ($allNormal) {
    Write-Host "---HEARTBEAT_OK---"
}
