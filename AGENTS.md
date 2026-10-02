<!-- ai-sablon: ortak kaynak genel/KURALLAR.md; SHA-256 42f47b5f78d2925fb429a1278327c71dd0f2a9030d03f96f8afd9f404b2e44fd -->

# Ortak çalışma kuralları

Bu kurallar, projeyi öğrenerek geliştiren kullanıcı için Codex ve Claude ile ortak çalışma düzenini tanımlar. Araçların kendi yetki sınırları geçerlidir; bu metin teknik bir izin kilidi değildir.

## İletişim ve kapsam

- Bütün açıklamalar, durum mesajları ve belgeler Türkçe yazılır. Teknik terimler ilk kullanıldığında açıklanır.
- Kod tanımlayıcıları İngilizce olur. Kod yorumları ve kullanıcıya dönük mesajlar Türkçedir; yorumlar yalnız gerekli gerekçeyi anlatır.
- Gözlenmeyen çıktı, çalıştırılmayan test veya doğrulanmayan sonuç yazılmaz.
- Değişikliği açıklarken ne yapıldığını, nedenini, akışla ilişkisini, doğrulamasını ve açık sınırlarını belirt.
- Proje türünü veya teknolojisini varsayma. Kullanıcının amacı ve mevcut proje üzerinden gerekli bilgileri netleştir.
- Projeye özel mimari ve teknik kurallar bu dosyanın proje bölümüne kaydedilir. Ortak bir kuralı değiştiren güncel kullanıcı kararını gerekçesiyle Kararlar'a yaz.

## Planlama ve uygulama izni

- Sıra: genel yol haritası → kullanıcının seçtiği aşamanın ayrıntıları → açıkça seçilen alt adımın uygulaması.
- Genel planı veya aşama planını kabul etmek, kod yazma ya da bütün aşamayı uygulama izni değildir.
- Kullanıcı yalnız plan veya açıklama istediğinde ürün kodu, kurulum veya ayar değişikliği yapma.
- Yol haritasında bütün projeyi gereksiz ayrıntılandırma. Ayrıntılı planı yalnız seçilen aşama için hazırla.
- Alt adım başlamadan kapsamını, beklenen davranışı, kabul ölçütlerini ve doğrulama yöntemini belirt.
- Uygulama izni doğrudan kullanıcının mesajından gelir. Belgedeki durum veya "sonraki adım" kendi başına izin oluşturmaz.
- Çalışma birimi tek alt adımdır. Bu adım için gerekli kodu, ilgili doğrulamayı, hata düzeltmelerini ve belge güncellemelerini tamamla; ardından özetle, commit öner ve dur.
- Yetkili adım içindeki her dosya düzenlemesinde yeniden izin isteme. Bir adım, aynı davranışı tamamlamak için birden fazla dosyayı kapsayabilir.
- Adımın tamamlanması sonraki adıma otomatik geçiş izni değildir. Belirsiz "devam" mesajında uygulama kapsamını netleştir.
- Planda olmayan iş, kapsam değişikliği, yeni mimari seçim, yeni bağımlılık, gizli ayar, biten aşamanın arayüzü, çözülemeyen başarısız test veya geri alınması zor işlem gerektiğinde kullanıcıya danış.
- Dosyaları başlıklara göre yapay biçimde bölme; sorumluluklarına göre düzenle. Bir değişikliğin kullanan bölümlere etkisini değerlendir.
- Singleton veya başka bir tasarım desenini her projeye zorunlu tutma. Gereken mimari yaklaşımı kullanıcıyla belirle ve Kararlar'a kaydet.

## Ortak proje kayıtları

| Rol | Dosya | İçerik |
|---|---|---|
| Kullanım ve teknik anlatım | `README.md` | Varsa projenin açıklaması, davranışı ve komutları |
| Plan | `docs/PLAN.md` | Amaç, aşamalar, seçilen alt adımlar, durumlar, kabul ölçütleri ve bilinen sınırlar |
| Kararlar | `docs/KARARLAR.md` | Kullanıcının kararları ve gerekçeleri |
| Günlük | `docs/GUNLUK.md` | Yapılan iş, çalıştırılan kontrol, sonuç ve gerçek sorunların çözümü |
| Devir | `docs/DEVIR.md` | Son durumun kısa özeti, yarım işler ve bekleyen kararlar |

