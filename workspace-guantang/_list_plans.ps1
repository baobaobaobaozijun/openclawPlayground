Get-ChildItem 'F:\openclaw\agent\doc\01-core\plan' -File | ForEach-Object { Write-Output $_.FullName }
