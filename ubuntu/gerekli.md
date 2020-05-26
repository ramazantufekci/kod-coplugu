## Boyutu sıfır olan dosyaları siler
```find $dir -size 0 -type f -delete```

## N gün değişen dosyaları gösterir
```find /etc -mtime -1 -print```

## Debian mount.cifs
> paket olarak smbfs yi değil cifs-utils kurmalısın daha sonra
> aşağıdaki komutu vererek bağlantıyı yapabilirsin
```mount.cifs //server/paylasim /mnt/istediğinDosya```
> Bu kadar ama paylaşıma ulaşman için senden şifre isteyebilir.

## Find komutu ile bulunan dosyaları belirtilen dizine taşır.
```find ~/dokuman/ -name "*docx" -exec mv {} ~/eski/ \;```
