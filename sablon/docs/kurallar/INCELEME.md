# Bağımsız inceleme

Bu dosya yalnız bir alt adımın inceleme katmanı "zorunlu" veya "hafif" olduğunda okunur.

Bağımsız inceleme: kodu veya tasarımı yazan ajandan ayrı, salt okunur bir alt ajanın hata arayan değerlendirmesidir. Testlerin yerine geçmez.

## Katmanlar

Alt adım planlanırken katman ve tek cümlelik gerekçesi `PLAN.md` tablosundaki "İnceleme" sütununa yazılır. Birden fazla ölçüt varsa en yükseği seçilir.

| Katman | Ne zaman | Ne yapılır |
|---|---|---|
| Zorunlu | Veri kaybı, güvenlik veya gizli bilgi, gerçek para, geri alınması zor işlem, kritik hesapta sessiz yanlış sonuç riski | Kod yazılmadan önce tasarım, yazıldıktan sonra kod incelenir |
| Hafif | Birden fazla davranış yolu, ortak kullanılan bölümlere etki, mevcut korumaya istisna | İş bitince bir inceleme |
| Yok | Belge, görünüm veya davranış değiştirmeyen düzenleme | Ek inceleme yok; normal kontrol yeterli |

Uygulama sırasında risk büyürse katmanı yükselt ve kullanıcıya bildir.

## Nasıl yapılır

- İnceleyene kapsam, kabul ölçütleri, ilgili kod ve gerekli kararları ver. Yazarın "çalışıyor" yorumunu verme.
- Bulgu kanıt, somut karşı örnek veya tekrar adımı içermelidir. Kanıtsız bulgu doğrudan uygulanmaz.
- Doğrulanan bulguyu kapsam içindeyse düzelt; önemli düzeltmeden sonra ilgili bölümü yeniden incelet. Kapsamı genişleten bulguda kullanıcıya danış.
- Bulguları ve sonucu aşamanın `GUNLUK.md` dosyasına kısa yaz; çözülemeyenleri `PLAN.md` "Bilinen sınırlar" bölümüne ekle.
- Araç alt ajanı desteklemiyorsa veya inceleme yapılamadıysa bunu kullanıcıya söyle ve günlüğe "Çalıştırılamayan" olarak yaz. Kendi kontrolünü bağımsız inceleme gibi sunma. Zorunlu inceleme yapılamadıysa adım "Doğrulandı" sayılmaz.
