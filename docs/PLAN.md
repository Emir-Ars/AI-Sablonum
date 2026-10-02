# Şablon geliştirme planı

## Proje özeti

- Amaç: Codex ve Claude için proje içinde kalan, sürümü sabit ortak çalışma düzeni hazırlamak.
- Hedef sürüm: `v0.1.0`; henüz yayımlanmadı.
- Güncel çalışma birimi: **1.2 — yerel kurucu ve sürüm kaydı, tamamlandı ve doğrulandı**.
- Uygulama izni: Kullanıcı “1.2 ye başlayalım” diyerek yalnız 1.2'yi açıkça istedi.
- Son güncelleme: 2026-10-02 10:29; kayıt zamanı kabuktan alındı.
- Git durumu: Dal `main`, gözlenen baz commit `1dde9d6`; 1.1 önceki oturumda kullanıcının onayıyla commit ve push edildi. 1.2'nin 9 dosyası için commit onayı var, push onayı yok. Bu kapanış kaydı commit öncesi hazırlanmıştır; gerçek sonuç Git geçmişinden okunur.

## Genel yol haritası

| Aşama | Amaç | Durum |
|---|---|---|
| 1 | İlk sürümün belgeleri, yerel kurulumu, elle denetimi ve iki araçta davranış denemesi | 1.1–1.2 doğrulandı; 1.3–1.4 planlandı |

## Seçilen aşamanın ayrıntıları

| Alt adım | Beklenen davranış ve kapsam | Kabul ölçütü | Doğrulama | Durum |
|---|---|---|---|---|
| **1.1** | Ortak kurallar, bu deponun kayıtları, temiz başlangıç belgeleri, README ve iki SVG | Tek adım izni açık; belge rolleri ayrı; anlatım mevcut ve gelecek özellikleri ayırıyor | Bağlantı, içerik tutarlılığı, UTF-8 ve görsel okunabilirlik | Doğrulandı |
| **1.2** | Yerel `kur.ps1` ve `surum.json` | Ön kontrol; çakışmada yazmama; kaynak içine kurmama; sabit sürüm ve kaynak özetleri; kopyalama hatası bildirimi | Windows PowerShell 5.1'de 41 kabul kontrolü; başarısız 0, atlanan 0 | Doğrulandı |
| **1.3** | Elle kontrol betiği ve ek bağımlılık gerektirmeyen kurulum testleri | Dosya, bağlantı, sürüm kaydı ve eksik kayıt kontrolü; kanıt sınırları açık | Eksik kayıt, bozuk sürüm kaydı, Windows PowerShell 5.1, `.ps1` BOM | Planlandı; uygulama izni bekliyor |
| **1.4** | Codex ve Claude VS Code davranış denemeleri | Yalnız planlama, tek adımda durma, kayıt güncelleme ve araç değişimi gözlenmiş | Her araçta gerçek oturum ve kayıt karşılaştırması | Planlandı; uygulama izni bekliyor |

Genel planın kabulü veya bu tablodaki sonraki adım, uygulama izni değildir. Yetkili alt adım tamamlanınca doğrulama ve kayıtlar bitirilir; sonraki adım için durulur.

### 1.2 kapsamı ve kabul ölçütleri

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
- **1.3:** Mevcut Windows PowerShell 5.1 ile bağımlılıksız test betiği ve elle denetim. Pester veya başka paket bu plana dahil değildir.
- **1.4:** Gerçek VS Code denemeleri. Diskte eklenti bulunması davranış doğrulaması sayılmaz.
- Ana aşama kapanışında mevcut kontrollerin tamamı ve gerekli bütünleşme kontrolleri yeniden çalıştırılır.
- Başarısız, atlanan ve çalıştırılamayan kontroller ayrı kaydedilir. Sonuçların asıl kaydı [Günlük](GUNLUK.md) dosyasındadır.

## Bekleyen kararlar

- 1.2'nin yerel commiti kullanıcı tarafından onaylandı; push için ayrı onay beklenir. Çalışan zamanlanmış görevlerin tanımlı eylemlerinde bu depoya açık referans görülmedi; görevlere müdahale edilmedi.
- 1.3'ün uygulaması için açık kullanıcı yönlendirmesi beklenir; bu adıma başlanmadı.
- Elle denetimin ayrıntıları 1.3'te kendi kapsamlarında belirlenir. Yeni bağımlılık veya otomatik güncelleme ekleme kararı yoktur.

Kullanıcının verdiği kararlar [Kararlar](KARARLAR.md) dosyasındadır.

## Bilinen sınırlar

- Yerel kurucu ve sürüm kaydı hazırdır. Mevcut geliştirme paketi hedefe 7 dosya kurar; kontrol betiği ve kalıcı kurulum test betiği 1.3 kapsamında henüz yoktur. `pendingFeatures` elle denetim ve araç davranış denemelerinin beklediğini gösterir.
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
