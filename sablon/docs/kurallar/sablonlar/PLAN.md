# Aşama planı

> Yalnız aktif aşamanın ayrıntısı; alt adım durumunun tek kaynağı. Yeni oturumda yalnız "Başlangıç", "Aşama kuralları" ve ilgili adım satırları okunur. Yazım kuralları: `docs/kurallar/PLANLAMA.md`. Aşama kapanınca bu klasörle birlikte arşive taşınır.

## Başlangıç

- Aşama: Henüz seçilmedi (numara ve ad yol haritasından).
- Aşama durumu: Araştırma bekleniyor.
- Güncel alt adım: Yok.
- Kapsam sınırı: Henüz yok (ayrıntı "Amaç ve kapsam" ve "Kapsam dışı" bölümlerinde).
- Bağlantılar: [TASARIM.md](TASARIM.md), [KARARLAR.md](KARARLAR.md), [GUNLUK.md](GUNLUK.md); araştırma belgeleri bu klasördeki `arastirma/` altında.

Bu bölüm en fazla 15 satırdır; durum tablosu ve tasarım burada tekrar edilmez.

## Aşama kuralları

Yalnız bu aşamada geçerli kurallar. Aşamayla birlikte arşive gider.

- Henüz yok.

## Amaç ve kapsam

Aşama seçilip araştırma belgeleri eklenince yazılır.

## Kapsam dışı

Henüz yok.

## Alt adımlar

| No | Kapsam | Kabul ölçütü | Doğrulama | İnceleme | İlgili kaynaklar | Durum |
|---|---|---|---|---|---|---|

- İlgili kaynaklar: yalnız o adım için gereken belge/bölüm, K-numarası, kod veya test yolu; kısa göreli bağlantı. Bütün repo veya klasör listelenmez.
- İnceleme: Zorunlu / Hafif / Yok ve kısa gerekçe (`docs/kurallar/INCELEME.md`).
- Durumlar: Planlandı, Uygulanıyor, Doğrulama bekliyor, Doğrulandı, Karar bekliyor. Durum değişikliği uygulama izni değildir.
- "Doğrulandı" satırı yaklaşık 300 karaktere indirilir: tek cümlelik kapsam, doğrulama özeti (commit, test sayısı), `GUNLUK.md` bağlantısı; "İlgili kaynaklar" kalır. Kabul ölçütü önce günlükte veya tasarımda bulunmalıdır.

## Aşama kapanış ölçütleri

Bütün alt adımlar doğrulandıktan sonra aşamanın bütün olarak karşılaması gerekenler.

## Bilinen sınırlar

Yok.
