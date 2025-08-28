İşte OneSignal için örnek bir **Sepet Hunisi Journey şeması** 👆

* 100 kişi ürünü sepete ekliyor
* 60 kişi ödemeyi başlatıyor
* 40 kişi satın almayı tamamlıyor

Her adımda otomatik bildirimler, e-posta veya hatırlatıcılar eklenerek dönüşüm oranı artırılabilir.

👉 İstersen sana bu huniyi **OneSignal Journeys üzerinde adım adım nasıl kuracağını** da gösterebilirim. İster misin?


Harika 👍 O zaman OneSignal üzerinde **Sepet Hunisi Journey**’yi adım adım nasıl kuracağını göstereyim:

---

## 🛠 OneSignal’de Sepet Hunisi Journey Kurulumu

### 🔹 1. Event’leri Tanımla

Uygulamana/website’ine OneSignal SDK entegre edip şu event’leri göndermelisin:

* `product_added_to_cart`
* `checkout_started`
* `purchase_completed`

📍 Bu sayede kullanıcı hangi adımda olduğunu OneSignal anlayacak.

---

### 🔹 2. Yeni Journey Oluştur

1. **Messaging → Journeys → Create Journey** seç.
2. Journey’e isim ver: *Sepet Hunisi*.
3. **Trigger** olarak **Event-based → product\_added\_to\_cart** seç.
   → Yani, kullanıcı ürünü sepete eklediğinde Journey başlasın.

---

### 🔹 3. İlk Koşul (Satın aldı mı?)

* İlk adıma bir **Condition** ekle:

  * “purchase\_completed event tetiklendi mi?”
  * Eğer evet → huniden çıkar, teşekkür bildirimi gönder.
  * Eğer hayır → devam et.

---

### 🔹 4. Hatırlatma Bildirimi Gönder

* **Wait (2 saat)** bloğu ekle.
* Ardından bir **Push Notification** gönder:
  👉 “Sepetinde ürün kaldı! Bitmeden tamamla 🎁”

---

### 🔹 5. İkinci Hatırlatma (Opsiyonel)

* Tekrar bir **Wait (24 saat)** ekle.
* Eğer hâlâ `purchase_completed` yoksa → e-posta veya ikinci push gönder:
  👉 “%10 indirimle siparişini tamamla!”

---

### 🔹 6. Huniyi Kapat

* Eğer kullanıcı satın alma yaparsa → Journey otomatik biter.
* Yapmazsa → son bir “Kaybettik seni 😔” mesajı ile bitirilebilir.

---

### 🔹 7. Raporlama & Optimizasyon

* Journey raporlarından hangi adımda en çok düşüş olduğunu gör.
* Bildirim başlıklarını ve sürelerini A/B test ile optimize et.

---

📌 Kısacası:
**Trigger = Sepete ekleme → Condition = Satın alma kontrolü → Wait + Bildirim → Tekrar kontrol → Sonuç**

---

İstersen sana OneSignal’in **Journey builder ekranında bu adımların görsel bir mockup’ını** da çizebilirim. İstiyor musun?


Süper soru 👌 Funnel’in **site tarafında** (yani web sitende) doğru çalışması için OneSignal’e event (olay) göndermen gerekiyor. Journey’ler bu event’lere göre tetikleniyor.

Aşağıda adım adım anlatayım:

---

## 🛠 Site Tarafında OneSignal Funnel Ayarları

### 🔹 1. OneSignal Web SDK’yı Kur

Önce OneSignal’i sitene ekle:

HTML `<head>` içine şu script’i ekliyorsun:

```html
<script src="https://cdn.onesignal.com/sdks/OneSignalSDK.js" async=""></script>
<script>
  window.OneSignal = window.OneSignal || [];
  OneSignal.push(function() {
    OneSignal.init({
      appId: "YOUR-ONESIGNAL-APP-ID",
    });
  });
</script>
```

---

### 🔹 2. Kullanıcı Event’lerini Gönder

Sepet hunisi için üç temel event göndermen lazım.

Örnek:

```javascript
// Ürün sepete eklendiğinde
OneSignal.sendTag("product_added_to_cart", "true");

// Ödeme başladı
OneSignal.sendTag("checkout_started", "true");

// Satın alma tamamlandı
OneSignal.sendTag("purchase_completed", "true");
```

📍 `sendTag` basit senaryolarda kullanılabilir.
Ama daha güçlü senaryolar için **sendOutcome** veya **sendEvent** kullanabilirsin:

