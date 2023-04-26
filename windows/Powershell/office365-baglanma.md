PowerShell ile Office 365’e bağlanmak, GUI’de bulunmayan birçok işlevi gerçekleştirmenize olanak tanır.
Ama ya bu işlevleri otomatikleştirmek istiyorsanız.
PowerShell ile Office 365’e bağlanmak, o oturum için sizden kimlik bilgilerini isteyecektir.
Artık kimlik bilgileri komut dosyasına kaydedilebilir, ancak bu, parolanızın bir dosyaya kaydedilmesi bir güvenlik sorunu olur.
Bunu aşmanın yolu, şifrenizi bir metin dosyasında güvenli bir şekilde kaydetmek ve kayıtlı parolayı metinden çağırmak olacaktır.

```powershell
Read-Host -Prompt "Parolanızı giriniz." -AsSecureString | ConvertFrom-SecureString | Out-File "C:\Scripts\Pass.txt"
```

Bu işlem sonrasında parola girmemiz istenecek, girmiş olduğumuz parola c dizini altında bulunan scripts klasöründe pass.txt altında şifreli şekilde yer alacaktır.

Bu işlem sonrasında Office 365 bağlantısı nasıl yapılacağını görelim.

```powershell
$AdminName = "xxn@xx.onmicrosoft.com"
$Pass = Get-Content "C:\Scripts\Pass.txt" | ConvertTo-SecureString
$Cred = new-object -typename System.Management.Automation.PSCredential -argumentlist $AdminName, $Pass
```

Yukarıdaki adımda admin kullanıcı bilgimizi değişkenimize atayıp, parolamızı ilgili txt den çekerek bağlantı işlemini gerçekleştirebiliriz.

Bağlantı sonrasında Get-Mailbox ve benzeri komutları çalıştırarak sorguların yanıt verdiğini görebiliriz.
