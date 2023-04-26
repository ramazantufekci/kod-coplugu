Etki alanınızdaki proxy adresleri olmayan tüm kullanıcılara belirleyeceğimiz domainleri eklememize yardimci olacak harika bir Powershell betiği paylaşmak istiyorum, Set-ADUser komutunu kullanarak GivenName ve SurName’i otomatik olarak değiştirdiğimi ve proxyaddresses attribute değerinin güncellediğimi görebilirsiniz.

Eğer kullanıcıda ilgili attribute değeri var ise o kullanıcıda aksi bir işlem gerçekleşmemekte.

```powershell
Import-Module activedirectory
$newproxy = "@xx.com"
$newproxy2 = "@xx.onmicrosoft.com"
$newproxy3 = "@xx.mail.onmicrosoft.com"
$userou = "OU=TURKEY-TR,OU=Accounts,DC=xx,DC=xx"
$users = Get-ADUser -Filter ‘*’ -SearchBase $userou -Properties SamAccountName, ProxyAddresses
Foreach ($user in $users) {
Set-ADUser -server rns-xx.xx.xx-Identity $user.samaccountname -Add @{Proxyaddresses=”smtp:”+$user.samaccountname+””+$newproxy}
Set-ADUser -server rns-xx.xx.xx-Identity $user.samaccountname -Add @{Proxyaddresses=”smtp:”+$user.samaccountname+””+$newproxy2}
Set-ADUser -server rns-xx.xx.xx-Identity $user.samaccountname -Add @{Proxyaddresses=”smtp:”+$user.samaccountname+””+$newproxy3}
}
```
İşlem başarıyla gerçekleşti.

Peki ProxyAddress boş kalan kullanıcı kaldı mı? Aşağıdaki Powershell script sorgu atabiliriz,

```powershell
Get-ADUser -Filter * -SearchBase "OU=TURKEY-TR,OU=Accounts,DC=xx,DC=xx" -Properties  SamAccountName, proxyaddresses,enabled | 
select  SamAccountName,proxyaddresses,enabled | Where-Object {$_.proxyaddresses.count -eq 0 -and $_.enabled -eq 'True' }  
```
Peki bazı kullanıcılardan ya da tüm kullanıcılardan ProxyAddress alanının silinmesi için aşağıda belirtilen script ile ilerleyebiliriz.

CSV içerisinde belirtilen kullanıcının ProxyAddresses değeri silinir.
```powershell
#Remove ProxyAddresses from CSV:
$users = Get-Content "C:\temp\users.txt"
   foreach ($us in $users) {
       Set-ADUser $us -Clear ProxyAddresses
 }
 ```
