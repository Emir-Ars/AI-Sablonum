# Durum

- Son güncelleme: 2026-11-06 14:02:02 +03:00
- Sürüm: v0.3.2 (geliştirme)
- Dal: main; H0–H8 commit `2f51cd5` ile GitHub'a gönderildi (`git ls-remote` ile doğrulandı).
- Ayrıntılı rapor: [HAFIZA_TOKEN_DOGRULAMA.md](HAFIZA_TOKEN_DOGRULAMA.md)

## Son yapılan (v0.3.2, H0–H8)

- Ortak kurallar kısaldı (ortak kısım 12.837 → 10.127 karakter); okuma tablosu ve kayıt anları eklendi.
- Ayrıntılar yeni rehberlere taşındı: `docs/kurallar/PLANLAMA.md`, `GIT.md`, `WINDOWS.md`; `surum.json` eşlemeleri ve eski ortak hash eklendi.
- PLAN şablonuna "Başlangıç" bölümü ve "İlgili kaynaklar" sütunu; günlükte kesin üç kayıt sınırı kalktı; değişen karar yeni numara alıyor.
- README: kayıt anları, bağlam/token notu, üç kayıt durumu, hafızanın yeri, dolu belgeleri geçirme yolu.

## Doğrulananlar

- Windows PowerShell 5.1: duman testi geçti=30, kaldı=0, atlandı=0 (yeni R1, R2, U18); geçmiş hash denetimi EKSİK=0, FAZLA=0; `git diff --check` temiz.
- Bağımsız inceleme (Hafif): 1 önemli + 5 küçük bulgu düzeltildi; düzeltme incelemesinde kanıtlı bulgu yok.
- Hafıza denemeleri yalnız aynı ajanın canlandırması; sonuçlar raporda.

## Doğrulanmayanlar ve sınırlar

- GitHub CI `kurucu-smoke` (çalıştırma 42206788113, commit `2f51cd5`): başarılı, 2 dk 32 sn.
- Gerçek yeni Codex/Claude oturumu çalıştırılamadı (araçlar PATH'te yok); token ölçülmedi.
- Önceki sınırlar sürüyor: yazma atomik değil; sığ klon reddi ayrı denenmedi.

## Sıradaki seçim

Sonraki çalışma kapsamı kullanıcı tarafından seçilecek. Bu bölüm uygulama izni değildir.
