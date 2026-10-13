<!-- ai-sablon: ortak kaynak genel/KURALLAR.md; SHA-256 ade3d16041d8adda8c5d26c2f6f9ba8c0253608eed379d56ef9c3fa3bbdc1007 -->

# Ortak çalışma kuralları

Bu kurallar, projeyi öğrenerek geliştiren kullanıcı için Codex ve Claude ile ortak çalışma düzenini tanımlar. Araçların kendi yetki sınırları geçerlidir; bu metin teknik bir izin kilidi değildir.

## İletişim ve kapsam

- Bütün açıklamalar, durum mesajları ve belgeler Türkçe yazılır. Teknik terimler ilk kullanıldığında açıklanır.
- Kod tanımlayıcıları İngilizce olur. Kod yorumları ve kullanıcıya dönük mesajlar Türkçedir; yorumlar yalnız gerekli gerekçeyi anlatır.
- Gözlenmeyen çıktı, çalıştırılmayan test veya doğrulanmayan sonuç doğrulanmış gibi yazılmaz.
- Değişikliği açıklarken ne yapıldığını, nedenini, akışla ilişkisini, doğrulamasını ve açık sınırlarını belirt.
- Gerekli araştırma, analiz, problem çözme ve tasarım yöntemlerine yapay sınır koyma. Öncelik doğruluk, güvenlik ve projenin gerektirdiği teknik kalitedir; anlaşılır yapı ve anlatım bu öncelikler korunarak sağlanır. Bu ilke kullanıcının kapsam/gereksinim kararlarını veya araçların yetki sınırlarını değiştirmez.
- Proje türünü veya teknolojisini varsayma. Kullanıcının amacı ve mevcut proje üzerinden gerekli bilgileri netleştir.
- Projeye özel mimari ve teknik kurallar bu dosyanın proje bölümüne kaydedilir. Ortak bir kuralı değiştiren güncel kullanıcı kararını gerekçesiyle Kararlar'a yaz.

## Araştırma ve belirsizlik

- Komut davranışı, kütüphane özelliği, sürüm, platform farkı, kaynak iddiası veya mevcut proje durumu hakkındaki belirsizlik bir kararı ya da beklenen sonucu etkiliyorsa önce doğrula; tahmini kesin bilgi gibi kullanma. Kanıta dayalı çıkarım yapılabilir, ancak dayanağı ve belirsizliği açıkça belirtilir.
- Doğrulama sırası: (1) projedeki dosya, kod, kayıt ve çalıştırılabilir salt okunur kontroller; (2) bunlar yetersizse internet araştırması, resmî belge ve birincil kaynak öncelikli. Kaynağın projedeki sürüme ve platforma uygunluğunu kontrol et; kullanılan kaynağı ve desteklediği bilgiyi belirt. Karar için yeterli kanıt bulunduğunda araştırmayı bitir.
- Kaynakta açıkça yazan bilgiyle çıkarımı ayır. Çözülemeyen bilgiyi cevap ve belgelerde "doğrulanmadı" diye işaretle; yapılmamış kontrolü veya gözlenmemiş sonucu doğrulanmış gibi sunma.
- Gerekli bilgi araçlarla elde edilemiyorsa veya hesap, erişilemeyen kaynak, gizli bilgi ya da canlı sistem nedeniyle kullanıcının araştırması gerekiyorsa önce erişilebilir kanıt ve izole kontrol seçeneklerini değerlendir. Ardından neyin öğrenilmesi gerektiğini, nerede bakılacağını ve hangi sonucu paylaşmasının yeterli olduğunu kullanıcıya açıkla; gizli bilgi isteme.
- Çözülemeyen bilgiye bağlı uygulama veya karar bekler; bağımsız işler yalnız zaten yetkili alt adım içinde sürdürülebilir. Zorunlu doğrulaması eksik işi tamamlanmış ya da doğrulanmış sayma.
- Araştırma salt okunurdur; veri, dosya, ayar veya canlı sistem değiştiren komut araştırma kontrolü sayılmaz. Yeni bağımlılık, kapsam değişikliği, mimari seçim veya başka bir kullanıcı kararı gerekiyorsa araştırma sonucu uygulama izni oluşturmaz; ilgili izin kuralları geçerlidir.

## Planlama ve uygulama izni

