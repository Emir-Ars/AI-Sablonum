# Şablon geliştirme planı

## Proje özeti

- Amaç: Codex ve Claude için proje içinde kalan, sürümü sabit ortak çalışma düzeni hazırlamak.
- Hedef sürüm: `v0.1.0`; henüz yayımlanmadı.
- Güncel çalışma birimi: **1.1 — doğrulandı; sonraki adım için kullanıcı yönlendirmesi bekleniyor**.
- Uygulama izni: Kullanıcı bu planı uygulamayı istedi; planın belirlediği ilk çalışma birimi yalnız 1.1'dir.
- Son güncelleme: 2026-10-02 00:30; kayıt zamanı kabuktan alındı.
- Git durumu: Kullanıcı `Emir-Ars/AI-Sablonum` GitHub deposunu ve bu klasördeki yerel depoyu oluşturdu. Dal `main`, doğru `origin` ve Git kimliği kontrol edildi. 1.1 commit onayı var; push onayı yok.

## Genel yol haritası

| Aşama | Amaç | Durum |
|---|---|---|
| 1 | İlk sürümün belgeleri, yerel kurulumu, elle denetimi ve iki araçta davranış denemesi | 1.1 doğrulandı; 1.2–1.4 planlandı |

## Seçilen aşamanın ayrıntıları

| Alt adım | Beklenen davranış ve kapsam | Kabul ölçütü | Doğrulama | Durum |
|---|---|---|---|---|
| **1.1** | Ortak kurallar, bu deponun kayıtları, temiz başlangıç belgeleri, README ve iki SVG | Tek adım izni açık; belge rolleri ayrı; anlatım mevcut ve gelecek özellikleri ayırıyor | Bağlantı, içerik tutarlılığı, UTF-8 ve görsel okunabilirlik | Doğrulandı |
| **1.2** | Yerel `kur.ps1` ve `surum.json` | Ön kontrol; çakışmada yazmama; kaynak içine kurmama; sabit sürüm ve kaynak özetleri; kopyalama hatası bildirimi | Boş hedef, çakışma, ikinci kurulum, Türkçe/boşluklu yollar, kısmi hata | Planlandı; uygulama izni bekliyor |
| **1.3** | Elle kontrol betiği ve ek bağımlılık gerektirmeyen kurulum testleri | Dosya, bağlantı, sürüm kaydı ve eksik kayıt kontrolü; kanıt sınırları açık | Eksik kayıt, bozuk sürüm kaydı, Windows PowerShell 5.1, `.ps1` BOM | Planlandı; uygulama izni bekliyor |
| **1.4** | Codex ve Claude VS Code davranış denemeleri | Yalnız planlama, tek adımda durma, kayıt güncelleme ve araç değişimi gözlenmiş | Her araçta gerçek oturum ve kayıt karşılaştırması | Planlandı; uygulama izni bekliyor |

Genel planın kabulü veya bu tablodaki sonraki adım, uygulama izni değildir. 1.1 tamamlanınca doğrulama ve kayıtlar bitirilir; sonraki adım için durulur.

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
- **1.2:** İzole geçici hedeflerde kurucu davranışları; gerçek projeye kurulum yapılmaz.
- **1.3:** Mevcut Windows PowerShell 5.1 ile bağımlılıksız test betiği ve elle denetim. Pester veya başka paket bu plana dahil değildir.
- **1.4:** Gerçek VS Code denemeleri. Diskte eklenti bulunması davranış doğrulaması sayılmaz.
- Ana aşama kapanışında mevcut kontrollerin tamamı ve gerekli bütünleşme kontrolleri yeniden çalıştırılır.
- Başarısız, atlanan ve çalıştırılamayan kontroller ayrı kaydedilir. Sonuçların asıl kaydı [Günlük](GUNLUK.md) dosyasındadır.

## Bekleyen kararlar

- 1.1 bittiğinde, 1.2 uygulaması için kullanıcı yönlendirmesi beklenir.
- Kullanıcı 1.1 commitini açıkça onayladı. GitHub deposu, yerel depo, uzak adres ve kimlik hazır. Bu plan kapanış kaydı commit öncesi hazırlanmıştır; commit sonucu Git geçmişinden okunur. Push onayı verilmedi.
- Kurulum kayıt dosyasının alanları 1.2'de, elle denetimin ayrıntıları 1.3'te kendi kapsamlarında belirlenir.

Kullanıcının verdiği kararlar [Kararlar](KARARLAR.md) dosyasındadır.

## Bilinen sınırlar

- Kurucu, sürüm kaydı, kontrol betiği ve kurulum test betiği 1.1 kapsamında yoktur. Hedef projeye kurulum henüz yapılamaz.
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
