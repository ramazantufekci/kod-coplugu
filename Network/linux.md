sudo ip addr add 192.168.1.14/24 dev eth0

sudo ip link set dev eth0 up

sudo ip route add default via 192.168.1.1

# netplan kurulu bilgisayarlarda ayar dosyası
```
# This file describes the network interfaces available on your system
# For more information, see netplan(5).
network:
  version: 2
  renderer: networkd
  ethernets:
    enp0s3:
     dhcp4: no
     addresses: [192.168.1.222/24]
     gateway4: 192.168.1.1
     nameservers:
       addresses: [8.8.8.8,8.8.4.4]
       
```
```
 sudo netplan apply
 ```
 
