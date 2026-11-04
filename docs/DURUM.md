# Durum

- Son güncelleme: 2026-11-04 09:22
- Sürüm: v0.2.0 (geliştirme)
- Dal: v0.2-sade

## Kısa özet

Şablon v0.2'ye sadeleştirildi: kurallar kısaldı; belgeler yol haritası, proje geneli kayıtlar ve tek bir aktif aşama klasörü olarak ayrıldı; biten aşama bütünüyle arşive taşınıyor ve ana belgeler kapanışta birikmeye karşı temizleniyor. Eski kuralların nereye gittiği `docs/KURAL_ESLEME.md` içinde.

## Doğrulananlar

- G1: `AGENTS.md` içinde "Projeye özel kurallar" başlığına kadarki kısım `genel/KURALLAR.md` ile karakter duyarlı karşılaştırmada birebir aynı (10145 karakter). `genel/KURALLAR.md`, `AGENTS.md`, `CLAUDE.md` BOM'suz (ilk bayt kontrolü). Commit `066531e`.
- G2: `sablon/` altında 14 dosya var, hiçbirinde BOM yok; `sablon/docs/aktif-asama/` altında yalnız `arastirma/BENIOKU.md` var. Commit `c20b7c0`.
- G3 (Windows PowerShell 5.1.26100, geçici klasörde; commit `eec740b`): `kur.ps1` ayrıştırıcı hatası 0, ilk üç bayt `239 187 191`; yeni kurulum çıkış 0 ve "dosya sayısı: 21", 19 kopya dosyanın 19'u SHA-256 ile kaynağıyla aynı; aynı hedefe tekrar kurulum çıkış 1 ve dosya listesi/zamanlar değişmedi; `src/app.txt` olan mevcut klasöre kurulum çıkış 0, `app.txt` aynı kaldı; `.claude/x.md` hedefli kopyada çıkış 1 ve hedef klasör oluşmadı.
- G4: `gorseller/akis.svg` geçerli XML; Microsoft Edge başsız (headless) ekran görüntüsünde kutu ve oklar üst üste binmiyor. `AGENTS.md`, `README.md`, `CLAUDE.md`, `kur.ps1` ve `surum.json` içinde silinen dosyalara (`is-akisi.svg`, `kurulum.svg`, `tests/`, `DEVIR`, `kontrol.ps1`) atıf kalmadı. README'deki bu repoya ait yolların hepsi var.

## Doğrulanmayanlar

- Gerçek Codex ve Claude oturumlarında okuma sırasına ve arşivleme adımlarına uyum.
- SVG, VS Code önizlemesinde açılmadı; yalnız Edge ekran görüntüsü incelendi.
- `docs/KURAL_ESLEME.md` içindeki v0.1 değerleri (~25.000 karakter, 110 madde) ve v0.2'nin madde sayısı (~60) bu oturumda ölçülmedi. Ölçülen tek değer: `AGENTS.md` 10843 karakter.
- Eski `tests/` kaldırıldığı için kurucunun otomatik testi yok; G3 denemeleri elle ve tek seferlik yapıldı.
- Arşivleme senaryosu (aşama kapanışı) ve belgelerin birikmemesi: G5'te denenecek.

## Sıradaki seçim

Kullanıcının seçimi bekleniyor. Bu bölüm uygulama izni değildir.
