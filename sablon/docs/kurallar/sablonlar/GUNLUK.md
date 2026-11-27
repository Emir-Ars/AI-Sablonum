# Aşama günlüğü

> Bu aşamada yapılan iş ve çalıştırılan kontroller. Baştan sona okunmaz; adım numarası, hata metni veya K-numarasıyla aranır. Yeni kayıt dosyanın sonuna eklenir; eski kayıt değiştirilmez.
>
> - Alt adım başına hedef üç kısa kayıttır (planlama; uygulama, doğrulama ve inceleme; sonuç: commit, push, CI ve varsa birleştirme ile dal silme). Sonuç kaydı veya geçici bozma kaydı son kayıtken sonradan gelen sonuç sonuna satır olarak eklenir (`docs/kurallar/GIT.md`, `docs/kurallar/INCELEME.md`); bu, eski kaydı değiştirmek sayılmaz. Yeni hata, önemli karar, kesinti veya yeniden açılan iş için ek kayıt yazılır; sınır yüzünden bilgi atlanmaz.
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

Kapanış sonucu (adım 7 bağlantı taraması ve kapanmış aşamanın commit/CI sonucu; arşiv değişmez):

```text
## yyyy-MM-dd HH:mm — Aşama 2 kapanış sonucu
- Bağlantı taraması: kırık bağlantı sayısı.
- Commit: gözlenen commit kimliği.
- Sonuç: CI yeşil / kırmızı / okunamadı; varsa koşu kimliği veya bağlantısı.
```

Düzeltme kaydı:

```text
## yyyy-MM-dd HH:mm — 2.3 düzeltme
- Düzeltilen kayıt: yyyy-MM-dd HH:mm — 2.3 kısa açıklama
- Doğrusu: Ne yanlıştı, doğrusu ne, nasıl anlaşıldı.
```