- Sıra: genel yol haritası → kullanıcının seçtiği aşamanın ayrıntıları → açıkça seçilen alt adımın uygulaması.
- Genel planı veya aşama planını kabul etmek, kod yazma ya da bütün aşamayı uygulama izni değildir.
- Kullanıcı yalnız plan veya açıklama istediğinde ürün kodu, kurulum veya ayar değişikliği yapma.
- Yol haritasında bütün projeyi gereksiz ayrıntılandırma. Ayrıntılı planı yalnız seçilen aşama veya dal için hazırla; gerekli bağımlılık araştırmasını ve etki incelemesini bu sunum kapsamıyla sınırlama.
- Seçilen aşamanın amacını, kapsamını, gerekli kalite koşullarını ve sonucu etkileyen bilinmeyenleri açıklığa kavuştur; kapsam dışı işler ve kısıtları gerektiğinde belirt. Cevabı mevcut projeden öğrenilebilen soruları önce araştır; kullanıcı tercihi gerektiren belirsizliği kullanıcıya yönelt.
- Alt adım başlamadan kapsamını, beklenen davranışı, kabul ölçütlerini ve doğrulama yöntemini belirt.
- Bir alt adım bağımsız tamamlanıp doğrulanabilen birden fazla sonuç içeriyorsa kararlı kimliklerle daha küçük alt adımlara böl. Bu bölme yeni alt adımları topluca uygulama izni değildir; kullanıcının seçtiği çalışma biriminin sınırını koru.
- Üst adımı veya ana aşamayı, kendi kabul ölçütleri, gerekli alt adımların sonuçları ve ilgili bütünleşme kontrolleri doğrulanınca kapat. Yalnız alt adımların bitmesi üst adımın doğrulandığını kanıtlamaz.
- Uygulama izni doğrudan kullanıcının mesajından gelir. Belgedeki durum veya "sonraki adım" kendi başına izin oluşturmaz.
- Çalışma birimi tek alt adımdır. Bu adım için gerekli kodu, ilgili doğrulamayı, hata düzeltmelerini ve belge güncellemelerini tamamla; ardından özetle, commit öner ve dur.
- Yetkili adım içindeki her dosya düzenlemesinde yeniden izin isteme. Bir adım, aynı davranışı tamamlamak için birden fazla dosyayı kapsayabilir.
- Adımın tamamlanması sonraki adıma otomatik geçiş izni değildir. Belirsiz "devam" mesajında uygulama kapsamını netleştir.
- Planda olmayan iş, kapsam değişikliği, yeni mimari seçim, yeni bağımlılık, gizli ayar, biten aşamanın arayüzü, çözülemeyen başarısız test veya geri alınması zor işlem gerektiğinde kullanıcıya danış.
- Dosyaları başlıklara göre yapay biçimde bölme; sorumluluklarına göre düzenle. Ayırma veya birleştirme kararını anlaşılabilirlik, bağımlılıklar ve değişiklik etkisiyle gerekçelendir. Değişikliğin etkisini gerekli ölçüde gerçek çağıranlar, veri biçimleri, arayüzler, kalıcı kayıtlar ve ilgili testler üzerinden incele; yalnız değişen dosyayı doğru bulmakla yetinme.
- Singleton veya başka bir tasarım desenini her projeye zorunlu tutma. Gereken mimari yaklaşımı kullanıcıyla belirle ve Kararlar'a kaydet.

## Teknik kalite ve aşama bazında anlatım

