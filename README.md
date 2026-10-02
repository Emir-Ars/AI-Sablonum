# 🧩 Codex–Claude proje şablonu

**Amaç:** Her yeni projede aynı çalışma düzenini kullanmak; planı birlikte hazırlamak, tek alt adımı uygulamak ve Codex ile Claude arasında repo kayıtlarıyla devam etmek.

> 🚧 **Hedef sürüm: v0.1.0 — geliştirme paketi.** **1.1–1.3 tamamlandı; 4 adımın 3'ü doğrulandı.** Yerel kurucu, elle denetim ve bağımlılıksız test betiği hazırdır; gerçek VS Code davranış denemeleri 1.4'tedir. Tamamlanmış `v0.1.0` sürüm etiketi/yayını henüz yoktur.

## 🧭 Çalışma düzeni

Genel yol haritası projenin yönünü gösterir. Ardından yalnız seçtiğin ana aşama alt adımlara ayrılır. Bir alt adım için açık uygulama yönlendirmesi verdiğinde ajan gerekli kodu, ilgili kontrolleri, hata düzeltmelerini ve kayıt güncellemelerini tamamlar; özet ve commit önerisinden sonra durur.

**Planı kabul etmek, kod yazma izni değildir.** Örneğin “Plan uygun” dediğinde ajan bütün planı uygulamaya başlamaz. “Yalnız 1.1'i uygula” dediğinde o adımın birden fazla dosyayı kapsayan gerekli işlerini bitirebilir; 1.2'ye geçmez.

![Genel plan, seçilen aşama ve tek adım çalışma akışı](gorseller/is-akisi.svg)

Ajanın problem çözme yeteneğine sınır konmaz; uygulama kapsamı senin seçtiğin adımla sınırlanır. Bu, metinle tanımlanan bir çalışma kuralıdır. Talimatlara uyulması gerçek araç denemeleriyle kontrol edilecektir; teknik bir yetki kilidi veya kusursuz hatırlama garantisi değildir.

## 📦 Proje içine kurulum

![Sabit şablon sürümünden proje içine yerel kurulum hedefi](gorseller/kurulum.svg)

Akış: GitHub'dan seçilen paketi indir → yerel kaynak paketinden hedef klasöre kur → o projede aynı dosya kopyasını kullan. Yayımlanmış sürüm etiketi hazır olduğunda onu seçebilirsin. Şu anki paket geliştirme durumundadır; şablonun tamamı bitmiş değildir. Her proje kendi kopyasını taşır. Global skill, eklenti veya kurulum dosyası değişmez; eski projeler kendiliğinden güncellenmez.

Komutu, indirdiğin şablon paketinin kökünde Windows PowerShell 5.1 ile çalıştır. `TargetDirectory` kurulacak proje klasörüdür; yeni veya mevcut olabilir. Göreli yol verirsen PowerShell'de bulunduğun klasöre göre çözülür:

```powershell
powershell.exe -NoProfile -File .\kur.ps1 -TargetDirectory "C:\Projeler\KitapTakip"
```

Windows “running scripts is disabled on this system” hatası verirse aynı komutu yalnız o işlem için çalıştırma izniyle kullanabilirsin; global çalıştırma politikası değişmez:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\kur.ps1 -TargetDirectory "C:\Projeler\KitapTakip"
```

Kurucu yerel dosyaları kullanır; Git veya ağ işlemi yapmaz. Bütün kaynaklar, hedef dosyalar ve klasör üstleri yazmadan önce kontrol edilir. Kurulacak dosyalardan biri zaten varsa hiçbir dosyaya dokunmadan durur. İlgisiz proje dosyaları korunur. Kaynak paketle iç içe klasörler, global araç/eklenti/profil dizinleri ve bağlantılı/yönlendirilmiş yollar kabul edilmez. Yeni hedef oluşturulabilir; otomatik üzerine yazma veya güncelleme yapılmaz.

Bu geliştirme paketinde **8 dosya** kurulur:

```text
KitapTakip/
├── AGENTS.md
├── CLAUDE.md
├── docs/
│   ├── PLAN.md
│   ├── KARARLAR.md
│   ├── GUNLUK.md
│   └── DEVIR.md
└── .ai-sablon/
    ├── kontrol.ps1
    └── kurulum.json
