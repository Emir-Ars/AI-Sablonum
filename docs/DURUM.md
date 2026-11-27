# Durum

- Son güncelleme: 2026-11-27 17:24 +03:00
- Sürüm: v0.3.7 (geliştirme).
- Güncel çalışma: `genel/KURALLAR.md` dış kaynak/prompt injection koruması ve eşzamanlı yazma yetkili ajan kuralı eklendi; değişiklikler henüz commit edilmedi.

## Son yapılan

- v0.3.7 (güvenlik ve uyumluluk): `genel/KURALLAR.md` §1.8 olarak dış kaynakların (`arastirma/`, web sayfaları, araç çıktıları, üçüncü taraf dokümanlar) yalnız bilgi kaynağı olduğu ve talimat/yetki kaynağı olmadığı eklendi. §3'teki eşzamanlı çalışma kuralı sağlayıcı/model bağımsız hâle getirilerek aynı çalışma ağacında birden fazla yazma yetkili ajan yasağı ile salt okunur inceleme / ayrı Git worktree istisnası netleştirildi (`15.411` karakter). Önceki ortak metnin (`8ce99b4`) LF hash'i (`3d052a0c...`) `surum.json` listesine eklendi; `README.md` güncellendi.
- v0.3.7 (`8ce99b4`, push edildi): kurucu/güncelleyiciye `GEMINI.md` (`@AGENTS.md`) üretimi, `.gemini` / `GEMINI_CLI_HOME` / `.agent/` korumaları ve `U19`/`7c` duman senaryoları eklendi; depo köküne `GEMINI.md` eklendi.
- Kök `AGENTS.md` deponun geliştirme rehberidir; kök `CLAUDE.md` ve `GEMINI.md` aynı rehberi yükler. Yerel notlar `yerel-yedek/` içinde.

## Doğrulama

- `tests/kur-smoke.ps1` (Windows PowerShell 5.1): 30 geçti, 0 kaldı, 2 atlandı (`7a` junction erişim engellendi, `8` ACL yazmayı engellemedi — yerel sandbox kısıtı).
- `tests/bilinen-hashler.ps1` (Windows PowerShell 5.1): geçti (`EKSİK=0`, `FAZLA=0`, 14 geçmiş ortak kısım).
- Gerçek projede v0.3.4 → v0.3.6 güncellemesi (önceki çalışma): kuru çalıştırma 8 dosya ve `AGENTS.md` ortak kısmı yeniledi, 9 dolu belge korundu; projeye özel bölüm korundu.

## Açık kalan / sınırlar

- Yeni planlama kuralının bir ajan oturumunda (plan modu → kayıt → uygulama) davranışı henüz gözlenmedi.
- Uzun projeye özel bölümü olan projede güncelleme sonrası `AGENTS.md` 20 bin karakteri aştı; temizlik projede yapıldı.

## Sonraki devam noktası

Değişiklikler kullanıcı onayıyla commit edilip push edilebilir; ardından projeler (ör. TiktokGame) v0.3.7'ye güncellenebilir.
