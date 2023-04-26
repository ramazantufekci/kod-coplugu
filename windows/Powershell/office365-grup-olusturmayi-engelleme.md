Office 365 üzerinde tüm kullanıcılar varsayılan ayarlarda Office 365 gruplarını oluşturabilmekte. Bu da biz BT yöneticilerinin kontrolünden çıktığında ne bir isim standardına uygunluk ile karşılaşıyoruz ve de çöplük haline dönmüş bir grup sekmesi ile karşılaşıyoruz. Bu işlemleri son kullanıcıya bırakmak yerine bizler tarafından yönetilmesi daha doğru olmakta.

Connect-ExchangeOnline komutu ile konsola bağlandıktan sonra aşağıdaki komut ile Owa üzerinde group oluşturmayı devre dışı bırakabiliriz.

```powershell
Set-OwaMailboxPolicy -GroupCreationEnabled $false -Identity OwaMailboxPolicy-Default
```
