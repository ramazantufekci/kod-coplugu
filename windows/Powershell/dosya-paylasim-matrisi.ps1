# 1. Yol Tanımlamaları
$TaramaYolu = "X:\"      # Taramak istediğiniz ana klasörün yolu
$RaporYolu  = "X:\Klasor_Yetki_Matrisi5.csv" # Kaydedilecek matris dosyasının yolu

# Raporlama klasörü yoksa otomatik oluştur
$RaporKlasoru = Split-Path $RaporYolu
if (!(Test-Path $RaporKlasoru)) { New-Item -ItemType Directory -Path $RaporKlasoru -Force | Out-Null }

$Sonuclar = @()
Write-Host "$TaramaYolu taranıyor ve matris oluşturuluyor..." -ForegroundColor Cyan

# 2. Tüm Alt Klasörleri Al ve Ana Klasörü Ekle
$Klasorler = Get-ChildItem -Path $TaramaYolu -Directory -ErrorAction SilentlyContinue
$TumYollar = @($TaramaYolu) + $Klasorler.FullName

# 3. İzinleri Matris Düzenine Çevir
foreach ($Yol in $TumYollar) {
    try {
        $ACL = Get-Acl -Path $Yol -ErrorAction Stop
        
        foreach ($Erisim in $ACL.Access) {
            # Sistem ve yerel yönetici hesaplarını temizle (Sadece departman/kullanıcı odaklı matris için)
            if ($Erisim.IdentityReference -notmatch "NT AUTHORITY|BUILTIN\\Administrators|CREATOR OWNER") {
                
                $Haklar = $Erisim.FileSystemRights.ToString()
                
                # Matris Sütun İşaretçileri (Yetki varsa "X" koyar)
                $Okuma      = ""
                $Yazma      = ""
                $Degistirme = ""
                $TamYetki   = ""
                
                # Yetki kontrolü ve eşleştirme
                if ($Haklar -match "FullControl") {
                    $TamYetki = "X"
                    $Degistirme = "X"
                    $Yazma = "X"
                    $Okuma = "X"
                }
                elseif ($Haklar -match "Modify") {
                    $Degistirme = "X"
                    $Yazma = "X"
                    $Okuma = "X"
                }
                elseif ($Haklar -match "Write") {
                    $Yazma = "X"
                    $Okuma = "X"
                }
                elseif ($Haklar -match "Read|ListDirectory") {
                    $Okuma = "X"
                }

                # Ana klasör ve alt klasör adını ayır (Matris tasarımı için)
                $KlasorAdi = Split-Path $Yol -Leaf
                $UstKlasor = Split-Path $Yol

                # Matris yapısındaki nesneyi oluştur
                $MatrisSatir = [PSCustomObject]@{
                    "Ana Klasör / Yol"      = $UstKlasor
                    "Klasör Adı"            = $KlasorAdi
                    "Erişim Grubu / Kullanıcı" = $Erisim.IdentityReference
                    "Okuma (Read)"          = $Okuma
                    "Yazma (Write)"         = $Yazma
                    "Değiştirme (Modify)"   = $Degistirme
                    "Tam Yetki (Full)"      = $TamYetki
                    "Miras mı? (Inherited)" = if ($Erisim.IsInherited) { "Evet" } else { "Hayır" }
                }
                $Sonuclar += $MatrisSatir
            }
        }
    }
    catch {
        Write-Host "Erişim Engellendi: $Yol" -ForegroundColor Red
    }
}

# 4. CSV Matrisini Dışarı Aktar
if ($Sonuclar.Count -gt 0) {
    $Sonuclar | Export-Csv -Path $RaporYolu -NoTypeInformation -Encoding UTF8 -Delimiter ";"
    Write-Host "`nMatris Başarıyla Oluşturuldu: $RaporYolu" -ForegroundColor Green
} else {
    Write-Host "`nHiçbir özel yetki matrisi çıkartılamadı." -ForegroundColor Yellow
}
