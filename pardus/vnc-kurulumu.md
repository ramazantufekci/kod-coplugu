Vnc Server Kurulumu için aşağıda ki adımların uygulanması yeterlidir. Windows 10 üzerinden bağlandım ve kullandım.

```sudo apt-get -y install x11vnc

sudo mkdir /etc/x11vnc

sudo x11vnc --storepasswd /etc/x11vnc/vncpwd```

-----x11vnc service oluşturulacak---------------

```sudo nano /lib/systemd/system/x11vnc.service```

-----x11vnc service içine kopyalanacak-----------

Copy/Paste this code into the empty file:

```[Unit]
Description=Start x11vnc at startup.
After=multi-user.target

[Service]
Type=simple
ExecStart=/usr/bin/x11vnc -auth guess -forever -noxdamage -repeat -rfbauth /etc/x11vnc/vncpwd -rfbport 5900 -shared

[Install]
WantedBy=multi-user.target```

ctrl + O - enter - ctrl + x
```
sudo systemctl daemon-reload

sudo systemctl enable x11vnc.service

sudo systemctl start x11vnc.service
```
