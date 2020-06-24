# pardus da oturum açmadan direk uzakmasaüstü yapmak için dosya yolu

> /etc/lightdm/lightdm.conf

## lightdm.conf
display-setup-script=/etc/init.d/ekran.sh

---
file: ekran.sh
---

xrandr --newmode "1600x900_60.00"  118.25  1600 1696 1856 2112  900 903 908 934 +hsync +vsync

xrandr --addmode VGA1 "1600x900_60.00"

xrandr --output VGA1 --mode "1600x900_60.00" --auto

rdesktop -f -b -k tr -u dc\exampleuser -p P  uzaklar.yakin.com
