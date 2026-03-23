foreach($a in @('jiangrou','dousha','suancai')){
    $d = "F:\openclaw\agent\workinglog\$a"
    $f = Get-ChildItem $d -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if($f){
        $m = [math]::Round(((Get-Date) - $f.LastWriteTime).TotalMinutes)
        Write-Output "$a | $($f.Name) | ${m}min"
    } else {
        Write-Output "$a | NO_FILES"
    }
}
