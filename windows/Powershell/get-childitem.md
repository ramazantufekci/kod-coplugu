Klasörde bulunan alt klasörleri istediğiniz yerde yeniden oluşturur.

```POWERSHELL
get-childitem "\\192.168.1.2\d$\paylasim" -Directory |%{New-Item -Path "." -Name $_.Name -ItemType "directory"}
```
