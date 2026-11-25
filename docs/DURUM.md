# Durum

- Son güncelleme: 2026-11-25 09:18:55 +03:00
- Sürüm: v0.3.6 (geliştirme).
- Dal: main `a26a005` (DURUM kaydı) push edildi; uzak kimlik aynı; bu satırın kendi düzenlemesi için `git status` bak. CI yeşil: v0.3.5 `d88952a` [koşu 45375951329](https://github.com/Emir-Ars/AI-Sablonum/actions/runs/45375951329), v0.3.4 `6674fd4` [koşu 45009115147](https://github.com/Emir-Ars/AI-Sablonum/actions/runs/45009115147). Yalnız `docs/DURUM.md` değiştiren sonraki commit'ler için koşu listede yok (neden doğrulanmadı).
- Güncel çalışma: [v0.3.6 alt adım planlama](DOGRULAMA_v0.3.6.md). Aktif aşama yok.

## Son yapılan

- Kısa plan satırı aynı etkin planda numaralı alt satırlara ayrılıyor. Planlama belgeleri kaydediyor. Açık uygulama komutu belirtilen satırı veya aralığı kapsıyor.
- Ortak kural, kök `AGENTS.md`, planlama rehberi, PLAN/TASARIM şablonları, README ve sürüm kaydı uyumlu. Ortak kısım 14.262 karakter, kök `AGENTS.md` 15.287 karakter.
- Önceki sürümün doğrulama kaydı [DOGRULAMA_v0.3.5.md](DOGRULAMA_v0.3.5.md) dosyasında.

## Doğrulama

- Windows PowerShell 5.1 duman testi geçti=30, kaldı=0, atlandı=0. Hash denetimi EKSİK=0, FAZLA=0.
- Geçici projede plan kaydı ve yeniden planlama kod dosyalarını değiştirmedi. İlk alt adımın testi geçti, ikinci alt adım `Planlandı` kaldı.
- Ayrı geçici projede v0.3.5 → v0.3.6 geçişi doğrulandı. Dolu plan ve projeye özel bölüm korundu.

## Açık kalan / sınırlar

- Sohbetle sınırlı mod ve aralık yetkisi metin üzerinden kontrol edildi. Yeni bir Codex veya Claude oturumunda komut yorumlama denenmedi.
- Yerel inceleme notları ve kullanıcı dosyaları bu değişiklikten ayrı.

## Sonraki devam noktası

v0.3.6 için kullanıcı commit ve push onayı verdi. Uzak dal doğrulaması ve CI sonucu Git işleminden sonra kaydedilecek.
