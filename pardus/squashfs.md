sudo mount -o bind /run/ squashfs-root/run
sudo mount --bind /dev/ squashfs-root/dev
sudo chroot squashfs-root
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts
export HOME=/root
export LC_ALL=C


umount /proc || umount -lf /proc
umount /sys
umount /dev/pts
umount /dev
exit


label install
	menu label ^Install
	#kernel debian-installer/amd64/linux
	#append vga=788 initrd=debian-installer/amd64/initrd.gz --- quiet 
	timeout 0
	kernel isdosyalari/live/vmlinuz
	append root=/dev/nfs boot=live components timezone=Europe/Istanbul locales=tr_TR.UTF-8,en_US.UTF-8 keyboard-layouts=tr username=pardus hostname=pardus user-fullname=Pardus vga=791 netboot=nfs nfsroot=sunucuipadresi:/srv/tftp/isdosyalari initrd=isdosyalari/live/initrd.img noswap splash quiet --
