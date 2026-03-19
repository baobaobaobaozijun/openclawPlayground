Get-ChildItem -Path 'F:\openclaw\code' -Recurse -Include '*.java','*.xml','*.yml','*.yaml','*.properties','*.ts','*.json' -ErrorAction SilentlyContinue | Select-String -Pattern 'redis','Redis','REDIS' | ForEach-Object {
  $p = $_.Path
  $n = $_.LineNumber
  $l = $_.Line.Trim()
  Write-Output "${p}:${n}: ${l}"
}
