$dirs = @(
  'F:\openclaw\agent\workinglog\jiangrou',
  'F:\openclaw\agent\workinglog\dousha',
  'F:\openclaw\agent\workinglog\suancai'
)
$now = Get-Date
foreach ($d in $dirs) {
  $name = Split-Path $d -Leaf
  $f = Get-ChildItem $d -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if ($f) {
    $age = ($now - $f.LastWriteTime).TotalMinutes
    $ts = $f.LastWriteTime.ToString('MM-dd HH:mm')
    Write-Output "${name}: ${ts} (${age} min ago) $($f.Name)"
  } else {
    Write-Output "${name}: NO FILES"
  }
}
