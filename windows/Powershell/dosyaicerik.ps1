$doc = Get-Content -Path .\Documents\Kitap1.csv
$df = ""
foreach($docu in $doc)
{
    Write-Host $docu
    $df+=$docu+";"
}
Set-Content -Path .\Documents\kisi.csv -Value $df
