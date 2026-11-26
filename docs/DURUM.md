# Durum

- Son güncelleme: 2026-11-26 14:44 +03:00
- Sürüm: v0.3.7 (geliştirme).
- Planlama ayrıntısı kuralı `main` dalında `cae5407` ile gönderildi; bu kayıt ve sürüm yükseltmesi ayrı commit'te.
- Güncel çalışma: yok; şablon değişikliği tamamlandı.

## Son yapılan

- v0.3.7: plan, onu yazmayan ajanın tahminsiz uygulayabileceği ayrıntıda olur (`PLANLAMA.md` 2., 5. ve 6. madde, `TASARIM.md` şablonu). Ortak kurala eksik plan bilgisinde durma ve iki başarısız denemede bildirme eklendi. Kurallar model ve araçtan bağımsızdır. Önceki ortak metnin LF hash’i `surum.json` listesine eklendi. README'ye v0.3.7 notu ve projelere `*.md text eol=lf` önerisi eklendi.
- İlk alt adımın uygulaması başlayınca aşama `Devam ediyor`, adımın `Planlandı` üst satırları `Uygulanıyor` olur.
- Kısa plan satırı aynı etkin planda numaralı alt satırlara ayrılıyor. Açık uygulama komutu belirtilen satırı veya aralığı kapsıyor.
- Kök `AGENTS.md` deponun geliştirme rehberidir; kök `CLAUDE.md` aynı rehberi yükler. Yerel notlar `yerel-yedek/` içinde.

## Doğrulama

- `cae5407` öncesi: `tests/kur-smoke.ps1` ve `tests/bilinen-hashler.ps1` Windows PowerShell 5.1'de geçti (kullanıcı bildirimi; çıktı bu kayda alınmadı). Sürümün 0.3.7'ye yükseltilmesinden sonra testler yeniden çalıştırılmadı.
- Gerçek projede v0.3.4 → v0.3.6 güncellemesi (bu kuralla): kuru çalıştırma 8 dosya ve `AGENTS.md` ortak kısmı yeniledi, 9 dolu belge korundu; projeye özel bölüm korundu.
- Önceki sürümlerde: 30 kurulum ve güncelleme senaryosu geçti; v0.3.5 → v0.3.6 geçişi geçici projede doğrulandı.

## Açık kalan / sınırlar

- Yeni planlama kuralının bir ajan oturumunda (plan modu → kayıt → uygulama) davranışı henüz gözlenmedi.
- Uzun projeye özel bölümü olan projede güncelleme sonrası `AGENTS.md` 20 bin karakteri aştı; temizlik projede yapıldı.

## Sonraki devam noktası

Yeni bir şablon fikri doğrudan bu depoda ele alınabilir. TiktokGame projesi v0.3.7'ye güncellenecek.
