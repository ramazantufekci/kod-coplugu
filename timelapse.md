Can sıkıntısıyla boş boş bakınırken kendimi Enka'nın hava istasyonu web arayüzündeki kamera görüntüsüne bakarken buldum. Bu kamera, birinci köprü bağlantı yolunu ve kısmen boğaz manzarasını dakikada bir değişen ve yeterince iyi bir çözünürlükte sunuyor. Bununla bir timelapse videosu yapılır diyerek aşağıdaki scripti dakikada bir çalışacak şekilde crontab'a ekledim.

```
#/bin/bash
wget http://www.enka.com/camhd/cam1/c.jpg
filename=/home/12m/enka/$(date '+%Y-%m-%d-%H-%M-%S')".jpg"
mv c.jpg $filename
echo "downloaded: "$filename
```
Yaklaşık 2 gün sonunda elimde tarih-saat.jpg formatında isimlendirilmiş 3000 civarında resim dosyası oldu. Bu dosyalardan bir video oluşturmak için ise

```
ffmpeg -r 25 -pattern_type glob -i '*.jpg' -c:v libx264 out.mp4
```
kullandım. Oluşan videoyu aşağıda görebilirsiniz.
