$files = Get-ChildItem 'F:\openclaw\code\backend\src\main\java\com\openclaw\dto\*.java'
foreach ($f in $files) {
    $hasData = Select-String -Path $f.FullName -Pattern '@Data' -Quiet
    Write-Output "$($f.Name): @Data=$hasData"
}
