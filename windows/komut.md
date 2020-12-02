#Komut satırı
> Active directory kullanıcısını local admine ekler

```echo net localgroup administrators DC\%username% /ADD>deneme.bat && deneme.bat```

> Local kullanıcı oluşturur ve onu local admine ekler.

```net user kullanici password /ADD && net localgroup administrators pcname\kullanici /ADD```
> Komut satırından uzak masaüstünü açar. Sondaki 1 Güvenlik seviyesini ayarlar(Aynı ağda olanlar bağlansın şu kullanıcı bağlansın gibi) 

```wmic /node:clientc rdtoggle where AllowTSConnections="0" call SetAllowTSConnections "1"```

> Komut satırından güncelleştirme paketi yükleme

```pkgmgr /ip /m:c:\updatedosyası\paket adı.cab```

