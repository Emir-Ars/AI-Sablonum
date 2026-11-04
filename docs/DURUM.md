# Durum

- Son güncelleme: 2026-11-04 09:29
- Sürüm: v0.2.0 (geliştirme)
- Dal: v0.2-sade

## Kısa özet

Şablon v0.2'ye sadeleştirildi: kurallar kısaldı; belgeler yol haritası, proje geneli kayıtlar ve tek bir aktif aşama klasörü olarak ayrıldı; biten aşama bütünüyle arşive taşınıyor ve ana belgeler kapanışta birikmeye karşı temizleniyor. Eski kuralların nereye gittiği `docs/KURAL_ESLEME.md` içinde.

## Doğrulananlar

- G1: `AGENTS.md` içinde "Projeye özel kurallar" başlığına kadarki kısım `genel/KURALLAR.md` ile karakter duyarlı karşılaştırmada birebir aynı (10145 karakter). `genel/KURALLAR.md`, `AGENTS.md`, `CLAUDE.md` BOM'suz (ilk bayt kontrolü). Commit `066531e`.
- G2: `sablon/` altında 14 dosya var, hiçbirinde BOM yok; `sablon/docs/aktif-asama/` altında yalnız `arastirma/BENIOKU.md` var. Commit `c20b7c0`.
- G3 (Windows PowerShell 5.1.26100, geçici klasörde; commit `eec740b`): `kur.ps1` ayrıştırıcı hatası 0, ilk üç bayt `239 187 191`; yeni kurulum çıkış 0 ve "dosya sayısı: 21", 19 kopya dosyanın 19'u SHA-256 ile kaynağıyla aynı; aynı hedefe tekrar kurulum çıkış 1 ve dosya listesi/zamanlar değişmedi; `src/app.txt` olan mevcut klasöre kurulum çıkış 0, `app.txt` aynı kaldı; `.claude/x.md` hedefli kopyada çıkış 1 ve hedef klasör oluşmadı.
- G4: `gorseller/akis.svg` geçerli XML; Microsoft Edge başsız (headless) ekran görüntüsünde kutu ve oklar üst üste binmiyor. `AGENTS.md`, `README.md`, `CLAUDE.md`, `kur.ps1` ve `surum.json` içinde silinen dosyalara (`is-akisi.svg`, `kurulum.svg`, `tests/`, `DEVIR`, `kontrol.ps1`) atıf kalmadı. README'deki bu repoya ait yolların hepsi var. Commit `7d4f596`.
- G5 (2026-11-04, kurucu paketi `v0.2-sade` dalında; senaryo `%TEMP%\ai-sablon-v02-test-20261104-092050\Yeni` klasöründe, Git deposu değil):
  - K1: `surum.json` 19 kopya girdisi, eksik kaynak 0, tekrarlı hedef 0 (tekrarlı kaynak 4: `PLAN`, `KARARLAR`, `GUNLUK`, `TASARIM`, hepsi `aktif-asama/` ve `kurallar/sablonlar/` hedefleri için). `AGENTS.md` ortak kısmı `genel/KURALLAR.md` ile aynı. 23 izlenen `.md/.json/.svg/.ps1` dosyasında BOM ihlali 0 (`kur.ps1` BOM'lu).
  - K2: v0.1 arşivi dışındaki 20 `.md` dosyasında 2 yerel Markdown bağlantısı var, kırık 0. Kurulu projede kod biçimli 65 `docs/` yolundan yalnız `docs/arsiv/00-hazirlik/` yok (isteğe bağlı, gerektiğinde açılan klasör).
  - K3: oturum başı yükü (boş şablonlarla) `AGENTS.md` 10843 + `DURUM.md` 689 + `aktif-asama/PLAN.md` 1073 = 12605 karakter, yaklaşık 4202 token (karakter/3); `CLAUDE.md` 188 bayt ayrıca. Listede `docs/arsiv/` dosyası yok.
  - K4: `ARSIVLEME.md` adımları (Git yok, `Move-Item`) sahte "Aşama 1" üzerinde uygulandı; K-003 `docs/KARARLAR.md` dosyasına ("Proje geneli"), K-004 arşivde ("Arşivde" + bağlantı), K-001 `docs/arsiv/KARARLAR_ESKI.md` dosyasına taşındı ve dizinde "Yerine geçildi: K-002" kaldı; sözleşme `PROJE.md` dosyasına işlendi; yeni `aktif-asama/` dört şablonla SHA-256 aynı; `DURUM.md` 28 satır; arşiv dışında `aktif-asama/` bağlantısı kalmadı. Arşivlenen `KARARLAR.md` içinde bir kırık bağlantı kaldı (bulgu). Ayrıntı: G5 raporu.
  - Ölçüm: v0.1 `AGENTS.md` (commit `5712047`) 25021 karakter, ortak kısmında 110 madde (`- `); v0.2 `genel/KURALLAR.md` 10264 karakter, 55 madde (46 `- ` + 9 numaralı). `KURAL_ESLEME.md` içindeki "~11.000 karakter, ~60 madde" kaba yuvarlama; ölçülen değerlerden biraz yüksek.

## Doğrulanmayanlar

- Gerçek Codex ve Claude oturumlarında okuma sırasına ve arşivleme adımlarına uyum. K4'ü arşivleme prosedürünü yazıldığı gibi izleyen aynı ajan yürüttü; bu bağımsız bir deneme değildir.
- SVG, VS Code önizlemesinde açılmadı; yalnız Edge ekran görüntüsü incelendi.
- Eski `tests/` kaldırıldığı için kurucunun otomatik testi yok; G3 denemeleri elle ve tek seferlik yapıldı.
- K3 yükü boş şablonlarla ölçüldü; uzun bir aşamanın dolu `PLAN.md` dosyasıyla yükü ölçülmedi.
- K4'ün Git içindeki hâli (`git mv`, commit adımı) denenmedi; senaryo Git deposu olmayan klasörde yapıldı.
- G5'te bulunan prosedür belirsizlikleri ve düzeltme önerileri henüz uygulanmadı; kullanıcı onayı bekliyor.

## Sıradaki seçim

Kullanıcının seçimi bekleniyor. Bu bölüm uygulama izni değildir.
