# Şablon geliştirme planı

## Proje özeti

- Amaç: Codex ve Claude için proje içinde kalan, sürümü sabit ortak çalışma düzeni hazırlamak.
- Hedef sürüm: `v0.1.0`; henüz yayımlanmadı.
- Güncel çalışma birimi: **1.3 — elle denetim ve bağımlılıksız kurulum testleri, tamamlandı ve doğrulandı**.
- Uygulama izni: Kullanıcı “1.3 e geçelim” diyerek yalnız 1.3'ü açıkça istedi.
- Son güncelleme: 2026-10-02 11:39; kayıt zamanı kabuktan alındı.
- Git durumu: Dal `main`, gözlenen baz commit `1e2fdfc`; 1.2 commit/push edildi. Kullanıcı 1.3 commit/push işlemini açıkça onayladı; sonuç henüz bu kayıt hazırlanırken gözlenmedi.

## Genel yol haritası

| Aşama | Amaç | Durum |
|---|---|---|
| 1 | İlk sürümün belgeleri, yerel kurulumu, elle denetimi ve iki araçta davranış denemesi | 1.1–1.3 doğrulandı; 1.4 planlandı |

## Seçilen aşamanın ayrıntıları

| Alt adım | Beklenen davranış ve kapsam | Kabul ölçütü | Doğrulama | Durum |
|---|---|---|---|---|
| **1.1** | Ortak kurallar, bu deponun kayıtları, temiz başlangıç belgeleri, README ve iki SVG | Tek adım izni açık; belge rolleri ayrı; anlatım mevcut ve gelecek özellikleri ayırıyor | Bağlantı, içerik tutarlılığı, UTF-8 ve görsel okunabilirlik | Doğrulandı |
| **1.2** | Yerel `kur.ps1` ve `surum.json` | Ön kontrol; çakışmada yazmama; kaynak içine kurmama; sabit sürüm ve kaynak özetleri; kopyalama hatası bildirimi | Windows PowerShell 5.1'de 41 kabul kontrolü; başarısız 0, atlanan 0 | Doğrulandı |
| **1.3** | Elle kontrol betiği ve ek bağımlılık gerektirmeyen kurulum testleri | Dosya, bağlantı, sürüm kaydı ve eksik kayıt kontrolü; kanıt sınırları açık | Windows PowerShell 5.1'de 60/60 başarılı; başarısız 0, atlanan 0; üç betikte BOM/ayrıştırma başarılı | Doğrulandı |
| **1.4** | Codex ve Claude VS Code davranış denemeleri | Yalnız planlama, tek adımda durma, kayıt güncelleme ve araç değişimi gözlenmiş | Her araçta gerçek oturum ve kayıt karşılaştırması | Planlandı; uygulama izni bekliyor |

Genel planın kabulü veya bu tablodaki sonraki adım, uygulama izni değildir. Yetkili alt adım tamamlanınca doğrulama ve kayıtlar bitirilir; sonraki adım için durulur.

### 1.3 kapsamı ve kabul ölçütleri

- `sablon/.ai-sablon/kontrol.ps1` kurulan hedef projeyi yalnız okur; dosya/Git/ağ/ayar işlemi yapmaz. Kaynak depo için ürün doğrulaması gibi çalıştırılmaz.
- Sekiz zorunlu dosya, varsa README, basit yerel Markdown bağlantıları, CLAUDE içe aktarımı, kodlama ve kurulum kaydının alanları denetlenir. Proje dışındaki yerel bağlantılara erişilmez; dış URL ve başlık parçaları ağ üzerinden denetlenmez.
- Metadata kaynak/çıktı listeleri, SHA-256 biçimleri ve altı kopya eşlemesinin tarihsel özet tutarlılığı kontrol edilir. Proje belgelerinin sonradan değişmesi kurulum hatası değildir; kurulum kaydı bir fotoğraftır.
- Plan'ın gerçek alt adım satırları, tarihli Günlük kayıtları, numaralı kararlar ve güncel Devir alanı incelenir. Boş başlangıç ve kod bloklarındaki örnekler gerçek kayıt sayılmaz; planlanan adım için tamamlanmış iş kaydı istenmez.
- Eksik çalışma alanı/eşleşmeyen adım uyarı, eksik zorunlu dosya/bozuk metadata/bozuk yerel bağlantı hata olarak bildirilir. Çıkış 0: hata/uyarı yok; 1: hata; 2: uyarı. Geliştirme ve bekleyen 1.4 denemeleri açık uyarıdır.
- `tests/Kurulum.Tests.ps1` mevcut Windows PowerShell 5.1 ve .NET ile izole geçici örnekleri çalıştırır. Pester, Node.js veya yeni paket gerektirmez. Başarılı/başarısız/atlanan sayıları ayrı; başarısız veya atlanan sonuç çıkış koduna yansır.
- Gerçek kontrol betiği kaynak listesine eklenir; hedef dosya sayısı 8 olur. Yalnız `editor-behavior-validation` bekler; `development` korunur. Eski projeler ve global dosyalar değiştirilmez.
- Denetim kullanıcı onayını, testlerin gerçekten çalışmasını, kodun doğruluğunu veya iki araçta gerçek uyumluluğu kanıtlamaz. 1.4'e kendiliğinden geçilmez.

