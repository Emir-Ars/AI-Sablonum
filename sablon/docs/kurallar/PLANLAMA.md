# Planlama

Bu dosya yol haritası veya aşama planı hazırlanırken, plan yapısı değiştirilirken ve `docs/PROJE.md` içinde test komutu yokken okunur. Planlama uygulama izni vermez; yetki kuralları `AGENTS.md` içindedir.

## Yol haritası

Kullanıcı genel araştırma belgelerini `docs/arastirma/` altına koyar. `docs/YOL_HARITASI.md` bunlardan hazırlanır: yalnız ana aşamalar ve her birinin 1–2 cümlelik amacı. Aşama ayrıntısı yol haritasına yazılmaz; değişiklik kuralı o dosyanın başındadır.

## Aşama planı

1. Kullanıcı aşamanın araştırma belgelerini `docs/aktif-asama/arastirma/` altına koyar.
2. `arastirma/` içinde `BENIOKU.md` dışında belge yoksa planı hemen yazma: koddan ve proje belgelerinden çıkardığın bilgiyi ve eksik kalanı birkaç satırla özetle, tek soru sor: "Araştırma belgesi eklenecek mi, yoksa bu bilgiyle plan yazayım mı?" Kullanıcı onaylarsa planı yaz ve `TASARIM.md` içinde "Araştırma belgesi yok; kaynak: kod ve proje belgeleri" diye belirt.
3. Plan şu kaynaklara göre yazılır: aşama araştırması, yol haritası, `docs/PROJE.md`, `docs/KARARLAR.md` ve `docs/ACIK_KONULAR.md`. Bu aşamada "en geç" olan bekleyen kararlar kullanıcıya sunulur.
4. Yol haritasının hâlâ geçerli olduğunu kontrol et; değişiklik gerekiyorsa öner, kendin değiştirme.
5. Tasarım (araştırmadan çıkan tasarım, riskler, yol haritasından ve araştırmadan farklar, alt adım sıralama gerekçesi) `docs/aktif-asama/TASARIM.md`, alt adım tablosu `docs/aktif-asama/PLAN.md` dosyasına yazılır. Alt adım tasarımları `### 1.1 — kısa ad` gibi ayrı başlık alır.

## PLAN.md yapısı

- **Başlangıç** (en fazla 15 satır): aşama, aşama durumu, güncel adım işaretçisi, önemli kapsam sınırları ve bağlantılar. Durum tablosu ve tasarım burada tekrar edilmez. Yeni oturumda planın yalnız bu bölümü, "Aşama kuralları" ve ilgili adım satırları okunur. Güncel adım değişince işaretçi de güncellenir.
- **Alt adımlar:** `1.1`, `1.2` gibi kalıcı numaralar; numara yeniden kullanılmaz. Büyük adım `1.2.1` gibi bölünebilir; bölmek uygulama izni değildir. Her satırda kapsam, kabul ölçütü, doğrulama yöntemi, inceleme katmanı (`INCELEME.md`), ilgili kaynaklar ve durum bulunur.
- **İlgili kaynaklar:** yalnız o adım için gereken belge veya bölüm, K-numarası, kod ya da test yolu; kısa göreli bağlantı olarak (ör. `[PROJE.md — Test komutları](../PROJE.md#test-komutları)`, `K-004`, `[TASARIM.md — 1.2](TASARIM.md#12--kısa-ad)`, `src/x.py`). Bütün repo veya bütün belge klasörü listelenmez.

## Tamamlanan adımı kısaltma

"Doğrulandı" olan satır yaklaşık 300 karaktere indirilir: tek cümlelik kapsam, doğrulama özeti (commit, test sayısı) ve `GUNLUK.md` kaydına bağlantı; "İlgili kaynaklar" korunur. Kısaltmadan önce kabul ölçütünün `GUNLUK.md` doğrulama kaydında veya `TASARIM.md` içinde bulunduğunu kontrol et; yoksa önce günlüğe yaz. Kabul ölçütü kısaltma sırasında kaybolmaz.

## Test komutu

`docs/PROJE.md` "Test komutları" bölümü boşsa projede tanımlı komut aranır: `package.json` script'leri, `pyproject.toml`, `Makefile`, CI dosyaları, test klasörleri. Açıkça tanımlı ve yalnız yerel test çalıştıran tek bir komut bulunursa çalıştırılır ve `docs/PROJE.md` içine yazılır. Komut bulunamazsa, birden fazla aday varsa veya komut ağa, canlı sisteme ya da gerçek veriye dokunabiliyorsa uydurulmaz, kullanıcıya sorulur.