```javascript
OneSignal.sendOutcome("product_added_to_cart");
OneSignal.sendOutcome("checkout_started");
OneSignal.sendOutcome("purchase_completed");
```

👉 Bu event’ler **Journeys** içinde “Trigger” veya “Condition” olarak kullanılabilir.

---

### 🔹 3. Segment Oluştur

* OneSignal paneline git → **Audience → Segments**
* Örn. `product_added_to_cart = true` olan kullanıcıları filtrele.
* Aynı şekilde “sepete ekledi ama satın almadı” segmenti de oluşturabilirsin:

  * `product_added_to_cart = true`
  * VE `purchase_completed` yok.

---

### 🔹 4. Journey Kur

Artık site event’leri OneSignal’e aktarıyor → Sen de bu event’leri Journey builder’da kullanabilirsin:

* **Trigger:** `product_added_to_cart` event’i
* **Condition:** `purchase_completed` var mı?
* **Wait + Push Notification** adımlarını ekle

---

### 🔹 5. Test Et

* Site üzerinden sepete ürün ekle → Event OneSignal’e düşüyor mu kontrol et.
* Journey raporlarında kullanıcı akışını test et.

---

📌 Özet:

1. **Web SDK kur**
2. **Event gönder (sepete ekleme, ödeme, satın alma)**
3. **Segment oluştur**
4. **Journey tasarla**

---

👉 İstersen sana direkt **örnek bir e-ticaret sitesine entegre edilebilecek tam kod bloğu** (sepete ekleme + satın alma eventleri) hazırlayayım. Bunu ister misin?


Harika 👍 O zaman sana **e-ticaret sitesine entegre edilebilecek örnek OneSignal kod bloğu** hazırlayayım.
Bu örnekte:

* Kullanıcı sepete ürün eklediğinde,
* Ödeme başlattığında,
* Satın alma tamamladığında OneSignal’e event gönderiyoruz.

---

## 🛠 OneSignal Funnel Event Entegrasyonu (JavaScript)

```html
<!-- OneSignal SDK -->
<script src="https://cdn.onesignal.com/sdks/OneSignalSDK.js" async=""></script>
<script>
  window.OneSignal = window.OneSignal || [];
  OneSignal.push(function() {
    OneSignal.init({
      appId: "YOUR-ONESIGNAL-APP-ID", // kendi appId’nizi buraya ekleyin
      safari_web_id: "YOUR-SAFARI-ID" // sadece Safari için gerekirse
    });
  });

  // 📌 ÖRNEK EVENTLER

  // 1. Ürün sepete eklendiğinde
  function trackAddToCart(productId) {
    console.log("Sepete eklendi:", productId);
    OneSignal.sendOutcome("product_added_to_cart");
    // İstersen ürün bilgisini tag olarak da gönder:
    OneSignal.sendTag("last_added_product", productId);
  }

  // 2. Ödeme başlatıldığında
  function trackCheckoutStart(orderId) {
    console.log("Ödeme başlatıldı:", orderId);
    OneSignal.sendOutcome("checkout_started");
    OneSignal.sendTag("last_order_id", orderId);
  }

  // 3. Satın alma tamamlandığında
  function trackPurchase(orderId, amount) {
    console.log("Satın alma tamamlandı:", orderId, "Tutar:", amount);
    OneSignal.sendOutcome("purchase_completed");
    OneSignal.sendTag("last_purchase_amount", amount);
  }
</script>
```

---

### 📌 Kullanım Örneği (HTML + JS)

Sepete ekleme butonuna basıldığında:

```html
<button onclick="trackAddToCart('urun123')">Sepete Ekle</button>
```

Ödeme sayfasında (kullanıcı ödeme başlatınca):

```javascript
trackCheckoutStart("order456");
```

Satın alma başarılı olunca:

```javascript
trackPurchase("order456", 299.90);
```

---

### 🔎 Sonuç

* OneSignal panelinde **Journeys → Trigger** kısmına `product_added_to_cart` seçebilirsin.
* Kullanıcı sepete ürün ekler → Journey başlar.
* Eğer `purchase_completed` gelmezse → bildirim/hatırlatma gönderilir.

---

👉 İstersen bu kodu senin sitendeki **sepete ekle / ödeme / satın alma flow’unun yapısına göre** daha özelleştirebilirim. Bana kullandığın e-ticaret altyapısını (ör. WooCommerce, Shopify, özel yazılım) söyler misin?
