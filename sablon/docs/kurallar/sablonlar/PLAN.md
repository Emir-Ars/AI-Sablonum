# Aşama planı

> Yalnız aktif aşamanın ayrıntısı; alt adım durumunun tek kaynağı. Yeni oturumda yalnız "Başlangıç", "Aşama kuralları" ve ilgili adım satırları okunur. Yazım kuralları: `docs/kurallar/PLANLAMA.md`. Aşama kapanınca bu klasörle birlikte arşive taşınır.

## Başlangıç

- Aşama: Henüz seçilmedi (numara ve ad yol haritasından).
- Aşama durumu: Araştırma bekleniyor.
- Güncel alt adım: Yok.
- Kapsam sınırı: Henüz yok (ayrıntı "Amaç ve kapsam" ve "Kapsam dışı" bölümlerinde).
- Bağlantılar: [TASARIM.md](TASARIM.md), [KARARLAR.md](KARARLAR.md), [GUNLUK.md](GUNLUK.md); araştırma belgeleri bu klasördeki `arastirma/` altında.

Bu bölüm en fazla 15 satırdır; durum tablosu, tasarım, commit/CI kimliği ve test sayısı burada yazılmaz.

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

- Durumlar: `Planlandı`, `Uygulanıyor`, `Doğrulama bekliyor`, `Doğrulandı`, `Karar bekliyor` (durum değişikliği uygulama izni değildir).
- İnceleme: `Zorunlu` / `Hafif` / `Yok` ve kısa gerekçe (`docs/kurallar/INCELEME.md`). İlgili kaynaklar: yalnız adımın gereken belge/kod/test bağlantıları ve sonda `plan: K-xxx`.
- Adım bölme ve "Doğrulandı" satırını kısaltma (~300 karakter) kuralları: `docs/kurallar/PLANLAMA.md`.

## Aşama kapanış ölçütleri

Bütün alt adımlar doğrulandıktan sonra aşamanın bütün olarak karşılaması gerekenler.

## Bilinen sınırlar

Yalnız bu aşamada giderilecek sınırlar. Kalıcı olanlar `AGENTS.md` §4 "Bilinen sınır" satırındaki yere yazılır; aşama kapanırken buradakiler de oraya taşınır.

Yok.
