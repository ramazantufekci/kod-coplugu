sudo ip addr add 192.168.1.14/24 dev eth0

sudo ip link set dev eth0 up

sudo ip route add default via 192.168.1.1
