$now = Get-Date
@('jiangrou','dousha','suancai') | ForEach-Object {
  $a = $_
  $dir = "F:\openclaw\agent\workinglog\$a"
  $f = Get-ChildItem $dir -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if ($f) {
    $m = [math]::Round(($now - $f.LastWriteTime).TotalMinutes)
    "$a : $($f.Name) (${m}min ago)"
  } else {
    "$a : NO FILES"
  }
}
