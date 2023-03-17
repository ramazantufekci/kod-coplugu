#Düzenlecek Pardus iso kalıbı indirilir.
wget https://indir.pardus.org.tr/ISO/Pardus19/Pardus-19.4-1-XFCE-amd64.iso

#Dosya Hiyerarşisi için klasörler oluşturulur.
sudo mkdir -p /tmp/Pardus19/{_squash,_work,iso,newiso,newlive,project}

#Pardus Kalıbı Bağlanır
sudo mount -o loop ~/Downloads/Pardus-19.4-1-XFCE-amd64.iso /tmp/Pardus19/iso


#Filesquashfs dizine bağlanır
sudo mount -t squashfs /tmp/Pardus19/iso/live/filesystem.squashfs /tmp/Pardus19/_squash

# Gerekli dosyalar sistem dizine bağlanır
sudo mount -t overlay overlay -onoatime,lowerdir=/tmp/Pardus19/_squash,upperdir=/tmp/Pardus19/project,workdir=/tmp/Pardus19/_work /tmp/Pardus19/newlive


#Squashfs kalıbı systemd-nspawn yardımıyla sisteme bağlanır.
sudo systemd-nspawn --bind-ro=/etc/resolv.conf:/run/resolvconf/resolv.conf --setenv=RUNLEVEL=1 -D /tmp/Pardus19/newlive

...
Bu işlemden sonra özelliştireceğiniz tüm dosya ve paket yapısına ulaşacaksınız eklemek ve çıkartmak istediğiniz tüm paketleri,
Bu alanda gerçekleştirin.
...

# Çıkış işlemi
<ctrl-d>
#History nin silinmesi
sudo rm /tmp/Pardus19/newlive/root/.bash_history

#Yeni squashfs in hazırlanması için dosya transferi
sudo rsync -av --exclude live/filesystem.squashfs /tmp/Pardus19/iso/ /tmp/Pardus19/newiso/

# Yeni filesystem.squashfs oluşturulması
sudo mksquashfs /tmp/Pardus19/newlive /tmp/Pardus19/newiso/live/filesystem.squashfs -noappend -b 1048576 -comp xz -Xdict-size 100%


# Dosyaların Sistemden Kaldırılması
sudo umount /tmp/custom/_fs /tmp/custom/newlive /tmp/custom/iso

#Değişen dosyaların md5 ile imzalanması
(cd /tmp/Pardus19/newiso && find . -type f -print0 | xargs -0 md5sum | grep -v "\./md5sum.txt" ) | sudo tee /tmp/Pardus19/newiso/md5sum.txt

# Yeni iso dosyasının oluşturulması
cd /tmp/Pardus19/newiso &&  xorriso -as mkisofs -R -r -J -joliet-long -l -cache-inodes -iso-level 4 -isohybrid-mbr /usr/lib/ISOLINUX/isohdpfx.bin -partition_offset 16 -A Pardus -p live-build  -publisher Pardus -V "Pardus"  -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -isohybrid-apm-hfsplus -o ../Pardus19-remix.iso .
