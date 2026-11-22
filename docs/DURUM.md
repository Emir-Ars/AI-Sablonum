# Durum

- Son güncelleme: 2026-11-22 12:45:01 +03:00
- Sürüm: v0.3.4 (geliştirme).
- Dal: main; v0.3.4 commit'i (v0.3.3'ün push sonrası CI kaydı dahil) kullanıcı onayıyla atılıyor, kimliği `git log` ile görülür. Önceki: `e16e9a4` (v0.3.3, CI yeşil).
- Güncel çalışma: [v0.3.4 bağımsız inceleme düzeltmeleri](DOGRULAMA_v0.3.4.md); H, Y, D tamamlandı. Aktif aşama yok.

## Son yapılan

- v0.3.4: özel kural önceliği (kırmızı çizgi istisnasıyla), dal silme onayı, sabit karar kapsamı, adım satırında karar tabanı (`plan: K-xxx`), izin ayarının sınırı, yedekler için `.gitignore` önerisi, satır sonu önerisi, geçici bozmanın kesinti kaydı.
- Bağımsız inceleme ve dar yeniden inceleme bulguları düzeltildi; B1 için kullanıcı "Kırmızı çizgi istisnası"nı seçti.

## Doğrulama

- Yerel (Windows PowerShell 5.1): duman testi geçti=30, kaldı=0, atlandı=0; hash denetimi EKSİK=0, FAZLA=0; BOM/CRLF yok; `git diff --check` temiz.
- v0.3.2 kurulu gerçek bir projenin geçici kopyasında güncelleme: ortak kısım yenilendi, özel bölüm ve dolu belgeler bayt bayt korundu; kopyadaki `AGENTS.md` 20.908 karakter.
- Çalıştırılamayan: v0.3.4 CI'ı (push yok).

## Açık kalan / sınırlar

- Kullanıcı commit ve push'u onayladı (2026-11-22); v0.3.3 CI kaydı önerildiği gibi bu commit'e alındı.
- Ortak kısım 12.798 karakterle bütçeye dayandı. Açık konular (B8'in iki kısmı, B11): [DOGRULAMA_v0.3.4.md](DOGRULAMA_v0.3.4.md#açık-konular).
- Yerel inceleme notu, kullanıcı notu ve görev dosyası commit'e alınmaz.

## Sonraki devam noktası

Kullanıcı commit kapsamını seçer; commit sonrası push ayrı onayla. Bu not uygulama izni değildir.
