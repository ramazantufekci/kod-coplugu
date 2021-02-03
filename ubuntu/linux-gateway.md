# Linux Makineyi gateway olarak kullanma

sudo vim /etc/sysctl.conf
net.ipv4.ip_forward=1

nano sudo /proc/sys/net/ipv4/ip_forward dosya içi 1
sudo iptables -t nat -A POSTROUTING -o eth1 MASQUERADE
