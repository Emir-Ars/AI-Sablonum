# Proje geneli kararlar

> Bu dosya iki bölümden oluşur: kısa **Karar dizini** (bütün kararlar, tek satır) ve **proje geneli kararların tam metni**. Karar yazarken sor: "Bu karar sonraki aşamaları etkiler mi?" Evet ise tam metin burada, hayır ise `aktif-asama/KARARLAR.md` dosyasında durur; emin değilsen kullanıcıya sor. Her iki durumda dizine satır eklenir. Numaralar bütün proje boyunca artar ve yeniden kullanılmaz; yeni numara dizindeki en yüksek numaranın bir fazlasıdır.
>
> Kararın anlamı değişirse yeni numara açılır. Eski kaydın metni ve gerekçesi değiştirilmez; dizinde eski satırın durumu "Kısmen değişti: K-yyy" veya "Yerine geçildi: K-yyy" olur, yeni kayıt "Önceki karar" alanında neyin değiştiğini yazar. Arşivdeki bir karar değişirse arşiv metni yeniden yazılmaz; ilişki yeni kayıt ve dizinle kurulur.

Henüz karar yok.

## Karar dizini

Geçerlilik ile saklandığı yer ayrı sütunlardadır; arşivleme yalnız "Tam metin" sütununu değiştirir, "Durum" sütununu ve K-xxx ilişkisini silmez.

- **Durum** (geçerlilik): Geçerli, Kısmen değişti: K-xxx, Yerine geçildi: K-xxx. Yeni karar eskinin yerini alınca eski satırın durumu yeni karara bağlanır; eski karar arşivde olsa da dizin satırı güncellenir, arşiv metni değişmez.
- **Tam metin** (yer): `bu dosya`, `aşama` (aşama kapanmadıysa `aktif-asama/KARARLAR.md`) veya arşiv bağlantısı (kapanmış aşamanın `KARARLAR.md` dosyası ya da yerine geçilip taşınan karar için `arsiv/KARARLAR_ESKI.md`).
- **Kapsam** yalnız "Proje geneli" veya "Aşama N" olur. Dizin satırı kısa tutulur (en çok ~120 karakter); ayrıntı tam metindedir.

| No | Başlık | Kapsam | Durum | Tam metin |
|---|---|---|---|---|

## Kayıt biçimi

Dizin satırı örneği: aşama 1'de alınıp arşive taşınmış K-004'ün yerini sonra alınan K-012 almıştır; ilişki iki yönde okunur (dizinde K-004 → K-012, K-012 kaydında "Önceki karar: K-004").

```text
| K-004 | Örnek eski karar | Aşama 1 | Yerine geçildi: K-012 | [arşiv](arsiv/01-ad/KARARLAR.md#k-004--2026-01-05--örnek-eski-karar) |
| K-012 | Örnek yeni karar | Proje geneli | Geçerli | bu dosya |
```

Tam metin kaydı:

```text
## K-001 — yyyy-MM-dd — Kısa başlık
- Karar: Kullanıcının seçtiği yaklaşım.
- Gerekçe: Kullanıcının söylediği gerekçe; söylemediyse "belirtilmedi".
- Ajan değerlendirmesi: Varsa seçenekler ve bedelleri (isteğe bağlı).
- Önceki karar: Varsa K-xxx ve bu kararla değişen kısım (isteğe bağlı).
- Etki: Etkilenen aşamalar, dosyalar veya kurallar.
- Kaynak: Aşamadan taşındıysa arşiv bağlantısı (isteğe bağlı).
```
