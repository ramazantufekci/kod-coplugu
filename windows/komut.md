#Komut satırı
> Active directory kullanıcısını local admine ekler

```echo net localgroup administrators DC\%username% /ADD>deneme.bat && deneme.bat```

> Local kullanıcı oluşturur ve onu local admine ekler.

```net user kullanici password /ADD && net localgroup administrators pcname\kullanici /ADD```
