#### 80 portuna gelen sorguları 443 e yönlendir
iptables -A PREROUTING -t nat -p tcp --dport 80 -j REDIRECT --to-port 443


#### PREROUTING Kayıt listeleme
iptables -L -n -t nat


#### PREROUTING Kayıt silme
iptables -t nat -D PREROUTING satirno

### 443 portuna gelen istekleri loglar log dosyasının yolu /var/log/kern.log
```iptables -A INPUT -p tcp --dport 443 -j LOG ```

### İp adresi engelleme
```iptables -A INPUT -s 8.8.8.8 -j REJECT ```

### İp adresinden 443 portuna gelen istekleri engelleme
```iptables -A INPUT -s 8.8.8.8 -p tcp --destination-port 443 -j REJECT ```
