# Durum

- Son güncelleme: 2026-11-05 13:40:10 +03:00
- Sürüm: v0.3.1 (geliştirme)
- Dal: main

## v0.3.1 değişiklikleri

- v0.2.0 öncesi kurulumlar içerik okunmadan reddediliyor.
- Ortak kuralların hash'i satır sonundan bağımsız; eski kayıtlar yeni LF alanına taşınıyor, özel bölüm ve hedefin satır sonları korunuyor.
- Bilinen eski ortak kurallar otomatik yenileniyor; paket listesi doğrulanıyor, bakım kuralı ve README açıklamaları güncellendi.
- Güvenlik ve kayıt geçişi testleri ile tam Git geçmişini kullanan otomatik doğrulama (CI) denetimi eklendi.

## Doğrulananlar

- v0.3.1 sonrası Windows PowerShell 5.1: duman testi geçti=27, kaldı=0, atlandı=0; geçmiş hash denetimi EKSİK=0, FAZLA=0.
- D bölümü: 4 betikte ayrıştırıcı hatası 0; 8 ortak fonksiyon aynı. AGENTS.md ortak/tam karakter sayısı LF ile 12.837/13.862.
- Bağımsız inceleme: tasarımda kayıt geçişi bulgusu giderildi ve test edildi; sonraki kod incelemesinde kanıtlı hata yok. Ayrıntılar: [doğrulama raporu](DOGRULAMA_v0.3.1.md).

## Doğrulanmayanlar ve sınırlar

- Bu sürümün CI sonucu kontrol edilmedi; ayrı bir sığ klonda ret denemesi yok. Yazma atomik değil (kesinti kısmi değişiklik bırakabilir).
- Gerçek Codex/Claude oturumlarında kural uyumu ve izin örnekleri denenmedi; ev klasörü reddinde özel ileti yerine önce iç içe hedef iletisi görülüyor.
- Önceki açık kontroller (SVG önizlemesi, git mv arşivlemesi, dolu PLAN.md yükü): [eski doğrulama kaydı](arsiv/v0.2-gelistirme/DOGRULAMA.md).

## Sıradaki seçim

Kullanıcı commit ve push işlemini onayladı. GOREV_v0.3.md / GOREV_v0.3.1.md dosyalarının silinmesi isteğiyle bekletildi; sonraki çalışma kapsamı seçilecek. Bu bölüm uygulama izni değildir.
