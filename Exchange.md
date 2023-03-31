Exchange 2019 toplu olarak junk mail ayarı mail adresini güvenli olarak ekler.
```powershell
get-mailbox -RecipientTypeDetails UserMailbox |?{Set-MailboxJunkEmailConfiguration -Identity $_.name -TrustedSendersAndDomains @{Add="mail@adresi.com"}}
```
