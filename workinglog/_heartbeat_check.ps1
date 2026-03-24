foreach($a in @('jiangrou','dousha','suancai')){
  $dir = "F:\openclaw\agent\workinglog\$a"
  $f = Get-ChildItem $dir -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if($f){
    $diff = [math]::Round(((Get-Date) - $f.LastWriteTime).TotalMinutes)
    Write-Output "$a : $($f.Name) | $diff min ago"
  } else {
    Write-Output "$a : NO_FILES"
  }
}
