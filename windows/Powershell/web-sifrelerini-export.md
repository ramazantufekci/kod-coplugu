# Denetim masasında bulunan web kimlik bilgilerini dışarı aktarır.


```
[void]
[Windows.Security.Credentials.PasswordVault,Windows.Security.Credentials,ContentType=WindowsRuntime]
$vault = New-Object Windows.Security.Credentials.PasswordVault
$vault.RetrieveAll() | % { $_.RetrievePassword();$_ }|export-csv -Path D:\sifreler.csv
```