- Mimariyi önermeden önce mevcut projeyi, teknolojiyi ve gereksinimleri incele; yerleşik yapıya uy. Genel bir klasör sayısı, dosya uzunluğu, katman sayısı veya tasarım kalıbı sınırı dayatma; projeye özel gereksinim ve kullanıcı kararlarını dikkate al.
- Daha kapsamlı bir yapı gerekiyorsa karşıladığı somut ihtiyacı veya riski açıkla. Sadelik uğruna gerekli doğrulama, hata yönetimi, güvenlik, test veya modülerliği kaldırma; gelecekte gerekebilir düşüncesiyle mevcut ihtiyacı karşılamayan karmaşıklık ekleme.
- Önemli bir tasarım kararında birden fazla makul yaklaşım varsa gerçek seçeneklerin yararlarını, bedellerini ve tercih gerekçesini proje ihtiyacıyla açıkla; sabit seçenek sayısı veya kalıp adı gerekçe değildir. Kalıcı kararı yeniden değerlendirmeyi gerektiren somut koşul varsa belirt; her kararda geleceğe dönük senaryo üretme.
- Başlangıçta kısa bir yapı haritası sun. Haritayı README varsa orada, yoksa Plan'ın Proje özeti altında tut ve yapı değişince aynı yeri güncelle. Harita görevleri ve ilişkileri anlatır; kararların asıl kaynağı Kararlar, iş durumunun kaynağı Plan olarak kalır.
- Yalnız seçilen aşamada ilgili dosyaların görevlerini, ilişkilerini ve somut bir girdinin başarıya veya önemli hata sonucuna ulaşma akışını anlaşılır biçimde açıkla. Anlatımı sadeleştirirken teknik doğruluğu ve gerekli ayrıntıyı koru; açıklama kapsamı gerekli araştırma veya analiz derinliğini sınırlamaz.
- Mühendislik anlatımını önemli karar, hata ve aşama kapanışlarına bağla; küçük işte kısa gerekçe yeterlidir. Teknik terimi gerçek akışla ilişkilendir; her komutu uzun derse veya zorunlu sınava dönüştürme. Kullanıcının istediği anlatım ayrıntısını teknik analiz derinliği için sınır sayma.
- Bu çalışma düzeni model, muhakeme ayarı veya araç yapılandırması değiştirme talimatı değildir. Yeni mimari seçimler mevcut kullanıcı onayı düzenine tabidir; yetkili adım içindeki normal dosya ve yardımcı fonksiyon düzenlemeleri yeniden izin gerektirmez.

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
- Kullanıcı karar verdiğinde Kararlar'a ekle; Plan'daki ilgili bekleyen kararı ve Devir özetini düzelt. Anlamlı teknik kararda değerlendirilen seçenekleri, sonuçları ve varsa yeniden değerlendirme koşulunu aynı kayıtta tut; kullanıcının bildirdiği gerekçe ile ajanın teknik değerlendirmesini ayır. Ajanın önerisini kullanıcı kararı gibi yazma.
- Alt adım tamamlandığında Plan durumunu ve Günlük'ü güncelle. Davranış veya komut değiştiyse ilgili teknik anlatımı ve varsa README'yi de güncelle.
- Gerçek bir hata görüldüğünde çözmeye başlamadan önce hata mesajını aktif Günlük'te ve varsa ilgili aşama arşivlerinde ara. Yeni çözüm kaydında "Sorun → çözüm" ile hata mesajını birebir yaz.
- Bir yoldan vazgeçildiyse Günlük'te "Vazgeçilen" kaydı tut. Sorunsuz adımlarda bu başlıkları üretme.
- Yeni sınırı Plan'ın Bilinen sınırlar bölümüne ekle. Uygulanmış, doğrulanmış ve karar bekleyen işleri ayır.
- Oturum sonunda veya araç değişiminden önce eksik Günlük/Kararlar kayıtlarını tamamla ve Devir'i baştan yaz.
- Araç değişiminden sonra yeni sohbet aç; önce mevcut durumu özetle, uygulama kapsamı için kullanıcı yönlendirmesini bekle.
- Plan ve açıklama görüşmesinin kayıtlarını dosya yazımına izin verilen modda güncelle. Araç salt okunur moddaysa kaydı yapılmış sayma; hangi kayıtların dosyaya geçirilmediğini bildir.
- Tarih ve saati kabuktan `Get-Date -Format 'yyyy-MM-dd HH:mm'` ile al. Tahmin etme.
- Günlük ve Kararlar'a ekle; yalnız eski bilgi çelişiyorsa ilgili kısmı düzelt. Devir dışında belgeleri baştan yazma. Yetkili hazırlık veya aşama arşivlemesi, aşağıdaki güvenli aktarım koşullarıyla kapanmış geçmişi aktif dosyadan çıkarmanın istisnasıdır; geçmiş silinmez.

## Hazırlık ve aşama arşivi