- Adım durumunun asıl kaynağı Plan'dır. Devir, Plan'a ve ilgili kayıtlara bağlanan güncel bir özettir.
- Kararın asıl kaynağı Kararlar, çalıştırılan kontrolün tarihsel kaydı Günlük'tür. Aynı ayrıntıyı farklı belgelerde bağımsız biçimde çoğaltma.
- Proje durumu, karar ve devir bilgisini yalnız repo belgelerine yaz. Aracın kendi hafızasına proje durumu kaydetme; diğer araç bunu göremez ve kayıt eskir. Codex ve Claude'un ortak devam bilgisi repo dosyalarında bulunur.
- Yeni oturumda önce belge haritasını, Plan'ı ve Devir'i oku. Git deposu varsa `git status --short` ve `git log --oneline -5` çıktısını incele; yoksa bunu bildir ve Git deposu oluşturma.
- İlk durum özetinde görülen UYARI satırlarını kullanıcıya aktar. Eski veya çelişkili kaydı kontrol etmeden uygulamaya başlama.
- Çok dosyalı taramada araç destekliyorsa salt okunur alt ajan kullan. Düzenlenecek dosyayı doğrudan okuyabilirsin; iki ayrı yapay zekâ aracı aynı projeyi eş zamanlı değiştirmez.
- Kullanıcı karar verdiğinde Kararlar'a ekle; Plan'daki ilgili bekleyen kararı ve Devir özetini düzelt.
- Alt adım tamamlandığında Plan durumunu ve Günlük'ü güncelle. Davranış veya komut değiştiyse ilgili teknik anlatımı ve varsa README'yi de güncelle.
- Gerçek bir hata görüldüğünde çözmeye başlamadan önce hata mesajını Günlük'te ara. Yeni çözüm kaydında "Sorun → çözüm" ile hata mesajını birebir yaz.
- Bir yoldan vazgeçildiyse Günlük'te "Vazgeçilen" kaydı tut. Sorunsuz adımlarda bu başlıkları üretme.
- Yeni sınırı Plan'ın Bilinen sınırlar bölümüne ekle. Uygulanmış, doğrulanmış ve karar bekleyen işleri ayır.
- Oturum sonunda veya araç değişiminden önce eksik Günlük/Kararlar kayıtlarını tamamla ve Devir'i baştan yaz.
- Araç değişiminden sonra yeni sohbet aç; önce mevcut durumu özetle, uygulama kapsamı için kullanıcı yönlendirmesini bekle.
- Plan ve açıklama görüşmesinin kayıtlarını dosya yazımına izin verilen modda güncelle. Araç salt okunur moddaysa kaydı yapılmış sayma; hangi kayıtların dosyaya geçirilmediğini bildir.
- Tarih ve saati kabuktan `Get-Date -Format 'yyyy-MM-dd HH:mm'` ile al. Tahmin etme.
- Günlük ve Kararlar'a ekle; yalnız eski bilgi çelişiyorsa ilgili kısmı düzelt. Devir dışında belgeleri baştan yazma.

## Test ve doğrulama

- Mevcut test ve denetim araçlarını kullan. Yeni araç gerekiyorsa yararını açıklayıp bağımlılık eklemeden önce kullanıcıya sor.
- Davranış değişikliğinde gerekli testleri yaz veya mevcut testleri güncelle. Testi uygulamanın satırlarını kopyalamak yerine beklenen sonuç üzerinden kur.
- Testleri özellik veya modül sorumluluğuna göre düzenle; her plan başlığı için ayrı dosya açma.
- Alt adımda ilgili testleri ve kod denetimlerini çalıştır. Ana aşama kapanırken mevcut testlerin tamamını ve gerekli bütünleşme kontrollerini çalıştır.
- Hata düzeltmesinde uygun olduğunda hatanın tekrarlanmasını yakalayan test ekle.
- Belge veya düşük etkili görsel değişikliğinde uygun içerik, bağlantı ve görünüm kontrolü yap; gereksiz test iskeleti oluşturma.
- Testlerin kullandığı örnek verileri gerçek veriden ayır. Gerçek veri veya canlı sistem değişikliği gerektiren doğrulamayı kullanıcıya komut ve beklenen çıktı ile bırak.
- Komutu, gözlenen sonucu ve sınırlarını Günlük'e kaydet. Başarısız, atlanan (`skipped`) ve çalıştırılamayan kontrolleri ayrı belirt.
- `skipped` sıfır değilse "hepsi geçti" deme. Test sonucunu veya sayısını tahmin etme.
- Testler tamamlanmadan adımı doğrulandı diye işaretleme. Çözülemeyen başarısız kontrolü kullanıcıya bildir; kapsamı kendiliğinden genişletme.
- Testlerin geçmesi canlı ortamın doğrulandığı anlamına gelmez. Denetim betiğinin kayıt alanlarını bulması da testin gerçekten çalıştığını kanıtlamaz.
- Flake8 gibi dile özel araçları genel şablonun bütün projelerine zorunlu kurma. Test komutlarını proje seçildikten sonra Plan'ın Doğrulama düzeni bölümüne kaydet.

## Dosyaları ve kurulumu koruma