### 1.2 kapsamı ve kabul ölçütleri

Bu bölüm 1.2'de doğrulanan kapsamı kaydeder. Güncel pakete 1.3'te gerçek kontrol betiği eklenir; 1.2'nin tarihsel 7 dosyalı sonucu yeni dosya sayısıyla değiştirilmez.

- `kur.ps1 -TargetDirectory` yalnız yerel paket dosyalarını kullanır; Git, ağ, global skill/ayar veya gerçek proje verisi üzerinde işlem yapmaz.
- Kaynak ve hedef yollar normalize edilir; kaynakla iç içe hedef, global araç dizini ve yönlendirilmiş dosya/klasörler reddedilir.
- Sürüm bilgisi, bütün kaynaklar, bütün hedef dosyalar ve klasör üstleri ilk yazmadan önce kontrol edilir. Bir çıktı mevcutsa hiçbir dosyaya yazılmaz; ilgisiz proje dosyaları korunur.
- Hedefte AGENTS yalnız ortak kural kaynağından, CLAUDE adımsız kısa içe aktarımdan, dört kayıt yalnız `sablon/docs/` içeriğinden oluşur. Şablon geliştirme geçmişi taşınmaz.
- Kurulum kaydı `.ai-sablon/kurulum.json` içindedir: sürüm, paket durumu, zaman, kaynak ve kurulan dosya özetleri. Kayıt kendi özetini içermez.
- Bu geliştirme paketinin kapsamı ortak talimatlar ve dört kayıt belgesidir. Elle kontrol ve VS Code davranış denemesi bekleyen bileşenler olarak belirtilir; yok olan kontrol betiği kurulmuş gösterilmez.
- Kopyalama/yazma hatası başarı sayılmaz; oluşan dosyalar ve klasörler bildirilir. Otomatik silme veya üzerine yazma yoktur.
- İzole geçici hedeflerde ana kabul senaryoları ve uygun ek sınır senaryoları Windows PowerShell 5.1 ile çalıştırılır. Kalıcı test betiği 1.3 kapsamında kalır.

### 1.1 kapsamı ve kabul ölçütleri

- Ortak kuralların düzenlenecek kaynağı `genel/KURALLAR.md` olur. Bu deponun `AGENTS.md` girişi ortak bölümden türetilir; proje bölümü ayrıdır.
- `CLAUDE.md`, `@AGENTS.md` içe aktarımını kullanır. Ortak kayıtların ayrıca okunması talimatlarda belirtilir.
- `docs/` bu şablonun gerçek geçmişidir. `sablon/docs/` yeni proje için boş başlangıçtır; geliştirme geçmişini içermez.
- Plan; amaç, aşamalar, seçilen alt adımlar, kabul ölçütleri, doğrulama ve sınırları içerir. Diğer üç kayıt kendi rollerini taşır.
- Genel/aşama planı onayı kod izni sayılmaz. Yetkili alt adımın kodu, kontrolleri, düzeltmeleri ve kayıtları tamamlanır; ajan durur.
- README Türkçedir; iki SVG ile kurulum hedefini ve adım akışını açıklar. Kitap takip örneği yalnız anlatımdır.
- Testler özelliklere göre düzenlenir. Yeni test aracı kurmak kullanıcı kararıdır; belge değişikliği için gereksiz test dosyası üretilmez.
- Henüz hazır olmayan betiklere çalışan komut veya mevcut dosya bağlantısı gibi davranılmaz.
- Global skill, eklenti, ayar, eski proje veya Git yapılandırmasına yazılmaz. Yeni paket kurulmaz.

## Doğrulama düzeni