```

`AGENTS.md` yalnız ortak kurallardan, `CLAUDE.md` adımsız kısa içe aktarımdan oluşur. Dört kayıt boş başlangıç içerikleriyle gelir. Kaynak deponun README'si, geliştirme kayıtları veya bu projeye özel kuralları kopyalanmaz.

Kurulum kaydı `.ai-sablon/kurulum.json` sürümü, paket durumunu, saat dilimi içeren tarihi, kaynakların ve kurulan dosyaların SHA-256 özetlerini taşır. Özet, dosyanın o kopyasını tanımaya yarar; kullanıcı onayını veya kodun doğruluğunu kanıtlamaz. Kayıt kendi özetini içermez. Kontrol betiği kuruluma dahildir; `pendingFeatures` alanında yalnız VS Code davranış denemeleri bekler.

Bu özetler kurulum anını kaydeder. Ajanın AGENTS ve proje belgelerini sonradan güncellemesi normaldir; bu fark denetimde bilgi olarak gösterilir. Denetim, kopyalanan kaynak/çıktı özetlerinin kayıt içindeki eşleşmesini de kontrol eder. Kaynak dosyaların hedef projede bulunmasını veya merkezi kaynağın güncel hâline erişilmesini istemez.

Yazma/kopyalama sırasında hata olursa işlem başarısız biter; oluşan dosya ve klasörler listelenir. Otomatik silme yapılmaz. Tamamlanmamış hedefte yeniden çalıştırma çakışma nedeniyle durur; rapordaki dosyalar incelenmeden üzerine yazılmaz.

İlk sürümün tamamlanması ve araç uyumluluğunun değerlendirilmesi 1.4'ten sonra mümkündür. GitHub'ın “Use this template” özelliği depoyu bütünüyle kopyaladığı için burada hedefe yerel kurulumun yerini tutmaz.

Proje içinde kopya kullanmak, mevcut global veya üst klasör talimatlarını otomatik olarak etkisizleştirmez. Sabitlenen şey şablon dosyalarıdır; model ve eklenti sürümleri ayrıca değişebilir.

## 🗂️ Hangi dosya ne işe yarar?

| Dosya veya klasör | Görev | Durum |
|---|---|---|
| [genel/KURALLAR.md](genel/KURALLAR.md) | Ortak kuralların düzenlenecek kaynağı | Mevcut |
| [AGENTS.md](AGENTS.md) | Codex için proje girişi; ortak kuralların kopyası ve bu depoya özel bölüm | Mevcut |
| [CLAUDE.md](CLAUDE.md) | `@AGENTS.md` ile aynı talimatları Claude'a aktaran kısa giriş | Mevcut |
| [docs/PLAN.md](docs/PLAN.md) | Bu şablonun geliştirme planı ve durumları | Mevcut |
| [docs/KARARLAR.md](docs/KARARLAR.md) | Bu şablon için kullanıcının kararları | Mevcut |
| [docs/GUNLUK.md](docs/GUNLUK.md) | Bu şablonda yapılan iş ve kontrol sonuçları | Mevcut |
| [docs/DEVIR.md](docs/DEVIR.md) | Bu şablonda kaldığımız yerin güncel özeti | Mevcut |
| [sablon/docs/PLAN.md](sablon/docs/PLAN.md) ve diğer üç kayıt | Yeni projeye aktarılacak boş başlangıç belgeleri | Mevcut |
| [gorseller/kurulum.svg](gorseller/kurulum.svg), [is-akisi.svg](gorseller/is-akisi.svg) | Kurulum hedefi ve çalışma akışı | Mevcut |
| [kur.ps1](kur.ps1), [surum.json](surum.json) | Yerel kurucu ve kaynak sürüm/kapsam bilgisi | Mevcut; geliştirme paketi |
| [sablon/.ai-sablon/kontrol.ps1](sablon/.ai-sablon/kontrol.ps1) | Kurulan hedef projenin salt okunur kayıt denetimi | Mevcut |
| [tests/Kurulum.Tests.ps1](tests/Kurulum.Tests.ps1) | Ek paket gerektirmeyen kurulum ve denetim kabul testleri | Mevcut; kaynak depoda çalışır |

`docs/` ve `sablon/docs/` aynı geçmişin iki kopyası değildir: ilki bu şablonun gerçek çalışmasını, ikincisi kurulacak yeni projenin boş başlangıcını taşır. Kurulumdan sonra hedef projede belgeler `docs/` altında bulunur.

Ortak bir kural değişecekse önce `genel/KURALLAR.md` düzenlenir. Bu deponun `AGENTS.md` ortak bölümü de kaynağa uydurulur; proje bölümü korunur. Yeni sürüm eski projelere kendiliğinden yayılmaz. Yalnız projeye özel teknoloji, mimari veya komut kararı ise ilgili projenin `AGENTS.md` proje bölümüne yazılır.

## 🧠 Dört belgeyle ortak hafıza

| Belge | Yanıtladığı soru | Güncellenme zamanı |
|---|---|---|
| **Plan** | Neyi hedefliyoruz; hangi aşama ve adımdayız; kabul ölçütü ne? | Plan netleştiğinde, durum değiştiğinde veya yeni sınır görüldüğünde |
| **Kararlar** | Kullanıcı ne seçti, neden seçti? | Kullanıcı karar verdiğinde |
| **Günlük** | Ne yapıldı, hangi kontrol çalıştı, sonucu ne oldu? | Alt adım tamamlandığında; gerçek sorun ve çözümü görüldüğünde |
| **Devir** | Şu an nerede kaldık, ne yarım, ne bekliyor? | Oturum sonunda ve araç değişiminden önce baştan yazılır |

Bu kayıtları aynı oturumda ajan günceller; ayrıca “günlüğü yaz” demen çalışma kuralı gereği gerekli değildir. Senin görevin ihtiyaçlarını, kararlarını ve uygulanacak alt adımı belirtmektir. Yeni bağımlılık, mimari seçim, gizli ayar veya kapsam değişikliği gibi kontrol noktalarında ajan senden yönlendirme ister.

Dosyaların varlığı, içeriklerinin her oturumda otomatik okunduğunu kanıtlamaz. Yeni oturumda ajan Plan ve Devir'i, ilgili kararları ve Git durumunu okur; tutarsızlıkları bildirir. Salt okunur planlama modunda kayıt yazılamıyorsa bunu bildirir; yazılmış gibi davranmaz.

Proje durumu, karar ve devir bilgisi yalnız repo belgelerine yazılır; aracın özel hafızasına proje durumu kaydedilmez. Sohbet geçmişleri otomatik birleştirilmez. Ortak devam noktası dosyalardır. Devir'de yazan “sonraki adım”, o adımı uygulama izni değildir.

## 📚 Örnek: Kitap takip uygulamasına başlamak

Bu örnek yalnız mesaj akışını anlatır; burada örnek uygulama veya proje klasörü oluşturulmadı.

**1 — İhtiyaç ve genel yol haritası**

> “Kitap eklemek, okuma durumunu değiştirmek ve kitaplarımı listelemek istiyorum. İhtiyaçlarımı netleştir ve yalnız genel yol haritasını hazırla.”

Ajan hedefleri ve belirsiz kararları sorar. Örneğin “1. Kitap kayıtları, 2. Okuma durumları, 3. Arama ve filtreleme” yol haritasını önerebilir. Teknoloji seçimini varsaymaz. Dosya yazmaya izin verilen modda planı kaydeder; ürün kodu yazmaz.

**2 — Seçilen ana aşamanın ayrıntıları**

> “Birinci aşamayı alt adımlara ayır; uygulama yapma.”

Örnek ayrıntılar: **1.1** kitap bilgilerinin ve doğrulama kurallarının tanımı, **1.2** kitap ekleme, **1.3** listeleme. Her alt adımın beklenen davranışı, kabul ölçütü ve doğrulaması yazılır. Diğer ana aşamaların ayrıntıları o aşamalar seçildiğinde hazırlanır.

**3 — Tek alt adımın uygulaması**

> “Yalnız 1.1'i uygula; doğrulamayı ve kayıtları tamamlayınca dur.”

Örneğin 1.1'in kabul ölçütü “boş kitap adı reddedilir; geçerli ad kabul edilir” olabilir. Ajan yetkili kapsamda gerekli dosyaları ve uygun testleri hazırlar, kontrolleri çalıştırır, sonucu kaydeder ve durur. 1.2'deki ekleme arayüzünü kendiliğinden yapmaz.

**4 — Araç değiştirmeden önce**

> “Kayıtları güncelle ve devir hazırla.”

Ajan eksik kayıtları tamamlar ve Devir'i güncel durumla yeniden yazar. Bu istek commit, push veya sonraki adımı uygulama izni değildir.

**5 — Yeni araçta yeni sohbet**

> “Kayıtları ve Git durumunu oku, kaldığımız yeri özetle; uygulamaya başlamadan dur.”

Codex'ten Claude'a veya ters yönde geçtiğinde aynı proje klasörünü açarsın. Önceki aracı durdurursun; iki araç aynı dosyalarda eş zamanlı çalışmaz. Yeni ajan, örneğin “1.1 doğrulandı; 1.2 için yönlendirme bekleniyor” diye durumu özetler. Sen ardından “Yalnız 1.2'yi uygula” diyebilirsin.

Bu mesajlar doğal dildir; yeni bir slash komutu veya global skill kurulmasına ihtiyaç duymaz.

## 🧪 Testler nasıl seçilecek?

Her ayrıntılı adım başlamadan doğrulama yöntemi belirlenir. Davranış değişikliğinde gerekli test yazılır veya mevcut test güncellenir. Alt adım sonunda ilgili testler, ana aşama kapanırken mevcut testlerin tamamı ve gerekli bütünleşme kontrolleri çalıştırılır. Hata düzeltmesinde uygun olduğunda aynı hatayı yeniden yakalayan test eklenir.

Kitap takip örneğinde, seçilmiş teknolojiye bağlı olarak şu katmanlar kullanılabilir:

| Katman | Örnek kontrol | Ne gösterir? |
|---|---|---|
| Birim testi | Boş kitap adının reddedilmesi | Küçük bir iş kuralının beklenen davranışı |
| Bütünleşme testi | Örnek kitap kaydedilip tekrar okunabiliyor mu? | Modüllerin izole test ortamında birlikte çalışması |
| Uçtan uca kontrol | Arayüzden kitap ekleyip listede görmek | Tam kullanıcı akışının test ortamındaki sonucu |
| Kod denetimi | Seçilen dilin biçim ve olası hata kontrolü | Kodun belirli yazım/denetim kurallarına uyması |
| Belge kontrolü | Bağlantı ve komut örneklerinin doğruluğu | Belgenin kullanılabilirliği |

Testler `1.1.Tests` gibi plan numaralarına göre çoğaltılmaz; kitap doğrulama veya depolama gibi özellik/modül sorumluluğuna göre düzenlenir. Adım numarası Günlük kaydında test sonucuyla ilişkilendirilir.

**Flake8**, Python kodunu denetleyen bir araçtır; davranış testlerinin yerini tutmaz. **pytest** Python testlerini çalıştırabilir. Başka dillerde başka araçlar kullanılır. Mevcut araçlarla başlamak esastır; yeni paket için kullanıcı kararı gerekir. Her projeye bütün test araçlarını kurmak gerekli değildir. Test kapsamı beklenen davranışa ve değişikliğin etkisine göre seçilir. [Flake8 belgeleri](https://flake8.pycqa.org/en/latest/glossary.html), [pytest başlangıcı](https://docs.pytest.org/en/stable/getting-started.html).

Başarısız, atlanan (`skipped`) veya çalıştırılamayan kontroller ayrı yazılır. Çözülemeyen başarısızlık bildirilir; gerekli doğrulama yapılmadan adım “doğrulandı” sayılmaz. Testlerin geçmesi canlı ortamın doğru çalıştığını kanıtlamaz. Gerçek veriyi değiştiren veya canlı sistemde işlem yapan komutları sen çalıştırırsın; ajan komutu ve beklenen kanıtı açıklar.

## 🧱 Dosya bütünlüğü ve mimari

Alt başlıklar iş sırasını yönetir; dosyalar sorumluluğuna göre düzenlenir. Aynı alt adım birden fazla dosyada değişiklik gerektirebilir. Ajan, değişikliğin kullanan modüllere etkisini inceleyip uygun kontrollerle bütünlüğü korumaya çalışır.

Bu düzen Singleton tasarım desenini otomatik sağlamaz ve her projeye Singleton dayatmaz. Singleton, bir sınıfın tek örneğinin kullanılmasını amaçlayan bir tasarım tercihidir. Gerekirse proje mimarisi görüşülür; karar ve sınırlar kaydedilir.

## ✅ Elle denetim ve Git

Kurulumdan sonra hedef proje kökünde elle denetimi çalıştırabilirsin:

```powershell
powershell.exe -NoProfile -File .\.ai-sablon\kontrol.ps1
```

Başka klasörden çalıştırırken hedefi açıkça ver; makine tarafından okunabilir çıktı için `-AsJson` kullanılabilir:

```powershell
powershell.exe -NoProfile -File .\sablon\.ai-sablon\kontrol.ps1 -ProjectDirectory "C:\Projeler\KitapTakip" -AsJson
```

İkinci komut kaynak şablon deposunda çalıştırılır; denetlenen yer `KitapTakip` hedefidir. Kaynak deponun kendi geliştirme kayıtlarını hedef projenin kurulum kaydı gibi kontrol etmez. Windows betikleri engelliyorsa kurulum bölümündeki gibi yalnız ilgili işleme `-ExecutionPolicy Bypass` eklenebilir.

| Çıkış kodu | Anlamı | Örnek |
|---|---|---|
| **0** | Denetlenen yapıda hata/uyarı bulunmadı | Yapısal olarak uygun kayıtlar |
| **1** | En az bir yapısal hata var | Eksik zorunlu dosya, bozuk JSON, bozuk yerel bağlantı |
| **2** | Hata yok, en az bir uyarı var | Eksik çalışma kaydı, Plan–Devir farkı veya geliştirme paketi |

Şu anki geliştirme paketinde temiz kurulumdan sonra bile **2 beklenir**: paket geliştirme durumundadır ve 1.4 araç denemeleri beklemektedir. Uyarı, kurulumun başarısız olduğu anlamına gelmez. Hata varsa 1 önceliklidir. JSON çıktısındaki `status`, `errors`, `warnings` ve `findings` alanları aynı ayrımı taşır.

Denetim sekiz zorunlu dosyayı, varsa README'yi, CLAUDE içe aktarımını, UTF-8/BOM düzenini, yerel bağlantıları ve kurulum kaydının biçim/tutarlılığını inceler. Plan'ın gerçek alt adımlarını Günlük ve Devir ile karşılaştırır. Planlanmış işe tamamlanmış kayıt şartı koymaz; boş başlangıç, kod blokları ve HTML yorumlarını çalışma kaydı saymaz. Yerel bağlantının dosya hedefini kontrol eder; başlık parçalarını, dış URL'leri ve proje dışındaki yerel dosyaları denetlemez. Tam bir Markdown çözümleyicisi değildir.

Belgelerin otomatik düzeltilmesi yoktur. Ajan bulguları değerlendirir; yetkili çalışma adımı içindeki eksik kayıtları tamamlar. **Kullanıcı onayının gerçekliğini, testlerin gerçekten çalıştığını veya kodun doğru olduğunu kanıtlamaz.** Git deposu oluşturmaz; dosya yazmaz veya ağ işlemi yapmaz. İlk sürümde hook, otomatik engelleme ve yeni paket yoktur.

Kayıtlar başlangıç belgelerindeki standart alanları kullanır. Günlük'te gerçek kayıt başlığı `## yyyy-MM-dd HH:mm — açıklama`; alanlar `Çalışma birimi`, `Yapılan iş ve nedeni`, `Değişen dosyalar`, `Doğrulama`, `Başarısız`, `Atlanan`, `Çalıştırılamayan` biçimindedir. Kararlar `## K-001 — açıklama` gibi başlıklar ve `Karar`, `Gerekçe`, `Etki` alanlarıyla; Devir, Plan ile aynı `Güncel çalışma birimi` alanıyla yazılır. Serbest biçimli bir metnin anlamı veya onayın gerçekliği bu alanlardan çıkarılmaz.