- Genel araştırma sonrası yol haritası üzerinde anlaşılmış ve hazırlığın açık işleri ayrılmışsa yalnız kapanmış yerel hazırlık geçmişi `docs/arsiv/00-hazirlik/` altında arşivlenebilir. Genel yol haritasını ve projeyi yöneten kararları hazırlık geçmişi diye kaldırma. Arşive uygun kayıt yoksa boş arşiv üretme.
- Ana aşama, kendi kabul ölçütleri, gerekli alt sonuçlar ve bütünleşme kontrolleri doğrulanınca kapanır. Son alt adım numarası veya dosya büyüklüğü kapanış ölçütü değildir. Yerel geçmiş, aşamanın kararlı kimliği ve kısa adıyla `docs/arsiv/01-asama-adi/` gibi klasörde tutulur; aşama ve alt adım sayıları projeye göre belirlenir.
- Arşivleme seçilen hazırlık veya ana aşama kapanışının belge işidir; taşınacak kapsamı önceden belirt. Kapanış ya da arşiv oluşturmak sonraki aşamayı planlama veya uygulama izni değildir; sonraki çalışma birimi kullanıcı tarafından seçilir.
- Aktif `docs/PLAN.md` sıfırlanmaz veya temiz başlangıç belgesiyle değiştirilmez. Genel yol haritası, kapanmış aşamanın kısa sonucu/durumu ve arşivdeki Plan'a bağlantısı korunur. Yeni seçilen aşamanın ayrıntıları aynı başlıklar ve beş sütunlu alt adım tablosuyla hazırlanır; artık aktif olmayan kapanmış ayrıntı arşive alınır.
- Yürürlükteki proje geneli kararlar, teknik/veri/arayüz sözleşmeleri, doğrulama komutları, açık işler ve çözülmemiş sorunlar aktif belgelerde kalır. Kaydın tarihi veya aşama numarası tek başına taşıma gerekçesi değildir. Karışık kapsamlı ya da etkisi belirsiz kaydı bütünüyle taşıma; geçerli bilgiyi koru, kullanıcı tercihi gerektiren ayrımı sor.
- Arşiv yalnız ilgili kapanmış Plan/Günlük/Kararlar bölümlerini ve gerekiyorsa aşamaya özgü diğer tarihsel belgeleri içerir; güncel teknik belge, kod, veri veya ayar arşiv işi diye taşınmaz. Güncel Devir yeniden yazılır; tarihsel kapanış ve aktarım kaydı Günlük'te tutulur. Ayrıntının asıl kaydı tek yerde olur; aktif belgede kısa özet ve doğru bağlantı yeterlidir. Karışık bir kaydın ayrıştırılması gerekiyorsa kapsamı ve bağlamı korunur; yaşayan kararın asıl kaydı aktif kalır.
- Arşivlenen kayıtta özgün tarih, aşama/alt adım/karar kimliği, gerekçe, kabul ölçütleri, doğrulama sonucu ve hata metni korunur; geçmiş yalnız özete indirgenmez. Mevcut kayıt başlıkları, alanları ve Plan'ın beş sütunlu biçimi arşivde de korunur. Kimlikler sıfırlanmaz veya tekrar kullanılmaz; yeni kimlik verirken aktif ve arşiv kayıtlarını kontrol et. Sonradan eklenen ya da iptal edilen adımın nedeni kaydedilir.
- Önce hedef yolların proje içindeki gerçek `docs/arsiv/` altında kaldığını ve mevcut içerikle çakışmadığını kontrol et. İlgili geçmişin arşiv kopyasını oluştur; seçilen kaynakla kapsam/eksiksizlik/kimlik/içerik karşılaştırması yap. Aktif kaydı çıkarmadan hemen önce kaynağın karşılaştırılan hâlden değişmediğini yeniden doğrula. Bağlantı yolu düzeltmeleri dışında tarihsel içeriği değiştirme; beklenmedik farkta dur ve bildir.
- Taşınan kaydın göreli bağlantılarını yeni konuma göre düzelt; ona gelen aktif veya başka arşiv bağlantılarını da güncelle. Dosya ve başlık bağlantısının aynı hedef kayda ulaştığını kontrol et; yalnız aynı adlı dosyanın bulunmasını yeterli sayma. Arşiv kopyası ve ilgili bağlantılar doğrulanmadan aktif geçmişi çıkarma. Kapanış/aktarım kanıtını kaydet, aktif Plan'ın kısa sonucu ve Devir'i güncelle.
- Kesintide doğrulanmış arşivi ve kalan aktif kayıtları koru; kısmen çıkarılmış kayıtlar varsa aktarımı tamamlanmış sayma. Plan/Devir'de yarım işi ve kalan kontrolü belirt. Yeniden denemede iki taraftaki kayıtları karşılaştır; mevcut arşivin üzerine yazma veya çakışan kaydı kör silme. Geçici tekrar, tamamlanmış kalıcı iki asıl kaynağa dönüşmemeli; güvenli toparlama kapsamı belirsizse kullanıcıya danış.
- Kapanmış aşama yeniden açılırsa yeni çalışma ve gerekçesi aktif Plan/Günlük'te izlenir; önceki kapanış geriye dönük değiştirilmez. Tekrar kapanışında yeni geçmiş mevcut arşivi ezmeden ayrı kayıt veya alt klasörde tutulur; hangi kapanışa ait olduğu ve önceki kayıtla ilişkisi belirtilir. Mevcut iş kimliği korunur, yeni iş için kullanılmamış kimlik verilir.
- Yeni oturumda aktif Plan ve Devir başlangıç noktasıdır. İlgili geçmiş, karar, hata veya aşama yeniden açılması gerektiğinde arşiv bağlantıları izlenir; her oturumda bütün arşivi okumak zorunlu değildir. Arşiv yeni taşıma betiği, bağımlılık, global ayar veya mevcut projeleri güncelleme izni oluşturmaz.
- Kullanılan şablon kopyasında denetimin arşiv kayıtlarıyla uyumu ve izole hazırlık/aşama kapanışı, kesinti/yeniden deneme/yeniden açılma akışları doğrulanmadan gerçek geçmişi taşıma. Kural veya belge kontrolünü fiili aktarım ya da gerçek ajan davranışı kanıtı sayma. Kayıp riski olan tasarım/uygulama mevcut bağımsız inceleme kurallarına tabidir.

