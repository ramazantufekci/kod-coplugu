## Active Ditectory de Group a Kullanıcı Ekleme

Organization unit de bulunan kullanıcıları gruba ekler
```
get-aduser -Filter 'Enabled -eq $true' -SearchBase "OU=satiscilar,DC=example,DC=local"|%{Add-ADGroupMember -Identity PAYLASIM_IZIN_READ -Members $_.SamAccountName}
```
