# Başlamadan önce

```bash
sudo mount -t squashfs filesystem.squashfs pardusfs/
sudo mount -t overlay overlay -onoatime,lowerdir=pardusfs,upperdir=project,workdir=work newlive
sudo systemd-nspawn --bind-ro=/etc/resolv.conf:/run/resolvconf/resolv.conf --setenv=RUNLEVEL=1 -D newlive
```
## editleme işi bittikten sonra

```bash
sudo mksquashfs newlive live/filesystem.squashfs -noappend -b 1048576 -comp xz -Xdict-size 100%
sudo umount /home/ramazan/newlive
sudo umount /home/ramazan/pardusfs
```
### pxe için dosyaları kopyala 

```bash
sudo mv /srv/tftp/isdosyalari/live/filesystem.squashfs /srv/tftp/isdosyalari/live/filesystem.squashfs17032023-2
sudo cp live/filesystem.squashfs /srv/tftp/isdosyalari/live/
```
