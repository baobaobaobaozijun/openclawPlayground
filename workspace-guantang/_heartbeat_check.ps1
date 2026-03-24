$agents = @('jiangrou','dousha','suancai')
$now = Get-Date
foreach($a in $agents){
    $dir = "F:\openclaw\agent\workinglog\$a"
    if(Test-Path $dir){
        $f = Get-ChildItem $dir -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1
        if($f){
            $diff = ($now - $f.LastWriteTime).TotalMinutes
            Write-Output ("{0}: {1} | {2:F0}min ago" -f $a, $f.Name, $diff)
        } else {
            Write-Output ("{0}: NO_FILES" -f $a)
        }
    } else {
        Write-Output ("{0}: DIR_MISSING" -f $a)
    }
}
