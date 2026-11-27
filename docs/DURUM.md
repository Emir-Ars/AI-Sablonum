# Durum

- Son güncelleme: 2026-11-27 17:07 +03:00
- Sürüm: v0.3.7 (geliştirme).
- Güncel çalışma: v0.3.7 üzerine Gemini ajanları için `GEMINI.md` giriş dosyası ve `.gemini` korumaları eklendi; değişiklikler henüz commit edilmedi.

## Son yapılan

- v0.3.7 (Gemini desteği): kurucu ve güncelleyici hedef projeye `CLAUDE.md` gibi `GEMINI.md` (`@AGENTS.md`) üretir (`kur.ps1`, `guncelle.ps1`, `surum.json`). Depo köküne `GEMINI.md` eklendi.
- `.gemini` global dizin koruması (`~/.gemini`, `GEMINI_CLI_HOME`) ve hedef yasaklı ön ekleri (`.gemini/`, `.agent/`) kurucu ve güncelleyiciye eklendi.
- `genel/KURALLAR.md` §1.6'ya `.gemini` eklendi, §3'teki eşzamanlı çalışma cümlesi araçtan bağımsızlaştırıldı. Önceki ortak metnin LF hash'i (`be870758...`) `surum.json` içindeki `knownAgentsCommonLfSha256` listesine eklendi.
- `README.md` Gemini CLI / Gemini Code Assist / Google Antigravity bilgileri ve Gemini CLI ayar/Policy Engine bağlantılarıyla güncellendi.
- `tests/kur-smoke.ps1` içine `GEMINI.md` kurulum/güncelleme (`U19`) ve global `.gemini` koruma (`7c`) senaryoları eklendi.
- Kök `AGENTS.md` deponun geliştirme rehberidir; kök `CLAUDE.md` ve `GEMINI.md` aynı rehberi yükler. Yerel notlar `yerel-yedek/` içinde.

## Doğrulama

- `tests/kur-smoke.ps1` (Windows PowerShell 5.1): 30 geçti, 0 kaldı, 2 atlandı (`7a` junction erişim engellendi, `8` ACL yazmayı engellemedi — sandbox kısıtı).
- `tests/bilinen-hashler.ps1` (Windows PowerShell 5.1): geçti (`EKSİK=0`, `FAZLA=0`, 13 geçmiş ortak kısım).
- Gerçek projede v0.3.4 → v0.3.6 güncellemesi (önceki çalışma): kuru çalıştırma 8 dosya ve `AGENTS.md` ortak kısmı yeniledi, 9 dolu belge korundu; projeye özel bölüm korundu.

## Açık kalan / sınırlar

- Yeni planlama kuralının bir ajan oturumunda (plan modu → kayıt → uygulama) davranışı henüz gözlenmedi.
- Uzun projeye özel bölümü olan projede güncelleme sonrası `AGENTS.md` 20 bin karakteri aştı; temizlik projede yapıldı.

## Sonraki devam noktası

Değişiklikler kullanıcı onayıyla commit edilip ardından projeler (ör. TiktokGame) v0.3.7'ye güncellenebilir.
