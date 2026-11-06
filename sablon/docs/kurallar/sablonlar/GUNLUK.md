# Aşama günlüğü

> Bu aşamada yapılan iş ve çalıştırılan kontroller. Baştan sona okunmaz; adım numarası, hata metni veya K-numarasıyla aranır. Yeni kayıt dosyanın sonuna eklenir; eski kayıt değiştirilmez.
>
> - Alt adım başına hedef üç kısa kayıttır (planlama; uygulama ve doğrulama; commit ve sonuç). Yeni hata, önemli karar, kesinti veya yeniden açılan iş için ek kayıt yazılır; sınır yüzünden bilgi atlanmaz.
> - Komut çıktısı yapıştırılmaz; komut, sayı ve sonuç yazılır. Aynı sonuç tekrar yazılmaz.
> - Yanlış bir eski kayıt, ona işaret eden düzeltme kaydıyla düzeltilir. Başarısız deneme sonradan başarılı gösterilmez.

Henüz kayıt yok.

## Kayıt biçimi

```text
## yyyy-MM-dd HH:mm — 2.3 kısa açıklama
- Yapılan: Ne ve neden (1–3 cümle).
- Değişen dosyalar:
- Doğrulama: Çalıştırılan komut ve gözlenen sonuç.
- Başarısız / atlanan / çalıştırılamayan: Yoksa "yok".
- Sorun → çözüm: Yalnız gerçek hata olduysa; hata mesajı birebir.
- Yarım kaldıysa: Kalan iş, engel ve devam noktası.
```

Düzeltme kaydı:

```text
## yyyy-MM-dd HH:mm — 2.3 düzeltme
- Düzeltilen kayıt: yyyy-MM-dd HH:mm — 2.3 kısa açıklama
- Doğrusu: Ne yanlıştı, doğrusu ne, nasıl anlaşıldı.
```