Şablon deposunun kurulum/denetim kabul testlerini kaynak depo kökünde çalıştır:

```powershell
powershell.exe -NoProfile -File .\tests\Kurulum.Tests.ps1
```

Bu testler Windows PowerShell 5.1 ve mevcut .NET dışında paket istemez. Test yordamı repo içinde bulunur; kaynak/kurulum örnekleri yalnız Windows'un geçici klasöründe oluşturulur. Gerçek projeye veya global skill/ayar dosyasına yazılmaz. Sonuç sayıları ve `SONUCLAR.json` yolu konsola verilir. Geçici örnekler otomatik silinmez. Test çıkışı 0: bütün kontroller geçti; 1: başarısızlık; 2: başarısızlık yok ama atlanan kontrol var. Ortam örnek klasör yönlendirmesi oluşturamıyorsa ilgili test gerekçesiyle atlanır; geçti diye gösterilmez.

Bu test dosyası hedef projeye kopyalanmaz; hedefteki ürünün kendi testleri seçilen teknolojiye göre ayrıca hazırlanır. Testlerin sentetik kayıtlarla temiz sonuç üretmesi, gerçek VS Code denemelerinin tamamlandığı anlamına gelmez.

Git deposunu, GitHub uzak adresini ve Git kimliğini sen kurarsın. Ajan yerel doğrulamaları tamamlar; dosya listesi ve Türkçe commit mesajı önerir. Açık onaydan sonra commit yapılır; push ayrıca onay gerektirir. `.gitignore` kapsamındaki yerel dosyalar commit edilmez; toplu `git add .` kullanılmaz.

