# v0.3.6 — Alt adımları etkin plana kaydetme

2026-11-24. Kapsam şablon deposu ve geçici doğrulama projeleridir. Çalışma düzeni `genel/KURALLAR.md` ile `sablon/docs/kurallar/PLANLAMA.md` dosyalarına işlendi. Kök `AGENTS.md` ortak kaynakla eşitlendi. v0.3.5 ortak kısmının LF (Unix satır sonu) biçimindeki SHA-256 özeti `surum.json` dosyasına eklendi.

## Geçici proje denemesi

Windows PowerShell 5.1'de `kur.ps1` ile boş bir geçici klasöre v0.3.6 kuruldu. Mevcut bir santimetre dönüşümü ve testi, tasarım belgesi, tam sayı sözleşmesi ve yalnız `3.1` satırını içeren aşama planı hazırlandı. Başlangıç testi geçti. Ajan aşağıdaki dosya ve uygulama akışını bu örnekte yürüttü.

| Deneme | Gözlenen sonuç |
|---|---|
| `3.1'i planla` | Aynı `PLAN.md` tablosunda sırayla `3.1`, `3.1.1` ve `3.1.2` satırları oluştu. Ana satır alt numaraları gösterdi ve `Planlandı` kaldı. Tüm örnek proje dosyalarının özetleri karşılaştırıldığında tek fark `PLAN.md` idi. Var olan tasarım yeterliydi. |
| Aynı adımı yeniden planla | İkinci kayıt işlemi hiçbir dosyanın içeriğini değiştirmedi. Üç satır aynı sırada ve durumdaydı. |
| `3.1.1'i uygula` | Kilometreden metreye dönüşüm ve testi eklendi. `ConvertTo-Meter 2` sonucu 2000, mevcut santimetre dönüşümünün sonucu 200 oldu ve test komutu başarılı çıktı. `3.1.1` `Doğrulandı` oldu. `3.1` ve `3.1.2` satırları aynen `Planlandı` kaldı. Milimetre dönüşümünün kodu veya testi eklenmedi. |

## Paket kontrolleri

- `tests/kur-smoke.ps1` ilk koşuda geçti=3, kaldı=27, atlandı=0. Kısıtlı ortamda `[Environment]::GetFolderPath('UserProfile')` boş döndüğünden kurucu ön kontrolde durdu. Kurucu ve test dosyaları değiştirilmeden normal Windows erişimiyle tekrar çalıştırıldı. İkinci koşuda geçti=30, kaldı=0, atlandı=0.
- `tests/bilinen-hashler.ps1` sonucu EKSİK=0, FAZLA=0. Git geçmişinden 10 farklı eski ortak kısım bulundu.
- Ayrı bir geçici klasörde v0.3.5 kuruldu ve `guncelle.ps1 -Uygula` ile v0.3.6'ya geçirildi. Kurulu ortak kural ve planlama rehberi güncel kaynakla eşleşti. Dolu plan ve `AGENTS.md` özel bölümü aynı kaldı. Güncelleme sonrası ilk kontrolde yanlış sürüm alanı okundu. Doğru `templateVersion` alanıyla yeniden kontrol edildi ve `0.3.6` görüldü.

## Yalnız kural metniyle kontrol edilenler

- Araç yalnız sohbet planı sunabiliyorsa hemen sonraki `uygula` veya `Implement this plan` yalnız sunulan belge düzenlemesini yetkilendirir. Açıkça yalnız sohbet değerlendirmesi istendiğinde dosyaya yazılmaz.
- Aralık yetkisi mevcut işleyişi izler. Yeniden planlama tamamlanmış satırları ve önceki kayıtların başvurduğu numaraları korur. Ana satır, tüm alt satırlar ve kendi kabul ölçütü doğrulanınca tamamlanır.
- Örnek, bu oturumda dosya işlemleri ve test komutlarıyla yürütüldü. Kurulan talimatların komutları yeni bir Codex ya da Claude oturumunda nasıl yorumlatacağı ve Plan modundan geçiş ayrıca denenmedi.
