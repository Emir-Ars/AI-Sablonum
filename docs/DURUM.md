# Durum

- Son güncelleme: 2026-11-06 12:48:13 +03:00
- Sürüm: v0.3.2 (geliştirme)
- Dal: main; gözlenen son commit `32c889c` (v0.3.1). H0–H8 değişiklikleri çalışma ağacında, commit edilmedi.
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

- GitHub CI sonucu yok; gerçek yeni Codex/Claude oturumu çalıştırılamadı (araçlar PATH'te yok); token ölçülmedi.
- Önceki sınırlar sürüyor: yazma atomik değil; sığ klon reddi ayrı denenmedi.

## Sıradaki seçim

Commit önerisi sunuldu; commit ve push ayrı ayrı kullanıcı onayı bekler. Bu bölüm uygulama izni değildir.
