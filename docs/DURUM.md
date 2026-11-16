# Durum

- Son güncelleme: 2026-11-16 13:40:00 +03:00
- Sürüm: v0.3.2 (geliştirme)
- Dal: main; başlangıç HEAD `2f39172`. Bu çalışmanın değişiklikleri yalnız dosyaya yazıldı.
- Güncel çalışma: [dört davranış kuralı](DAVRANIS_KURALLARI_DOGRULAMA.md); aktif aşama yok.

## Son yapılan

- Dört davranış ortak kaynağa işlendi; kök AGENTS ortak kısmı eşitlendi, özel kurallar korundu.
- Eski ortak metnin LF hash'i `surum.json` listesine eklendi. Arşiv ve başlangıç belgeleri değiştirilmedi.

## Doğrulama

- Son Windows PowerShell 5.1 duman testi: geçti=30, kaldı=0, atlandı=0; geçmiş hash denetimi EKSİK=0, FAZLA=0.
- Ortak metin eşitliği, özel bölüm/girdi koruması, UTF-8 ve `git diff --check` geçti. İlk kısıtlı ortam hatası raporda korunuyor.

## Açık kalan / sınırlar

- Önceki doğrulamalar ve sınırlar: [HAFIZA_TOKEN_DOGRULAMA.md](HAFIZA_TOKEN_DOGRULAMA.md).
- Geçici devir örneği hazır; gerçek bağımsız VS Code ajan oturumu açılıp gözlenmedi. Deneme yolu ve mesajı güncel raporda.
- Kullanıcı beş dosya için commit ve push onayı verdi; işlem sonucu bekleniyor. CI sonucu kontrol edilmedi.

## Sonraki devam noktası

Kullanıcı yeni VS Code ajan oturumunda rapordaki yalnız-durum mesajını deneyebilir; amaç karar ve doğrulama ayrımını yeni oturumda gözlemek. Bu not uygulama izni değildir.
