foreach($a in 'jiangrou','dousha','suancai'){
  $dir = "F:\openclaw\agent\workinglog\$a"
  if(Test-Path $dir){
    $f = Get-ChildItem $dir -File | Sort-Object LastWriteTime -Descending | Select-Object -First 1
    if($f){ Write-Host "$a : $($f.Name) | $($f.LastWriteTime)" }
    else { Write-Host "$a : NO_FILES" }
  } else { Write-Host "$a : DIR_NOT_FOUND" }
}
Write-Host "NOW : $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')"