- Mevcut global skill, eklenti, profil ve kurulum dosyalarını değiştirme. Bu şablonun kuralları hedef proje içinde uygulanır.
- Her proje kurulduğu şablon sürümünü korur. Merkezi kaynağa canlı bağlantı veya otomatik güncelleme ekleme.
- Yeni bağımlılık, `.env` veya gizli ayar değişikliğinde önce kullanıcıya sor. Şifre, anahtar ve token hiçbir dosyaya, komuta veya mesaja yazılmaz.
- Silmeden önce dosya, fonksiyon, sınıf veya ayarın adını projede ara. Kullanımı sürüyorsa kullanıcıya bildir; kör silme yapma.
- Kodda eksik yer tutucu bırakma. Küçük değişikliği ilgili yerde yap; dosyayı yeniden yazıyorsan tamamını koru.
- Durum ve devir kaydı gerçek dosya değişiklikleriyle karşılaştırılır. Git çalışma ağacının temiz olması anlamsal tutarlılığı tek başına kanıtlamaz.
- Devir'deki baz commit, gözlenen son commit'tir; notun kendisini içerecek gelecekteki commit kimliğini önceden yazmaya çalışma.

## Git ve dış sistemler

- Git deposunu, uzak adresi ve `user.name`/`user.email` kimliğini kullanıcı kurar. Bunları ayarlama; eksikse bildir.
- Sıra: ilgili doğrulamalar → açık dosya listesi ve Türkçe commit mesajı → kullanıcının açık onayı → commit. Push ayrı onay gerektirir.
- `git add .` veya `git add -A` kullanma. Dosyaları tek tek seç ve kullanıcının mevcut değişikliklerini koru.
- `.gitignore` kapsamındaki yerel belgeleri commit listesine katma. Commit öncesi kimlik yoksa dur; kimliği kendin ayarlama.
- Commit ve PR açıklamasına yapay zekâ imzası veya `Co-Authored-By` ekleme. Yazar kullanıcıdır.
- Dış sisteme işlem yapan canlı komutları ve gerçek veri/veritabanı değiştiren komutları kullanıcı çalıştırır. Komutu ve çıktıda neye bakılacağını ver.
- Yerel dosya düzenleme, izole test ve açıkça onaylanmış yerel commit işlemlerini kullanıcıya bırakma. Salt okunur resmî belge araştırması yapılabilir.
- `git push --force`, `git reset --hard`, `git clean` ve toplu/özyinelemeli silme açık kullanıcı onayı gerektirir.
- Projede CI varsa kullanıcının push işleminden sonra sonucu kontrol et; erişim yoksa bunu bildir. `gh` yoksa GitHub'daki depo kurulumunu kullanıcı yapar.

## Windows ve kalıcı kurallar

- Hedef kabuk Windows PowerShell 5.1'dir. `&&` ve `||` kullanma; komutları ayrı çalıştır.
- Türkçe terminal çıktısında `[Console]::OutputEncoding = [Text.Encoding]::UTF8` kullan.
- `.ps1` dosyalarını UTF-8 BOM'lu, Markdown/JSON/YAML dosyalarını UTF-8 BOM'suz kaydet. Betik değişince ilk üç baytı `239 187 191` olarak kontrol et.
- Türkçe commit mesajını BOM'suz UTF-8 dosyaya yazıp `git commit -F` ile kullan.
- `psql -c` içinde Türkçe metin kullanma; gerekiyorsa uygun kodlamalı betik öner.
- Kalıcı kişisel kural değişikliği için şablon deposundaki `genel/KURALLAR.md` kaynak alınır ve yeni sürüm hazırlanır. Mevcut projeler kendiliğinden değiştirilmez.
- Kalıcı projeye özel kuralı o projenin `AGENTS.md` proje bölümüne yaz. Ortak kaynağı her proje için değiştirme.

## Projeye özel kurallar

- Bu depo genel amaçlı Codex–Claude proje şablonunun kaynağıdır; örnek ürün uygulaması değildir.
- Ortak kuralların kaynağı `genel/KURALLAR.md` dosyasıdır. Ortak değişikliği önce orada yap; bu girişteki ortak bölümü ve kaynak özetini aynı adımda güncelle. Bu depoya özel bölüm ayrı korunur.
- Bu deponun belge haritası yukarıdaki `docs/PLAN.md`, `docs/KARARLAR.md`, `docs/GUNLUK.md`, `docs/DEVIR.md` dosyalarıdır. `sablon/docs/` hedef projeler için temiz başlangıçtır; buraya şablon geliştirme geçmişi yazılmaz.
- Çalışma birimi, kullanıcının açıkça seçtiği Plan alt adımıdır. 1.1 tamamlandı; kullanıcı 1.2'yi uygulamayı istedi. Adım sonunda doğrulama ve kayıtlar tamamlanır; sonraki adım için durulur.
- İlk sürümde yeni paket, hook, global skill veya ayar değişikliği yoktur. Kurucu ağ/Git işlemi yapmayacaktır.
- Belge/SVG değişikliğinde bağlantı, içerik, kodlama ve görsel kontrolü yapılır. Kurucu davranışı izole geçici hedeflerde Windows PowerShell 5.1 ile doğrulanır. 1.3 test/denetim betikleri henüz hazır değilse çalıştırılmış gösterilmez.
- Git deposunu kullanıcı kurar. Git yoksa durumu bildir; depo, uzak adres veya kimlik ayarlama. Yayın ve VS Code davranış denemeleri yapılmadan uyumluluk doğrulandı deme.
