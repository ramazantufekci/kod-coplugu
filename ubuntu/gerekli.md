## Boyutu sıfır olan dosyaları siler
```find $dir -size 0 -type f -delete```

## N gün değişen dosyaları gösterir
```find /etc -mtime -1 -print```

## Debian mount.cifs
> paket olarak smbfs yi değil cifs-utils kurmalısın daha sonra
> aşağıdaki komutu vererek bağlantıyı yapabilirsin
```mount.cifs //server/paylasim /mnt/istediğinDosya```
> Bu kadar ama paylaşıma ulaşman için senden şifre isteyebilir.

> Domaindeki paylaşıma bağlanma
```mount.cifs //server/paylasim /mnt/istediğinDosya -o user=paylasim kullanıcı ismi,pass=şifre,dom=domain.local```

## Find komutu ile bulunan dosyaları belirtilen dizine taşır.
```find ~/dokuman/ -name "*docx" -exec mv {} ~/eski/ \;```

## Ayar dosyalarındaki # siz satırları getirir.
```grep -v "^#" /etc/squid/squid.conf | sed -e '/^$/d'```

## Dosya içinde arama
```find . -iname '*conf' | xargs grep 'kelime' -sl```