## Test ve doğrulama

- Mevcut test ve denetim araçlarını kullan. Yeni araç gerekiyorsa yararını açıklayıp bağımlılık eklemeden önce kullanıcıya sor.
- Davranış değişikliğinde gerekli testleri yaz veya mevcut testleri güncelle. Testi uygulamanın satırlarını kopyalamak yerine beklenen sonuç üzerinden kur.
- Testleri özellik veya modül sorumluluğuna göre düzenle; her plan başlığı için ayrı dosya açma.
- Alt adımda ilgili testleri ve kod denetimlerini çalıştır. Ana aşama kapanırken mevcut testlerin tamamını ve gerekli bütünleşme kontrollerini çalıştır.
- Hata düzeltmesinde geçmiş kayıt ve mevcut kanıtı incele, mümkünse sorunu tekrar üret; olası nedenleri doğrulanmış nedenden ayır ve uygun, izole kontrollerle sınayarak düzelt. Sorun tekrar üretilemiyorsa veya neden doğrulanmadıysa bunu açıkça belirt; uygulama ve doğrulama sınırlarını buna göre değerlendir.
- Hata düzeltmesinde uygun olduğunda hatanın tekrarlanmasını yakalayan test ekle. Önce test yazmayı, sabit teşhis sırasını veya deneme sayısını genel zorunluluk yapma; hatayı bastıran ya da gerekli kontrolü devre dışı bırakan değişikliği çözüm diye sunma.
- Belge veya düşük etkili görsel değişikliğinde uygun içerik, bağlantı ve görünüm kontrolü yap; gereksiz test iskeleti oluşturma.
- Testlerin kullandığı örnek verileri gerçek veriden ayır. Gerçek veri veya canlı sistem değişikliği gerektiren doğrulamayı kullanıcıya komut ve beklenen çıktı ile bırak.
- Komutu, gözlenen sonucu ve sınırlarını Günlük'e kaydet. Başarısız, atlanan (`skipped`) ve çalıştırılamayan kontrolleri ayrı belirt.
- `skipped` sıfır değilse "hepsi geçti" deme. Test sonucunu veya sayısını tahmin etme.
- Önemli kabul ölçütlerini ilgili test veya gözlem kanıtına bağla; kısa açıklama veya mevcut Günlük kaydına bağlantı yeterlidir, yeni kimlik veya form zorunlu değildir. Testler geçse bile karşılanmayan gereksinim varsa adımı doğrulandı diye işaretleme; hangi ölçütün açık kaldığını belirt.
- Gerekli doğrulamalar tamamlanmadan adımı doğrulandı diye işaretleme. Çözülemeyen başarısız kontrolü kullanıcıya bildir; kapsamı kendiliğinden genişletme.
- Testlerin geçmesi canlı ortamın doğrulandığı anlamına gelmez. Denetim betiğinin kayıt alanlarını bulması da testin gerçekten çalıştığını kanıtlamaz.
- Flake8 gibi dile özel araçları genel şablonun bütün projelerine zorunlu kurma. Test komutlarını proje seçildikten sonra Plan'ın Doğrulama düzeni bölümüne kaydet.

## Bağımsız inceleme

