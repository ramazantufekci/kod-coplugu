Klasörde bulunan alt klasörleri istediğiniz yerde yeniden oluşturur.

```get-childitem "\\192.168.1.2\d$\paylasim" -Directory |%{New-Item -Path "." -Name $_.Name -It
emType "directory"}```
