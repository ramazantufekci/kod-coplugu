kullanıcı klasörünün altında bulunan .ssh klasörüne config adında bir dosya oluşturulur ve ssh keyin yolu gösterilir.

```bash
Host 1.1.1.1
        User ubuntu
        IdentityFile ssh\key\yolu
        Port 571
```
```bash
ssh root@1.1.1.1 "dd if=/dev/disk/by-label/DOROOT | gzip -1 -" | dd of=image.gz
```