[GitHub deposu](https://github.com/Emir-Ars/AI-Sablonum) ve yerel Git deposu kullanıcı tarafından oluşturuldu; dal `main`, uzak adres `origin` olarak tanımlı. 1.1–1.3 commit ve push edildi. Commit geçmişi Git'ten, yapılan kontroller Günlük'ten okunur. GitHub'a push ve sürüm etiketi ayrı işlemlerdir. Kurallar Windows PowerShell 5.1'i esas alır: `.ps1` UTF-8 BOM'lu, Markdown/JSON/YAML UTF-8 BOM'suz saklanır.

## 🛠️ Geliştirme durumu

| Adım | İçerik | Durum |
|---|---|---|
| 1.1 | Kurallar, dört kayıt modeli, README, iki SVG | Doğrulandı — 12 Markdown, 2 SVG |
| 1.2 | Kurucu ve kaynak sürüm kaydı | Doğrulandı — 41 kabul kontrolü |
| 1.3 | Elle denetim ve bağımlılıksız test betiği | Doğrulandı — Windows PowerShell 5.1'de 60 kabul kontrolü |
| 1.4 | Codex/Claude VS Code davranış denemeleri | Kısmen doğrulandı — Codex planlama 2/8; diğer 6 kontrol yapılmadı |

Ayrıntılı durum ve kabul ölçütleri [Plan](docs/PLAN.md), gerçek kontrol sonuçları [Günlük](docs/GUNLUK.md), sonraki oturumun başlangıcı [Devir](docs/DEVIR.md) dosyasındadır. Genel planın kabulü sonraki adımların uygulama izni değildir.

1.4 için mesaj sırası ve beklenen sonuçlar [VS Code deneme kılavuzunda](docs/VS_CODE_DENEMELERI.md) bulunur. 2/8 gerçek davranış kontrolü doğrulandı: Codex genel planı ve seçilen aşamanın alt başlıklarını kendisi hazırlayıp uygulamadan durdu. Tek adım uygulaması, Claude ve iki yönlü devir denemeleri henüz yapılmadı; tam araç uyumluluğu doğrulandı denmez. Bu denemede ortaya çıkan genel görüşme kaydı yanlış uyarısı kaynakta düzeltildi; güncel kabul betiği 64/64 başarılı, başarısız 0 ve atlanan 0. Küçük alt adımlar, kullanıcının sevdiği çalışma düzeni olarak korunur; bunların içeriğini ve numaralarını ajan üretir, kullanıcı uygulanacak adımı seçer.

## 🔎 Resmî kaynaklar ve doğrulama sınırı

Codex'in proje talimat girişi `AGENTS.md` üzerine, Claude'un girişi ise `CLAUDE.md` içe aktarımı üzerine kuruludur. Bu dosya mekanizmaları belgelenmiştir; bizim kurallarımızın iki araçtaki gerçek davranışı 1.4'te ayrıca denenecektir. [Codex AGENTS.md](https://learn.chatgpt.com/docs/agent-configuration/agents-md), [Claude talimatları ve içe aktarım](https://code.claude.com/docs/en/memory).

VS Code kullanımı için [Codex IDE belgeleri](https://learn.chatgpt.com/docs/codex/ide) ve [Claude VS Code belgeleri](https://code.claude.com/docs/en/vs-code) esas alınır. Depo şablonuyla bütün depoyu çoğaltmanın farkı [GitHub şablon belgelerinde](https://docs.github.com/en/repositories/creating-and-managing-repositories/creating-a-repository-from-a-template) açıklanır. İleride testleri GitHub'da otomatik çalıştırmak ayrı bir proje kararıdır: [GitHub sürekli bütünleşme belgeleri](https://docs.github.com/en/actions/get-started/continuous-integration).
