# Proje geneli kararlar

> Bu dosya iki bölümden oluşur: kısa **Karar dizini** (bütün kararlar, tek satır) ve **proje geneli kararların tam metni**. Karar yazarken sor: "Bu karar sonraki aşamaları etkiler mi?" Evet ise tam metin burada, hayır ise `aktif-asama/KARARLAR.md` dosyasında durur; emin değilsen kullanıcıya sor. Her iki durumda dizine satır eklenir. Numaralar bütün proje boyunca artar ve yeniden kullanılmaz; yeni numara dizindeki en yüksek numaranın bir fazlasıdır.
>
> Kararın anlamı değişirse yeni numara açılır. Eski kaydın metni ve gerekçesi değiştirilmez; dizinde eski satırın durumu "Kısmen değişti: K-yyy" veya "Yerine geçildi: K-yyy" olur, yeni kayıt "Önceki karar" alanında neyin değiştiğini yazar. Arşivdeki bir karar değişirse arşiv metni yeniden yazılmaz; ilişki yeni kayıt ve dizinle kurulur.

Henüz karar yok.

## Karar dizini

Durumlar: Geçerli, Kısmen değişti: K-xxx, Yerine geçildi: K-xxx, Arşivde (tam metin arşiv bağlantısıyla). Dizin satırı kısa tutulur (en çok ~120 karakter); ayrıntı tam metindedir.

| No | Başlık | Kapsam | Durum |
|---|---|---|---|

## Kayıt biçimi

```text
## K-001 — yyyy-MM-dd — Kısa başlık
- Karar: Kullanıcının seçtiği yaklaşım.
- Gerekçe: Kullanıcının söylediği gerekçe; söylemediyse "belirtilmedi".
- Ajan değerlendirmesi: Varsa seçenekler ve bedelleri (isteğe bağlı).
- Önceki karar: Varsa K-xxx ve bu kararla değişen kısım (isteğe bağlı).
- Etki: Etkilenen aşamalar, dosyalar veya kurallar.
- Kaynak: Aşamadan taşındıysa arşiv bağlantısı (isteğe bağlı).
```
