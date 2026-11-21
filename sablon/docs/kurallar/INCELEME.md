# Bağımsız inceleme

Bu dosya bir alt adımın inceleme katmanı belirlenirken (planlama, küçük iş istisnası) ve katman "zorunlu" veya "hafif" olduğunda okunur.

Bağımsız inceleme: kodu veya tasarımı yazan ajandan ayrı, salt okunur bir alt ajanın hata arayan değerlendirmesidir. Testlerin yerine geçmez.

## Katmanlar

Alt adım planlanırken katman ve tek cümlelik gerekçesi `PLAN.md` tablosundaki "İnceleme" sütununa yazılır. Birden fazla ölçüt varsa en yükseği seçilir.

- Katman hatanın sonucuna göre belirlenir, kodun uzunluğuna göre değil; kısa bir değişiklik de sessizce yanlış sonuç verebilir.
- Kod değişikliğinde şu da sorulur: "Hata, test ve CI kırmızı olmadan program çıktısını, veriyi veya hesap sonucunu bozabilir mi?" Evetse katman en az Hafif'tir; aşağıdaki tablonun Zorunlu ölçütlerinden birine de giriyorsa Zorunludur. Tablodaki "Yok" örnekleri bu soruyla yükselmez.
- Belirsizse bir üst katman önerilir. Katmanı düşürmek kullanıcı kararıdır; ajan kendiliğinden düşürmez.

| Katman | Ne zaman | Ne yapılır |
|---|---|---|
| Zorunlu | Veri kaybı, güvenlik veya gizli bilgi, gerçek para, geri alınması zor işlem, kritik hesapta sessiz yanlış sonuç riski | Kod yazılmadan önce tasarım, yazıldıktan sonra kod incelenir |
| Hafif | Birden fazla modülün kullandığı ortak koda veya arayüze etki, mevcut bir doğrulama ya da güvenlik korumasına istisna ekleme, hatası testlerle kolay yakalanmayacak karmaşık mantık | İş bitince bir inceleme |
| Yok | Yukarıdakilere girmeyen her şey: belge düzenlemesi, görünüm değişikliği, testlerle doğrulanan yerel davranış değişikliği, yeniden adlandırma | Ek inceleme yok; normal kontrol ve testler yeterli |

Uygulama sırasında risk büyürse katmanı yükselt ve kullanıcıya bildir.

## Nasıl yapılır

- İnceleyene kapsam, kabul ölçütleri, ilgili diff, gerekli arayüzler ve kararları ver; bütün repoyu verme. Yazarın "çalışıyor" yorumunu verme.
- İnceleyen salt okunurdur ve `AGENTS.md` §1 ile §7 sınırlarıyla çalışır; bu sınırlar görevle birlikte yazılır. Ağ, canlı sistem veya gerçek veri gerekiyorsa önce kullanıcıya sorulur.
- Bulgu kanıt, somut karşı örnek veya tekrar adımı içermelidir. Kanıtsız bulgu doğrudan uygulanmaz.
- Doğrulanan bulguyu kapsam içindeyse düzelt; mümkünse bulguyu yakalayan bir test ekle. Yeniden inceleme yalnız önemli bir bulgunun düzeltmesinden sonra ve yalnız düzeltilen bölüm için yapılır; değişmemiş kod tekrar incelenmez. Kapsamı genişleten bulguda kullanıcıya danış.
- Zorunlu katmanda kritik davranışın testi, davranış geçici olarak bozulduğunda kırmızı olmalıdır. Bozma elle yapılan geçici bir düzenlemedir ve aynı yolla elle geri alınır; `git checkout`, `git restore` veya `git stash` kullanılmaz, çünkü commit edilmemiş düzeltmeyi siler ya da geri getirmeyi riske atar. Dosyanın hash'i bozmadan önce ve geri aldıktan sonra karşılaştırılır.
- Bulguları ve sonucu aşamanın `GUNLUK.md` dosyasına kısa yaz; çözülemeyenleri `AGENTS.md` §4 "Bilinen sınır" satırındaki yere ekle.
- Araç alt ajanı desteklemiyorsa veya inceleme yapılamadıysa bunu kullanıcıya söyle ve günlüğe "Çalıştırılamayan" olarak yaz. Kendi kontrolünü bağımsız inceleme gibi sunma. Zorunlu inceleme yapılamadıysa adım "Doğrulandı" sayılmaz.
