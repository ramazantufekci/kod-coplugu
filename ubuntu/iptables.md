#!/usr/bin/env bash

#### 80 portuna gelen sorguları 443 e yönlendir
iptables -A PREROUTING -t nat -p tcp --dport 80 -j REDIRECT --to-port 443


#### PREROUTING Kayıt listeleme
iptables -L -n -t nat


#### PREROUTING Kayıt silme
iptables -t nat -D PREROUTING satirno