- **1.1:** Yerel belge bağlantıları, Claude içe aktarımı, ortak kural kaynağı eşleşmesi, temiz başlangıç içeriği, UTF-8 BOM'suz Markdown, geçerli SVG ve görüntülenmiş görseller.
- **1.2:** İzole geçici hedeflerde kurucu davranışları; gerçek projeye kurulum yapılmaz. Mevcut Node.js ile repo dışında hazırlanmış geçici yardımcı, Windows PowerShell 5.1'i çağırarak 41 kabul senaryosunu çalıştırdı. Kalıcı ürün test betiği 1.3'tedir.
- **1.3:** `powershell.exe -NoProfile -File .\tests\Kurulum.Tests.ps1`; Windows betikleri engelliyorsa yalnız işlem için `-ExecutionPolicy Bypass`. İzole test örnekleri Windows geçici klasöründe; test yordamı repo içinde. Pester, Node.js veya başka paket ürün testinin bağımlılığı değildir. Manuel kayıt denetimi hedef projedeki `.ai-sablon/kontrol.ps1` ile yapılır.
- **1.4:** Gerçek VS Code denemeleri. Diskte eklenti bulunması davranış doğrulaması sayılmaz.
- Ana aşama kapanışında mevcut kontrollerin tamamı ve gerekli bütünleşme kontrolleri yeniden çalıştırılır.
- Başarısız, atlanan ve çalıştırılamayan kontroller ayrı kaydedilir. Sonuçların asıl kaydı [Günlük](GUNLUK.md) dosyasındadır.

## Bekleyen kararlar

- 1.3 commit ve push onayı alındı; aşağıdaki gerçek sonuç kaydı işlemlerden sonra güncellenecek.
- Kullanıcı 1.4 uygulamasını açıkça istedi; 1.3 gönderildikten sonra son adımın kapsamı ve kabul kontrolleri ele alınacak.
- Yeni bağımlılık veya otomatik güncelleme ekleme kararı yoktur.

Kullanıcının verdiği kararlar [Kararlar](KARARLAR.md) dosyasındadır.

## Bilinen sınırlar

- Güncel geliştirme paketi kontrol betiğiyle 8 dosya kurar. Elle denetim ve kalıcı kabul testleri 1.3'te doğrulandı; `pendingFeatures` yalnız gerçek araç davranış denemelerini bekletir. Bu paket temiz kurulumda bile denetim çıkışı 2 verir: geliştirme ve bekleyen araç denemesi uyarıları.
- Elle denetim standart belge başlıkları, alan adları ve alt adım tablosunu tanır; serbest biçimli metnin anlamını veya tüm Markdown özelliklerini çözümleyen bir araç değildir.
- Kısmi yazma hatası, geçici paket kopyasında kontrollü hata üretilerek doğrulandı; fiziksel disk doluluğu veya gerçek proje erişim hatası yaşandığı iddia edilmiyor.
- GitHub'da yayın veya etiket yoktur; `v0.1.0` hedef sürümdür.
- Codex ve Claude VS Code davranışı henüz denenmedi. Talimat dosyası teknik bir izin kilidi veya kusursuz hatırlama garantisi değildir.
- Proje içine kopyalama global ayarları değiştirmez; mevcut global/üst klasör talimatlarının etkisini kendiliğinden ortadan kaldırmaz.
- Sabit şablon sürümü model, eklenti veya çalışma ortamını sabitlemez.
- Elle denetim, dosyadaki kaydı kontrol eder; kullanıcının gerçekten izin verdiğini veya testlerin çalıştırıldığını kanıtlamaz.
- Salt okunur planlama modunda dosya kaydı yazılamayabilir. Kaydedilmeyen bilgi açıkça bildirilir.
- Başlıklar iş sırasını düzenler; dosya bütünlüğü ve Singleton uygunluğu ancak proje mimarisi, etki incelemesi ve uygun testlerle değerlendirilir.
- Yerel SVG önizleme aracı yazı tipi önbelleğine yazamadığına ilişkin uyarı verdi. PNG'ler üretildi ve okunabilirlikleri görüntülenerek kontrol edildi; önbellek uyarısı giderilmiş sayılmadı. Ayrıntı Günlük'tedir.
- Eski `Emir-Ars/ai-sablon` kurulumunun iki global talimat dosyası ve sekiz özel skill klasörü kullanıcı isteğiyle geri alınabilir yedeğe taşındı; Claude ayarlarındaki ek `attribution` alanı kaldırıldı, diğer alanlar korundu. Bu ayrı kaldırma işi yeni şablonun kurulum özelliği değildir. İlk kurulumdaki bütün global içeriklerin bilindiği iddia edilmiyor.

## İlgili kayıtlar

- [Kararlar](KARARLAR.md)
- [Günlük](GUNLUK.md)
- [Devir](DEVIR.md)
- [Kullanım anlatımı](../README.md)
