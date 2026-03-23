$now = Get-Date
@('jiangrou','dousha','suancai') | ForEach-Object {
  $agent = $_
  $latest = Get-ChildItem ("F:\openclaw\agent\workinglog\" + $agent) -File -ErrorAction SilentlyContinue | Sort-Object LastWriteTime -Descending | Select-Object -First 1
  if ($latest) {
    $diff = [math]::Round(($now - $latest.LastWriteTime).TotalMinutes, 0)
    Write-Output "$agent | $($latest.Name) | ${diff}min"
  } else {
    Write-Output "$agent | NO_FILES"
  }
}