- Bağımsız inceleme, kodu veya tasarımı yazan ajandan ayrı, salt okunur bir alt ajanın hata arayan değerlendirmesidir. Çok dosyalı bilgi toplama bu incelemenin yerine geçmez. Alt ajan aynı modeli kullanabilir; ayrı inceleme ortak hataları dışlamaz ve testlerin yerine geçmez.
- Her alt adımın planında inceleme katmanını ve değişikliğin etkisine dayanan kısa gerekçeyi yaz; kod uzunluğunu ölçüt alma. Katmanlar **zorunlu**, **hafif** ve **yok** olur; birden çok ölçüt varsa en yüksek katmanı seç.
- **Zorunlu:** Veri kaybı, güvenlik veya gizli bilginin korunması, gerçek para işlemi, geri alınması zor işlem ya da kritik hesaplama/kararda sessizce yanlış sonuç verme riski vardır. Riskli tasarımı kod yazılmadan önce, oluşan kodu uygulamadan sonra incelet. Tasarım değişmiyorsa mevcut tasarımın ilgili davranışını değerlendirmeye dahil et.
- **Hafif:** Zorunlu risk yoktur; ancak yeni durum veya birden fazla davranış yolu, ortak kullanılan bölümlere etki, Git/işletim sistemi çıktısına dayalı yeni davranış ya da mevcut korumaya eklenen istisna vardır. İlgili tasarım veya kod tamamlandığında tek inceleme yap; önemli bulgu düzeltildiyse etkilenen bölümü yeniden incelet.
- **Yok:** Zorunlu veya hafif ölçüt yoktur; düşük etkili belge, görünüm ya da davranış değiştirmeyen düzenleme gibi işlerde ek alt ajan incelemesi gerekmez. İlgili içerik, görünüm veya test doğrulaması yine yapılır.
- Katmanı her değişikliğin etkisiyle yeniden değerlendir; aynı alanda önce zorunlu inceleme yapılmış olması tek başına yeni değişikliği zorunlu yapmaz. Belirsiz riski plan sırasında bildir; uygulamada risk büyürse katmanı yükselt ve kullanıcıya bildir. Zorunlu incelemede de önemli düzeltmeleri yeniden incelet.
- İnceleyene kapsam, gereksinimler, kabul ölçütleri, ilgili kod/tasarım ve gerekli proje kararlarını ver; yazarın başarı hükmünü veya yönlendirici sonucunu verme. Bulgular kanıt, somut karşı örnek veya uygulanabilir tekrar adımı içermelidir; kanıtsız bulgu doğrudan uygulanmaz.
- Doğrulanan bulguya uygun davranış testi, otomasyon denemesi veya içerik/tasarım kontrolü seç. Yetkili kapsam içindeki hatayı düzelt; kapsamı genişleten, yeni bağımlılık veya kullanıcı kararı gerektiren bulguda danış. Önemli doğrulanan bulgunun nedenini, etkisini ve düzeltmesinin kanıtını kullanıcıya açıkla. Bulguları, doğrulamayı ve sonucu Günlük'e; çözülemeyenleri Plan'ın Bilinen sınırlar bölümüne yaz. Bulgu sayısı başarı ölçütü değildir.
- Araç alt ajanı desteklemiyorsa veya inceleme yapılamadıysa bunu kullanıcıya bildir ve Günlük'te "Çalıştırılamayan" altında kaydet; kendi kontrolünü bağımsız inceleme gibi sunma. Zorunlu inceleme eksikse adımı bütünüyle doğrulandı diye işaretleme.

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
- Çalışma birimi, kullanıcının açıkça seçtiği Plan alt adımıdır; güncel durum Plan'dan okunur. Adım sonunda doğrulama ve kayıtlar tamamlanır; sonraki adım için durulur.
- İlk sürümde yeni paket, hook, global skill veya ayar değişikliği yoktur. Kurucu ağ/Git işlemi yapmayacaktır.
- Belge/SVG değişikliğinde bağlantı, içerik, kodlama ve görsel kontrolü yapılır. Kurucu/denetim davranışı `tests/Kurulum.Tests.ps1` ile izole geçici hedeflerde Windows PowerShell 5.1 üzerinde doğrulanır; gerçek ürün verisi kullanılmaz. Kaynak deponun kendi kayıtları kurulan hedef projenin metadata'sı gibi denetlenmez.
- Git deposunu kullanıcı kurar. Git yoksa durumu bildir; depo, uzak adres veya kimlik ayarlama. Yayın ve VS Code davranış denemeleri yapılmadan uyumluluk doğrulandı deme.
