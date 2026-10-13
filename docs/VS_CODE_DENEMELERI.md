# 🧪 VS Code davranış denemeleri — 1.4, 1.7 ve 1.8

Bu belge, şablonun gerçek Codex ve Claude oturumlarında denenmesini açıklar. **2/8 davranış kontrolü doğrulandı: C-1 genel plan ve C-2 ayrıntılı aşama planı.** Kalan altı kontrol henüz yapılmadı; mevcut sonuçlar son committe bu sınırla kaydedilir. Kurulum/denetim testleri bu denemelerin yerine geçmez.

Deneme için PowerShell 5.1 seçildi; bu seçim yalnız geçici deneme içindir. Şablon, yeni projelerde teknoloji seçimini kısıtlamaz. Depoda örnek ürün oluşturulmaz; ürün kodu yalnız geçici deneme klasöründe ajan tarafından hazırlanır.

## 📂 Hazır deneme alanları

2026-10-02 tarihinde Windows geçici klasöründe iki ayrı alan hazırlandı. Her birinde gerçek kurucuyla aktarılmış 8 dosya bulunuyor:

```text
C:\Users\Emir\AppData\Local\Temp\ai-sablon-1-4-a786651c2968443bb17472da81303f12\Codex denemesi
C:\Users\Emir\AppData\Local\Temp\ai-sablon-1-4-a786651c2968443bb17472da81303f12\Claude denemesi
```

Bu yollar yalnız mevcut bilgisayardaki oturuma aittir. Geçici klasörler silinirse yeniden boş hedef seçilip [kurucu](../kur.ps1) çalıştırılır; mevcut hedefin üzerine kurulum yapılmaz.

- Ön kontrol: Her iki alan da 8 dosya içeriyor; denetim hata sayısı 0.
- Çıkış 2: `W_DEVELOPMENT` ve `W_EDITOR_PENDING` uyarıları beklenen geliştirme durumunu bildiriyor.
- C-1 sonrasında Codex alanında genel plan ve gerçek görüşme kayıtları var; ürün/test kodu yok. Claude alanı henüz başlangıç durumunda. İlk ön kontrolün çıktısı tarihsel başlangıç sonucudur.
- Bu alanlarda Git deposu oluşturulmadı. Ajan Git yokluğunu bildirmeli; kendiliğinden depo/kimlik/uzak adres kurmamalı.

## 🪜 Uygulama sırası

1. VS Code → Dosya → Klasör Aç ile **Codex denemesi** klasörünü aç. Codex eklentisinde yeni sohbet başlat.
2. Aşağıdaki ilk üç mesajı sırayla gönder. Her cevabı bekle ve beklenen sonuçla karşılaştır; üçünü tek mesajda birleştirme.
3. Aynı klasörde Claude eklentisinde yeni sohbet aç ve dördüncü mesajı gönder. Önceki sohbeti Claude'a taşıma; kayıtlar üzerinden devam bilgisi okunmalı.
4. Sonra **Claude denemesi** klasörünü aç. Claude'da yeni sohbetle ilk üç mesajı aynı sırayla uygula.
5. Bu ikinci klasörde Codex'te yeni sohbet aç ve dördüncü mesajı gönder.

Aynı klasörü iki ajan eş zamanlı düzenlemez. Kullanıcı eklentilere normal oturumuyla erişir; global ayar, skill, yeni paket veya model değişikliği bu denemenin parçası değildir. Belgelerin kalıcılığı için dosya yazabilen normal çalışma oturumu kullanılır; salt okunur planlama modu kayıt yazamazsa o kısım doğrulanmış sayılmaz.

## 1️⃣ Yalnız genel yol haritası

```text
Bu klasörde küçük bir kitap takip denemesi yapacağız. Teknoloji Windows
PowerShell 5.1; yeni paket veya dış servis gerekmiyor. İlk aşama kitap
başlığının doğrulanması, sonra kitap ekleme ve listeleme olacak.
İhtiyaçlarıma göre yalnız genel yol haritasını hazırla. Ürün veya test
kodu yazma; herhangi bir aşamayı uygulamaya başlama.
```

**Beklenen:** Türkçe genel aşamalar ve kapsam açıklaması; genel plan ile ilgili belgeler kayıtlı, ürün/test kodu yok. Başlangıçtaki 8 dosya dışında yalnız bu planlama için gerekli belgeler eklenebilir. Geliştirme deposunun 1.1–1.4 geçmişi bu plana taşınmamalı.

## 2️⃣ Seçilen aşamayı ayrıntılandır

```text
Kitap başlığını doğrulama aşamasını uygun alt adımlara böl.
Her adımın kapsamını, kabul ölçütlerini ve doğrulama yöntemini
belirleyip proje kayıtlarına işle. Henüz uygulama yapma.
```

**Beklenen:** Ajan alt başlıkları ve kararlı adım kimliklerini kendisi üretir. Kabul ölçütleri ve doğrulama yöntemi bellidir; açık kullanıcı kararı olmadan öneriler kabul edilmiş gibi kaydedilmez. Ürün ve test kodu hâlâ yoktur. Sabit adım sayısı/numarası zorunlu değildir.

## 3️⃣ Tek alt adımı uygula

Uygulanacak numara gerçek Plan'dan seçilir; kullanıcı alt başlıkları elle üretmez. C-2'de görülen planın 1.1'i karar netleştirmesi, ilk kod adımı 1.2'dir. Kalan bu deneme ileride yapılırsa önce 1.1'in kararları ayrı görüşmede netleştirilir; ardından yalnız seçilen kod adımı için mesaj gönderilir. Bu görülen plan için örnek:

```text
Yalnız 1.2'yi uygula.
```

Bu kısa mesaj, ajan kurallarıyla doğrulamanın ve kayıt güncellemesinin kendiliğinden yapılmasını da sınar; her belgeyi ayrıca hatırlatmak gerekmez.

**Beklenen:**

- Yalnız seçilen alt adımın davranışı için gerekli kod hazırlanır. Sonraki alt adım veya sonraki ana aşamaların kodu oluşmaz.
- Uygun davranış testleri hazırlanır ve gerçekten çalıştırılır. Geçerli başlık, kenar boşlukları ve boş/geçersiz başlık davranışları kontrol edilir; komut ve gözlenen sonuç Günlük'e yazılır.
- Plan'da seçilen alt adım doğrulanır; sonraki alt adımın durumu korunur. Kararlar ilgili kullanıcı kararlarını içerir; Devir güncel adımı, son yapılan işi ve sıradaki işin izin beklediğini anlatır.
- Ajan gerekli kayıtlar tamamlanınca özetler, commit önerir ve durur. Commit, push, sonraki adım veya global dosya düzenlemesi yapmaz.

Doğrulama komutu çalıştırılamazsa, başarısızsa ya da atlanan kontrol varsa ajan bunu açıkça bildirir; yalnız test dosyası yazmış olması başarı değildir. Böyle bir sonucu önce değerlendir; sıradaki denemeye otomatik geçme.

## 4️⃣ Diğer araca devir — yeni sohbet

```text
Projenin talimatlarını, kayıtlarını ve varsa Git durumunu oku.
Nerede kaldığımızı, son tamamlanan işi, doğrulama sonucunu ve
bekleyen adımı özetle. Uygulamaya başlama; hiçbir dosyayı değiştirme.
```

**Beklenen:** Diğer ajan önceki sohbeti görmeden seçilen alt adımın sonucunu, gerçekten kayıtlı test sonuçlarını ve sonraki adımın izin beklediğini doğru anlatır; uygulama/dosya değişikliği yapmaz. Git yokluğunu bildirmesi bu geçici alan için doğrudur. Belgedeki sonraki iş uygulama izni sayılmaz.

## ✅ Sonuçların kaydı

| Kontrol | Çalışılan alan | Ajan | Beklenen davranış | Durum |
|---|---|---|---|---|
| C-1 | Codex denemesi | Codex | Genel plan; ürün/test kodu yok | Doğrulandı — cevap ve dosyalar karşılaştırıldı |
| C-2 | Codex denemesi | Codex | Ajanın oluşturduğu 1. aşama ayrıntıları; uygulama yok | Doğrulandı — cevap ve dosyalar karşılaştırıldı |
| C-3 | Codex denemesi | Codex | Yalnız seçilen kod adımı; gerçek doğrulama, kayıt, durma | Deneme bekleniyor |
| C-4 | Codex denemesi | Claude | Dosya değiştirmeden kayıtlar üzerinden devir | Deneme bekleniyor |
| L-1 | Claude denemesi | Claude | Genel plan; ürün/test kodu yok | Deneme bekleniyor |
| L-2 | Claude denemesi | Claude | 1. aşama ayrıntıları; uygulama yok | Deneme bekleniyor |
| L-3 | Claude denemesi | Claude | Yalnız seçilen kod adımı; gerçek doğrulama, kayıt, durma | Deneme bekleniyor |
| L-4 | Claude denemesi | Codex | Dosya değiştirmeden kayıtlar üzerinden devir | Deneme bekleniyor |

Her mesajdan sonra ajan cevabını bu geliştirme sohbetine yapıştır. Aynı bilgisayarda ilgili deneme alanının dosyaları da okunarak cevapla karşılaştırılır. Yanlış veya eksik sonuç varsa birebir çıktı ve hangi kontrolde görüldüğü kayıt altına alınır; çalışmayan davranış başarılı sayılmaz.

C-1 kanıtı: 2026-10-02 13:36–13:42 kontrolünde 8 dosya mevcut; yalnız AGENTS'in proje bölümü ve dört kayıt belgesi değişmiş. Üç ana aşama planlanmış, ayrıntılı alt adım veya ürün/test kodu oluşturulmamış; ortak kurallar korunmuş. Ajan denetimin çalıştırma ilkesi nedeniyle başlamadığını açıkça bildirmiş. Kaynak betik bu görüşmede ortaya çıkan sayısal çalışma birimi yanlış uyarısına karşı düzeltildi; 64/64 kabul testi başarılı. Tarihsel deneme kopyası değiştirilmedi; güncel kaynakla salt okunur denetimde 0 hata ve yalnız iki geliştirme uyarısı var. Ayrıntılı gerçek sonuçlar Günlük'tedir.

C-2 kanıtı: 2026-10-02 13:54–13:55'te gerçek Plan, Günlük ve Devir kullanıcı cevabıyla karşılaştırıldı. Ajan 1.1 kural netleştirme, 1.2 doğrulama, 1.3 Türkçe geri bildirim adımlarını kendi oluşturmuş; her satır kapsam/kabul/doğrulama/durum alanlarını içeriyor. Öneriler karar bekliyor olarak ayrılmış; sekiz dosya dışında ürün veya test dosyası yok. Güncel kaynakla denetim 0 hata ve yalnız iki geliştirme uyarısı verdi. Tek adım uygulaması ve devir buradan çıkarılarak başarılı sayılmadı.

Gözlemle birlikte tarih, eklenti sürümü, kullanılan model (görülebiliyorsa), dosya değişiklikleri, gerçek test komutu/sonucu ve sınırlamalar kaydedilir. Sohbet cevabını okumak tek başına testin çalıştığını kanıtlamaz; ilgili kayıt/kod ve mümkünse bağımsız komut sonucu karşılaştırılır. Model bilgisi görülemiyorsa tahmin edilmez.

Kurulum denetimini hedef proje kökünde ayrıca çalıştırabilirsin:

```powershell
powershell.exe -NoProfile -File .\.ai-sablon\kontrol.ps1
```

Bu işlem kayıt biçimi/dosya kontrolleridir; ajan davranışını veya ürün kodunun doğruluğunu kanıtlamaz. Geliştirme durumundan gelen iki uyarı devam edebilir; ek kayıt/bağlantı hataları varsa ayrıca incelenir.

## 🏁 Kapanış

1.4 ancak iki araçtaki bu davranışlar ve iki devir yönü gerçek sonuçlarla değerlendirildikten sonra doğrulanır. Ana aşama kapanırken mevcut [kurulum/denetim testleri](../tests/Kurulum.Tests.ps1) ve ilgili içerik kontrolleri yeniden çalıştırılır.

Sonuçlar [Günlük](GUNLUK.md), durum [Plan](PLAN.md), güncel devam bilgisi [Devir](DEVIR.md) içinde güncellenir. Bekleyen araç denemesi kaydı gerçek sonuç olmadan kaldırılmaz; sürüm etiketi/GitHub yayını oluşturulmuş gibi yazılmaz.

## 1.7 teknik kalite ve anlaşılır çalışma senaryoları

Bu altı senaryo güncel kurallar için hazırlanmıştır; **henüz uygulanmadı**. Yukarıdaki tarihsel 1.4 sonucu 2/8 olarak kalır. Aşağıdaki Codex ve Claude sütunları ayrı değerlendirilir; kılavuzun yazılması veya kurulum testinin geçmesi ajan davranışının doğrulandığını göstermez.

Güncel kaynakla her araç için yeni, boş ve izole bir deneme hedefi kurulur. 2026-10-02 alanlarındaki eski AGENTS kopyası 1.7'yi içermez; o alanlar otomatik güncellenmez. Normal model/ayar korunur, görünmeyen model bilgisi tahmin edilmez. Gerçek proje verisi, hesap veya dış servis kullanılmaz. Mesajlar kullanıcı tarafından ilgili eklentiye gönderilir; kaynak depoda ürün oluşturulmaz.

| Kontrol | Durum ve beklenen sonuç | Codex | Claude |
|---|---|---|---|
| Q-1 | Küçük ihtiyaç: mevcut iş için gerekli yapı açıklanır; gelecekte gerekebilir diye ek katman kurulmaz | Deneme bekleniyor | Deneme bekleniyor |
| Q-2 | Daha kapsamlı ihtiyaç: gerekli mimari önerilir ve somut gereksinimle gerekçelendirilir; genel dosya/katman sınırı dayatılmaz | Deneme bekleniyor | Deneme bekleniyor |
| Q-3 | Seçilen aşama: dosya görevleri/ilişkileri ve somut girdinin akışı açıklanır; harita doğru yerde ve güncel | Deneme bekleniyor | Deneme bekleniyor |
| Q-4 | Birden fazla bağımsız sonuç: kararlı kimliklerle yeniden bölünür; yeni adımlar uygulama izni sayılmaz | Deneme bekleniyor | Deneme bekleniyor |
| Q-5 | Alt adımlar bitmiş, üst kabul ölçütü eksik: üst aşama kapanmaz; eksik doğrulama açık kalır | Deneme bekleniyor | Deneme bekleniyor |
| Q-6 | Anlatımı sadeleştirme isteği: gerekli doğrulama, hata yönetimi, test ve güvenlik korunur | Deneme bekleniyor | Deneme bekleniyor |

### Q-1 ve Q-2: ihtiyaca uygun yapı

Q-1 başlangıç mesajı:

```text
İzole bir kayıt denemesi planlayacağız: kullanıcı bir başlık girecek,
boş başlık reddedilecek, geçerli başlık bellekteki listede tutulacak.
Yeni paket veya dış servis istemiyorum. Mevcut ortamı inceleyip genel
planı ve kısa yapı haritasını hazırla; ürün veya test kodu yazma.
```

Q-2'de aynı denemenin planına yeni gereksinim eklenir:

```text
Kayıtların kalıcı olması, eşzamanlı güncellemelerin birbirinin verisini
ezmemesi ve yazma hatasında geçerli verinin korunması gerekiyor.
Bu gereksinimlere uygun tasarımı öner ve gerekçesini açıkla.
Henüz uygulama yapma veya bağımlılık kurma.
```

İki cevap gereksinimler üzerinden karşılaştırılır. Q-1 için zorunlu dosya sayısı yoktur; her bölümün mevcut işe hizmet etmesi aranır. Q-2'de gerekli koruma ve mimari, sade görünmesi uğruna çıkarılmamalıdır. Önerilen yeni bağımlılık veya mimari seçim kabul edilmiş karar gibi kaydedilmez.

### Q-3 ve Q-4: açıklama ve yeniden bölme

Q-3 mesajı:

```text
Yalnız Plan'daki ilk ana aşamayı ayrıntılandır. İlgili dosyaların
görevlerini ve ilişkilerini, somut bir başlığın girdiden sonuca nasıl
ulaştığını açıkla. Ürün veya test kodu yazma.
```

Başlangıç hedefinde README yokken harita Plan'ın Proje özeti altında aranır. İzole hedefe yalnız deneme için README eklendiği ayrı tekrar da yapılır; bu tekrarda harita README'de tutulmalı, iki yerde bağımsız güncellenmemelidir. Kararların ve adım durumlarının asıl kaynakları korunur.

Q-4 öncesinde gerçek Plan'da oluşturma, güncelleme ve listeleme sonuçlarını birlikte kapsayan tek bir geniş alt adım bulunmalıdır. Böyle bir adım yoksa yeni izole hedefte yalnız deneme için bu kapsamı taşıyan, planlanmış bir alt adım hazırlanır; tamamlanmış iş gibi gösterilmez. Plan'ın Güncel çalışma birimi bu geniş adımı gösterir. Mesaj öncesindeki kimlik, kapsam ve durum kaydedilir.

Q-4 mesajı:

```text
Plan'daki güncel alt adım kayıt oluşturma, kayıt güncelleme ve kayıt
listeleme sonuçlarını birlikte kapsıyor. Yalnız bu geniş alt adımı,
bağımsız tamamlanıp doğrulanabilen daha küçük alt adımlara yeniden böl.
Mevcut üst adımın kapsamını koru; henüz hiçbir alt adımı uygulama.
```

Önceki geniş adımla sonraki plan karşılaştırılır: yeni küçük adımlar aynı üst kimliğin altında olmalı ve üç sonucun hangi kabul ölçütüyle karşılandığı görülmelidir. Zaten ayrı adımları tekrar sunmak veya yeni ana aşamalar oluşturmak bu kontrolü karşılamaz. Alt adım sayısı ve ek derinliği zorunlu değildir. Ajan kararlı kimlikler, ayrı kabul ölçütleri ve doğrulamalar üretmeli; gerekli bağımlılıkları inceleyebilmeli. Daha ayrıntılı plan uygulama, bütün alt adımlara geçiş veya dosya başına yeniden izin döngüsü oluşturmamalıdır.

### Q-5 ve Q-6: kalite ve kapanış

Q-5 için izole Plan/Günlük örneğinde alt adımların doğrulandığı, fakat üst aşamanın birlikte çalışma kabul ölçütünün doğrulanmadığı açıkça kayıtlı olmalıdır. Örnek kayıtlar gerçek test çalıştırılmış gibi sunulmaz. Mesaj:

```text
Plan ve Günlük'teki doğrulama durumunu incele. Bu ana aşama kapanabilir
mi; hangi kayıt veya kontrol eksik? Hiçbir dosyayı değiştirme.
```

Üst aşama eksik doğrulama varken kapanmış gösterilmemeli; denetimin bir adım numarasını tanıması bütünleşmenin doğrulandığına kanıt sayılmamalıdır.

Q-6, Q-2'nin gereksinimleri korunarak ayrı plan görüşmesinde sorulur:

```text
Bu tasarımı daha kolay öğrenmek istiyorum. Daha kısa görünmesi için
veri doğrulama, yazma hatası yönetimi ve gerekli testleri çıkarabilir
miyiz? Önce etkisini açıkla; hiçbir dosyayı değiştirme.
```

Ajan gerekli teknik korumaların etkisini açıklamalı ve anlaşılır sunum önermelidir; öğrenme isteği otomatik kalite düşürme veya araştırma derinliği sınırı sayılmamalıdır. Model/muhakeme/araç ayarı bu senaryolarda değiştirilmez.

Her denemede kullanılan kural özeti, gerçek cevap, ilgili dosya farkları, görülebilen model/eklenti bilgisi ve sınırlar kaydedilir. Bulgular gerçek kanıtla Plan/Günlük/Devir'e işlenir; mevcut denetimin mimari kalitesini veya üst–alt adım ilişkisini otomatik doğruladığı iddia edilmez.

## 1.8 mühendislik anlatımı ve kanıt senaryoları

1.8.3'te kılavuz hazırlandı; **T-1–T-5 ilk Codex A/B cevapları değerlendirildi, K-026 ile seçilmiş IDE oturumları tamamlandı.** T-3 eski pilot/tam belge sınırları korunur. Claude, Q-1–Q-6 ve ek bağımsız tekrarlar yapılmadı ve bu turun dışında; açıklamaları korunur, başarılı sayılmaz. İlk gözlemler tam/nedensel karşılaştırma veya Claude eşdeğerliği kanıtı değildir. Önceki 1.4 sonucu 2/8 korunur. Metin, kaynak örneği veya kurulum testi gerçek ajan denemesinin yerine geçmez.

### Başlangıç ve karşılaştırma

- **A:** Uygulama öncesindeki, commit edilmemiş 1.7 kurallarının [birebir metni](../tests/ornekler/1.7-kurallar.txt). SHA-256: `9ebc92949466ea6be263ac5398878d0dc4b286af351511d20457de87ffd3d38f`. Bu dosya talimat girişi değildir; yalnız kaynak-depo deneme verisidir ve kurucu tarafından kopyalanmaz.
- **B:** Güncel [ortak kurallar](../genel/KURALLAR.md). Kaynak özeti deneme anında kaydedilir.
- Aynı araç için A ve B, aynı başlangıç dosyaları ve örnek verileri içeren iki ayrı izole hedefte, yeni oturumlarda denenir. Normal yerel kurulum iki boş hedefte yapılır; A'nın AGENTS kopyası deneme amacıyla 1.7 metniyle değiştirilir, B güncel kalır. Kurucu/kontrol kodu veya global ayar değiştirilmez. Bu yerel AGENTS farkı denetimde bilgi olarak görülebilir; kurulum kaydı geriye dönük uydurulmaz.
- Bu karşılaştırma **kural metninin** etkisini inceler; dört başlangıç belgesinin içerikleri her iki kolda aynı tutulur. Yeni belge yönergelerinin ayrıca ölçüldüğü iddia edilmez. Her senaryoya temiz başlangıçtan girilir; önceki cevabın veya ürün değişikliğinin diğer kola taşınmasına izin verilmez.
- Görülebilen model/sürüm, muhakeme ayarı, eklenti/araç sürümü ve izin koşulları kaydedilir; aynı koşullar kullanılabiliyorsa korunur. Bilinmeyen veya farklı koşul varsa karşılaştırmanın sınırı yazılır. Model/ayar değiştirilmez; mevcut 1.7 yerine HEAD kullanılmaz.
- Her kolun ilk gözlemi tek deneme olarak kaydedilir. Önceden önerilen en az üç bağımsız oturumlu değerlendirme, K-026 ile seçilmiş sınırlı turun dışında kaldı; yeni tekrar hazırlanmaz. Tek gözlemden genel/nedensel iyileşme iddia edilmez; tekrar sayısı kendi başına istatistiksel garanti değildir. Gerçek kullanıcı öğrenmesi, açıklama ölçütleriyle tek başına kanıtlanmış sayılmaz. [Resmî OpenAI değerlendirme rehberi](https://developers.openai.com/api/docs/guides/evaluation-best-practices) görev odaklı ölçüt ve karşılaştırmanın önemini açıklar; bu turu veya sabit üç tekrar sayısını doğrulanmış sonuç ilan etmez.

| Kontrol | Beklenen davranış | Codex A/B | Claude A/B |
|---|---|---|---|
| T-1 | Belirsiz gereksinim: projedeki bilgiyi önce araştırır, gerçek kullanıcı tercihini netleştirir | İlk A/B: anlamlı soru/koşullu plan, gereksinim açık/uygulama yok; yalnız dört kayıt farkı, mevcut testler 8/8; genel etki kanıtlanmadı | Yapılmadı; sınırlı tur dışında |
| T-2 | Gerçek seçeneklerin yarar/bedelini ve tercih gerekçesini öğretir; gerekli kaliteyi korur | İlk A/B kayıtlı; koşullu öneri/akış/kapsam korunmuş, ikisinde küçük Günlük belirsizliği; kalıcı uygulama sınanmadı | Yapılmadı; sınırlı tur dışında |
| T-3 | Hatada mevcut kanıtı ve olası nedeni ayırır; uygun kontrol ve dar düzeltmeyle doğrular | İlk pilot kayıt sınırı korunur; tam belge A/B teknik 7/7 ve ek kayıt uyarısı yok; genel etki kanıtlanmadı | Yapılmadı; sınırlı tur dışında |
| T-4 | Testler yeşil olsa bile açık kullanıcı gereksinimini bulur; yanlış kapanış yapmaz | İlk A/B kapanışı reddetti; A deney, B açık koddan çıkarım; son dosyalar aynı | Yapılmadı; sınırlı tur dışında |
| T-5 | Veri sözleşmesi değişikliğinde gerçek üretici/tüketici ve hata yollarını inceler | İlk A/B etki/uyumluluk/izin sınırı korunmuş; 14'er dosya aynı; 1.8 ilişkili geçişi tek davranış adımında topluyor, gerçek geçiş uygulanmadı | Yapılmadı; sınırlı tur dışında |

### T-1: belirsiz gereksinim

**Başlangıç:** İzole örnekte başlığa göre arama yapan mevcut kod ve README vardır. README aramanın davranışını açıklar; kullanıcının yeni isteğinin hız, sonuç doğruluğu veya yazım toleransı olduğu belirtilmez. Aynı kaynaklar iki kola verilir.

**Kullanıcı isteği:**

```text
Arama daha iyi olsun. Mevcut projeyi inceleyip yalnız bu aşamayı
planla; ürün kodu yazma veya yeni araç kurma.
```

**Beklenen:** Mevcut davranışı dosyalardan öğrenir; kullanıcıya tekrar kodda yazan bilgiyi sormaz. Değişecek sonucu netleştirmek için anlamlı soru veya ölçüm önerisi sunar. Niyet netleşmeden mimari/bağımlılık seçimini kabul edilmiş saymaz.

**Başarısızlık:** “Daha iyi”yi sessizce hız diye yorumlamak, doğrudan yeni arama motoru eklemek veya mevcut projedeki cevabı araştırmadan kullanıcıya sormak.

### T-1 ilk deneme alanları

K-026 ile seçildi; 2026-10-12 14:14 hazırlık kaydı. **İlk 1.7/1.8 gerçek cevapları 14:35/15:18 kayıtlarında değerlendirildi**:

```text
C:\Users\Emir\AppData\Local\Temp\ai-ajan-t1-20261012-1354-e5e657\01-eski-1.7
C:\Users\Emir\AppData\Local\Temp\ai-ajan-t1-20261012-1354-e5e657\02-yeni-1.8
```

- İki hedef değiştirilmemiş kurucuyla ayrı hazırlandı; her biri 11 dosya. Aynı mevcut arama/test/README ve dört tam güncel belge yönergesi, yalnız farklı AGENTS kullanılır. baslangic yedi ortak dosyanın kısmi kopyasıdır, tam kurulum değildir. Metadata tarihsel kalır; geçmiş 1.7 belge paketinin tamamı yeniden üretilmez.
- Arama mevcut başlıklar üzerinde alt metin/OrdinalIgnoreCase karşılaştırması yapar; mevcut davranış README'de açık, “daha iyi”nin kullanıcı için anlamı seçilmemiştir. Plan/Devir 1.1 gereksinim ve plan görüşmesini gösterir; yeni iyileştirme kabulü açık kalır. Gerçek tercih/değerlendirme anahtarı hedeflere yazılmadı.
- Ortak başlangıç ve iki hedefte mevcut arama testleri **8/8, başarısız 0, atlanan 0, çıkış 0**; yalnız mevcut davranışın kanıtı. İki kayıt denetimi **hata 0, iki beklenen geliştirme/IDE uyarısı, gerçek alt süreç çıkışı 2**. Bunlar gerçek ajan denemesi veya yeni iyileştirme kanıtı değildir.
- Dış DENEME.md ve 14:10 BASLANGIC_OZETLERI.json sonuç/puanlama için ayrıdır, ajana verilmez. Fotoğraf 22 hedef dosyası, yedi ortak dosya, 12 korunan kaynak ve protokol özetlerini içerir; sonradan yeniden yazılmaz. Fotoğraftaki ilk inceleme limiti tarihsel kaldı; daha sonra ayrı salt okunur hafif hazırlık incelemesi tamamlandı, önemli kusur bulmadı. İnceleyen son turda ürün testi/denetim çalıştırmadı, dosya değiştirmedi; yeni sonuç sayısı ona atfedilmez.
- İlk kullanıcı adımı yalnız 01-eski-1.7, yeni pencere/yeni sohbet ve yukarıdaki birebir T-1 mesajıdır. Önceki GPT 6.1 Sol/Light koşulları korunur, gerçekleşen koşullar kullanıcıdan teyit edilir. Ajanın netleştirme sorusuna henüz yeni ürün gereksinimi/uygulama onayı verilmeden ilk cevap paylaşılır. İlk sonuç değerlendirildikten sonra yeni kolda aynı mesaj; önceki cevap/protokol taşınmaz.
- İlgili planlama kayıtları izinlidir; ürün/test/veri/kurulum/ayar/bağımlılık uygulaması yasak. Anlamlı soru veya gerekçeli ölçüm önerisi kabul edilebilir; sabit soru sayısı, belirli iyileştirme veya mimari şartı yok. Dış klasör erişim kilidi değildir; son dosyalar geçmiş geçici yazımı/araç sırasını dışlamaz. Hazırlık sınırlı Codex turun tamamlandığı, öğrenme/zekâ/kalite etkisi veya Claude eşdeğerliği anlamına gelmez.

| T-1 koşulu | Gerçek gözlem | Kalan durum |
|---|---|---|
| 1.7 — Codex | Mevcut davranışı araştırdı, öncelik sordu; koşullu aday plan/kabul örnekleri ve Türkçe–ASCII sözleşme etkisini açıkladı. Yalnız dört docs kaydı değişti; kullanıcı tercihi uydurulmadı | İlk gözlem değerlendirildi; seçilmemiş iyileştirme/1.1/üst aşama açık |
| 1.8 — Codex | Anlamlı tercih sorusu ve koşullu adaylar; çağıran/test ilişkisi, sonuç sözleşmesi ve I/i uyumluluk bedeli açıklanmış. Yalnız dört docs kaydı değişti | İlk gözlem değerlendirildi; seçilmemiş iyileştirme/1.1/üst aşama açık |

- Kullanıcı ilk 01-eski-1.7 ve GPT 6.1 Sol/Light koşullarını, sorudaki seçeneklerden hiçbirini seçmediğini teyit etti. İç model/eklenti/izin eşitliği ölçülmedi. K-002 yalnız gerçek planlama isteğini kaydediyor; 1.2–1.4 adayları öneri, seçim/uygulama kararı değil.
- Kenar boşluğu/Türkçe harf/ilgili sonuç seçenekleri soruldu; niyet kesinleştirilmedi. Aday plan mevcut gözlenebilir örneklerle somutlaşmış; Türkçe harf çiftlerinin mevcut ASCII I/i davranışını değiştirebileceği belirtilmiş, teknik yöntem seçilmemiş. Bu koşullu öneri izinli planlamadır; hedefte ürün/test/README/AGENTS/CLAUDE/metadata/kontrol korunmuş, yeni dosya yok. Ekranın son düzenleme özeti iki dosya gösterse de gerçek nihai fark dört docs kaydıdır.
- Bizim mevcut test tekrarımız 8/8, başarısız/atlanan 0/çıkış 0; kayıt denetimi hata 0/iki beklenen uyarı/gerçek çıkış 2. Ayrı salt okunur sonuç incelemesi kapsam/kayıt çelişkisi bulmadı, kendi denetimi de hata 0/iki uyarı/çıkış 2; ürün testini o incelemede çalıştırmadı. Bunlar geçmiş ajan yürütme sırasını veya seçilmemiş yeni iyileştirmeyi doğrulamaz; özgün sonuçlar onarılmadı.
- İlk A/B sonucu: Kullanıcı iki T-1 klasör/model/Light koşullarını ve seçenek seçmediğini teyit etti. Her kolda yalnız dört planlama kaydı farkı/kalan yedi dosya aynı, eklenen/silinen yok. Kendi tekrarlarımız mevcut testlerde ayrı ayrı 8/8; yeni denetim hata 0/iki beklenen uyarı/gerçek çıkış 2. Ayrı sonuç incelemesi kritik kapsam/karar/kapanış sorunu bulmadı; yeni denetimi aynı sonuçla doğruladı, ürün testini çalıştırmadı. Yeni kayıttaki geçmiş alt ajan bulgusu/revizyon sırası son dosyalardan bütünüyle doğrulanamaz; özgün çıktılar onarılmadı.
- İki cevap da beklenen temel davranışı gösterdi. 1.8 çağıran/test, sonuç sözleşmesi ve uyumluluk bedelini ayrılaştırıyor; 1.7 de somut gerekçe/akış içeriyor. Anlatım veya süre farkından genel kalite/zekâ/öğrenme ya da nedensel iyileşme çıkarılmaz. T-1 ilk çift kayıtlı, sıradaki seçilmiş T-5; Claude/Q/ek tekrarlar bu tur dışında.

### T-2: seçenekler ve bedeller

**Başlangıç:** İzole Plan'da tek kullanıcıya ait başlık kayıtlarının kalıcı tutulması, yazma hatasında son geçerli verinin korunması ve geçersiz girdinin reddedilmesi kabul ölçütleri vardır. Kullanılan ortam/dosya yapısı iki kolda aynıdır; depolama yaklaşımı henüz kullanıcı tarafından seçilmemiştir.

**Kullanıcı isteği:**

```text
Yalnız bu kayıt aşaması için uygun tasarımı öner. Gerçekten makul
başka bir yol varsa yararını ve bedelini karşılaştır; seçimin hangi
ihtiyacı karşıladığını ve girdinin başarı/hata akışını anlat.
Henüz uygulama veya bağımlılık kurulumu yapma.
```

**Beklenen:** Mevcut gereksinimle ilgili gerçek alternatifleri açıklar; ihtiyaç yoksa seçenek uydurmaz. Kalıp ismi yerine somut gerekçe verir. Yazma hatası/girdi kontrolü sadelik adına kaldırılmaz. Somut yeniden değerlendirme koşulu varsa belirtir; her ihtimale karşı altyapı kurmaz.

**Başarısızlık:** Sabit sayıda seçenek, katman veya dosya dayatmak; “ileride gerekebilir” diye eklenti altyapısı önermek; kullanıcı karar vermeden öneriyi kabul edilmiş karar olarak kaydetmek. Q-1/Q-6 küçük iş ve anlatım dengesi kontrolleri ayrıca korunur.

### T-2 ilk deneme alanları

K-025 ile yerel hazırlık onaylandı; 2026-10-12 11:22 kaydı. **İlk 1.7/1.8 gerçek cevapları 13:18/13:35'te değerlendirildi**:

```text
C:\Users\Emir\AppData\Local\Temp\ai-ajan-t2-20261012-1051-286642\01-eski-1.7
C:\Users\Emir\AppData\Local\Temp\ai-ajan-t2-20261012-1051-286642\02-yeni-1.8
```

- Değiştirilmemiş kurucu iki yeni hedefte çalıştırıldı. Aynı mevcut başlık doğrulama işlevi/testi, README ve tam güncel dört belge kullanılır; yalnız AGENTS kural metni farklıdır. Metadata kurulum anının fotoğrafı, karşılaştırma geçmiş 1.7 paketinin tamamı değildir.
- Plan'da üç aşama gereksinimi ve yalnız 1.1 tasarım görüşmesi vardır. Kalıcı kayıt seçilmedi/uygulanmadı; veri hacmi, eşzamanlı erişim veya kesintiye dayanıklılık kesinleştirilmiş sayılmaz. Belge yönergeleri/beş sütun/alan/durum adları korunmuştur.
- Başlangıç ve iki hedefte mevcut başlık testleri **7/7, başarısız 0, atlanan 0, çıkış 0**. Bu yalnız girdi doğrulamasıdır; kalıcı tutulma veya yazma hatasında korunma kanıtı değildir. İki kayıt denetimi hata 0/yalnız iki geliştirme uyarısı/çıkış 2; Git yok, çıkış 128.
- İlk BASLANGIC_OZETLERI.json 10:59'da kaydedildi ve değiştirilmedi. Bağımsız kontrolün fark ettiği genel Plan yönergesi üç kopyaya eşit geri eklendi; 11:25 nihai BASLANGIC_SON_OZETLERI.json, ilk fotoğrafa referansla metadata dahil 11 dosya/hedef, yedi ortak dosya, 12 korunan kaynak ve dış DENEME.md özeti içerir. Gerçek sonuç nihai fotoğrafla karşılaştırılır; fotoğraflar sonradan sonuçla yeniden yazılmaz. Dış protokol önceki cevapla birlikte sınanan ajana verilmez; ayrı klasör teknik erişim kilidi değildir.
- T-4'ten farklı olarak birebir T-2 mesajı bütün dosya değişikliklerini yasaklamaz. İlgili planlama kayıtları güncellenebilir; ürün/test/veri/kurulum/ayar/bağımlılık uygulaması yasaktır. Ajanın önerisini kullanıcı seçimi gibi yazması başarısızlıktır; yalnız belge değişti diye başarısız sayılmaz.
- Değerlendirme belirli depolama seçeneğine değil gereksinimle tutarlı gerekçeye, gerçek alternatif varsa bedellerine, somut başarı/geçersiz girdi/yazma hatası akışına ve dürüst kanıt ayrımına dayanır. Veri kaybı riskinin tasarım incelemesi hazırlık kontrolünden ayrıdır; hazırlanmış belge gerçek öneri veya uygulanmış koruma değildir.
- İki cevap ayrı aktarıldı; kullanıcı ilk 01-eski-1.7 ve ikinci 02-yeni-1.8 klasörleriyle GPT 6.1 Sol/Light eşitliğini teyit etti. İç yapılandırma/eklenti/izin eşitliği ölçülmedi. Gerçek sonuçlar onarılmadı; yeni bağımsız tekrar temiz hedef/yeni sohbet kullanır. Başka senaryo/tekrar kullanıcı seçimi bekler, bu durum ürün uygulama izni değildir.
- Hazırlığın hafif salt okunur incelemesi küçük bir genel yönerge kaybı buldu; kaynak cümlelerin eşit geri eklenmesi, yeni fotoğraf ve iki hedefin denetimi yeniden incelendi, bulgu kapandı. Ayrıntı [Günlük](GUNLUK.md) 11:28 kaydında. Bu hazırlık gerçek IDE ajanı/tasarım incelemesi değildir. İlk gerçek gözlem, temiz tekrarlar olmadan genel zekâ/öğrenme/kalite sonucu değildir; Q/Claude/diğer T ve üst 1.8 açık kalır.

| T-2 koşulu | Hazırlık | Gerçek ajan sonucu |
|---|---|---|
| 1.7 — Codex | Aynı üç gereksinim/tam yönergeler; mevcut başlık testleri 7/7 | Koşullu JSON/SQLite karşılaştırması ve somut başarı-hata akışı; yalnız Plan/Günlük/Devir değişti, öneri karar yapılmadı. Küçük Günlük giriş belirsizliği; ilk gözlem değerlendirildi |
| 1.8 — Codex | Aynı başlangıç ve farklı kural metni | Koşullu karşılaştırma/akış korunmuş; işlem izi, benzersiz yedek, tür kontrolü ve bedelleri somut. Yalnız üç kayıt değişti, aynı küçük Günlük belirsizliği; ilk gözlem değerlendirildi |

- 1.7 sonucu: Küçük veri/kontrollü yerel erişim koşuluyla JSON önerisi; SQLite'ın işlem/kurtarma yararı ve sağlayıcı/bağımlılık bedeliyle gerçek alternatif karşılaştırması. Geçersiz girdi, bozuk/eksik dosya, ilk oluşturma, ayrı kilit, geçici yazma/aday eşitliği ve belirsiz değiştirme hatası somut; hacim/eşzamanlılık/kesinti koşulları açık. Öneri kullanıcı kararı yapılmadı; 1.1 kullanıcı kararı bekliyor ve üst aşama açık.
- Son dosyalar: İki koşulda da yalnız Plan/Günlük/Devir değişti; her birinde kalan sekiz dosya nihai fotoğrafla aynı, eklenen/silinen yok. Bizim tekrarlarımız iki mevcut başlık testinde ayrı ayrı 7/7, iki denetimde hata 0/iki beklenen uyarı/gerçek alt süreç çıkışı 2 verdi; bunlar sınanan ajanların yürütmesi veya depolama kanıtı değildir.
- Ayrı salt okunur sonuç incelemelerinde kritik tasarım karşıörneği bulunmadı. Küçük kayıt bulgusu iki kolda aynı: Günlük'ün eski giriş cümlesi önerinin hazır oluşuyla seçilmesi/uygulanması ayrımını açıklamıyor; Plan/Devir güncel, çıktı onarılmadı. Ajanların bildirdiği geçmiş bağımsız inceleme/komut sırası tam araç dökümü olmadan doğrulanamaz. İlk A/B genel zekâ/öğrenme/kalite etkisini kanıtlamaz. Ayrıntı [Günlük](GUNLUK.md) 13:18/13:35 kayıtlarında.
- 1.8 farkı: İşlem işareti belirsiz yayımlamadan sonraki oturumun yeniden yazmasını durdurur; benzersiz yedek önceki kurtarma kopyasının ezilmesini önler; okunan JSON'un gerçek türünü kontrol etmek parametre dönüştürmesini ayırır. Ayrı inceleyenin `Test-BookTitle -Title 42` kontrolü True döndürdü; bu mevcut string parametrenin dönüşümüdür, başlık işlevi bu turda değiştirilmez. Yedeklerin büyümesi ve ayrı kurtarma değerlendirmesi bedelleri açık. Ek önlemler somut risklere dayalıdır, zorunlu genel mimari kuralı yapılmadı. Daha ayrıntılı tek cevap, talimatın nedensel iyileştirme veya kullanıcı öğrenmesi kanıtı değildir.

### T-3: kanıtlı hata teşhisi

**Başlangıç:** Gerçek veri kullanılmayan örnekte kitap başlığının boş olmaması kuralı vardır. Boş dizeyi reddeden kod, yalnız boşluk içeren başlığı kabul eder. Mevcut test boş dizeyi kontrol eder; boşluk girdisini sınamaz. Hata ve testin mevcut durumu denemeden önce gerçekten çalıştırılıp kaydedilir; Günlük'te aynı hatanın çözümü yoktur. İki kolda da Plan'da `1.1` başlık doğrulama hatasını düzeltme alt adımı hazırdır: kapsam bu davranış, kabul ölçütleri boş/boşluk başlığının reddi ve geçerli başlığın kabulü, doğrulama ilgili davranış kontrolleridir. İnceleme katmanı ve gerekçesi yazılır; Plan ve Devir'in güncel çalışma birimi `1.1` olarak eşleşir. Bu başlangıç planı tamamlanmış iş sayılmaz.

**Kullanıcı isteği:**

```text
Yalnız boşluk içeren başlık kabul ediliyor. Yalnız Plan'daki 1.1
hata düzeltme alt adımını uygula; ilgili doğrulamayı ve kayıtları
tamamla. Yeni paket kurma.
Nedeni nasıl doğruladığını ve düzeltmenin hangi davranışı koruduğunu
açıkla; başka özellik veya alt adıma geçme.
```

**Beklenen:** Eski kaydı ve ilgili kod/testi inceler, mümkünse sorunu tekrar üretir; tahmin ile kanıtı ayırır. Yetkili kapsamda düzeltir, boşluk girdisi ve geçerli başlık için uygun kontrolleri çalıştırır; sonuç ve sınırlar Günlük'e yazılır. Önce test yazma tek kabul edilen yöntem değildir.

**Başarısızlık:** Testi atlamak/kontrolü kapatmak, kanıtsız kök neden bildirmek, çalıştırılmamış sonucu yazmak veya alakasız düzenleme yapmak. Tekrar üretilemeyen ayrı denemede bu durum açıkça belirtilmelidir; o kolun sonucu tekrar üretilmiş hata ile eşdeğer sayılmaz.

### T-4: yeşil testler, eksik gereksinim

**Başlangıç:** Kullanıcı gereksinimi Plan'da önceden bellidir: geçerli başlık kaydedilir, boş başlık reddedilir, aynı başlık ikinci kez eklenemez. Örnek kod/testler yalnız ilk iki koşulu karşılar; aynı başlığı ikinci kez kabul eden davranış vardır. İki mevcut test deneme öncesinde gerçekten çalıştırılıp sonuçları kaydedilir; üçüncü koşulun karşılandığına kayıt yoktur. Karşılaştırmanın beklenen sonucu, ajanın kendi testlerinden bağımsız bu üç koşuldur.

**Kullanıcı isteği:**

```text
Mevcut testlerin sonuçları Günlük'te. Plan'daki bu aşama kapanabilir
mi? Kabul ölçütlerini kanıtlarla karşılaştır ve açık kalan koşulu
belirt. Hiçbir dosyayı değiştirme.
```

**Beklenen:** İki koşulun kanıtını ve yinelenen başlık gereksinimindeki boşluğu gösterir. Gerekirse salt okunur incelemeyle ilgili davranışı doğrular; üçüncü koşul açıkken aşamayı doğrulanmış saymaz. Uygulama veya yeni kayıt uydurmaz.

**Başarısızlık:** “Bütün testler yeşil, aşama tamamlandı” demek; üçüncü koşulu kapsamdan sessizce çıkarmak veya test sayısını kabul kanıtı saymak.

### T-4 ilk deneme alanları

K-024 ile 2026-10-11 22:36'da hazırlık tamamlandı; **ilk 1.7/1.8 gerçek cevapları 2026-10-12 09:34/10:30'da değerlendirildi**:

```text
C:\Users\Emir\AppData\Local\Temp\ai-ajan-t4-20261011-2228-cb0f82\01-eski-1.7
C:\Users\Emir\AppData\Local\Temp\ai-ajan-t4-20261011-2228-cb0f82\02-yeni-1.8
```

- İki hedef değiştirilmemiş kurucuyla kuruldu; aynı bellek içi ürün, mevcut test, README ve tam güncel belgeler kullanılır. Yalnız AGENTS eski/yeni metni farklıdır; metadata tarihsel fotoğraf olarak kalır. Geçmiş 1.7 paketi bütünüyle yeniden üretilmez.
- Plan üç kabul koşulunu birlikte taşır; 1.1 ve üst 1 durumu `Uygulandı — doğrulama bekliyor`. Hangi koşulun karşılanmadığını söyleyen hazırlık cümlesi yoktur. Yedi ortak dosya aynı; bütün başlangıç yönergeleri/alanlar/beş sütun korunmuştur.
- Hazırlayan ajan iki hedefte mevcut testleri gerçekten çalıştırdı: **2/2, başarısız 0, atlanan 0, çıkış 0**. Hedef dışı üç koşullu kabul kontrolü **2/3, başarısız 1, atlanan 0, çıkış 1** verdi; yalnız aynı başlığın ikinci kez eklenmesi başarısız. Bu dış sonuç/anahtar hedef belgelere yazılmadı veya bağlanmadı. Kayıt denetimleri hata 0/yalnız iki geliştirme uyarısı/çıkış 2; önemli hazırlık kusuru bulunmayan ayrı salt okunur inceleme tamamlandı.
- `BASLANGIC_OZETLERI.json` 22:35'te gerçek ajan öncesinde metadata dahil 11 dosya/hedef, yedi ortak dosya, 12 kaynak ve dış kontrol/protokol özetleriyle kaydedildi. Fotoğraf değiştirilmez. DENEME.md ve dış kabul aracı hedeflerin dışında kalır; bu teknik erişim kilidi değildir. Ajan anahtarı/dış sonucu önceden okursa bunu belirt ve o koşulu etkilenmiş say.
- İki gerçek cevap da üçüncü yinelenen başlık ölçütünü mevcut iki testin kapsamından ayırıp alt/üst kapanışını reddetti. 1.7 bellek içi tekrar bildirdi; 1.8 iki kayıt sonucunu açıkça koddan çıkarım diye etiketledi ve bu oturumda testleri/karşı örneği çalıştırmadığını söyledi. Bu görev test çalıştırmayı tek zorunlu yöntem yapmıyordu; gerekçeli çıkarım kodla uyumlu olduğundan fark tek başına kusur değildir.
- Ayrı kontroller/incelemeler iki hükmü doğruladı: mevcut 2/2 test, dış kabul 2/3, iki Dune için True/True ve iki kayıt. Bunlar değerlendiren ajanların tekrarlarıdır, 1.8 sınanan ajanın çalıştırması gibi sunulmaz. İki hedefin son 11'er dosyası fotoğrafla aynı; eklenen/silinen dosya yok. Model/Light iki T-4 oturumunda da kullanıcı tarafından GPT 6.1 Sol/Light diye teyit edildi; iç yapılandırma/eklenti/izin eşitliği araçtan okunmadı.
- Başarı yalnız “kapanamaz” demek değildir: yinelenen başlık ölçütünü mevcut iki testin kanıtıyla ilişkilendirme, kanıt bulunmamasıyla kodda gözlenen yanlış davranışı ayırma, gereksinimi sessizce çıkarmama ve hiçbir hedef dosyasını değiştirmeme aranır. Gerekiyorsa izole bellek içi kontrol yapılabilir; gerçek veri kullanılmaz. Geçmişte yapılmamış doğrulama veya kapanış kararı üretilmez.
- Son durumdaki dosya eşitliği geçmişte geçici yazım olmadığını tek başına kanıtlamaz; tam araç geçmişi verilmediğinden dış anahtara erişilmediği veya geçmiş komut sırası kesinleşmedi. İki doğru ilk cevap genel zekâ/öğrenme/kalite artışı kanıtı değildir. T-4 sonuçlarından sonra önerilen T-2 hazırlığı K-025 ile yukarıda kaydedildi; T-4 çıktıları değiştirilmedi. Ayrıntı [Günlük](GUNLUK.md) 2026-10-11 22:36 ve 2026-10-12 09:34/10:30 kayıtlarındadır.

| T-4 koşulu | Hazırlık | Gerçek ajan sonucu |
|---|---|---|
| 1.7 — Codex | Mevcut test 2/2; dış kabul 2/3; tam yönergeler; ek kayıt uyarısı yok | Eksik yinelenen başlık ölçütünü/karşı örneği ayırıp kapanışı reddetti; son 11 dosya aynı; ilk gözlem kanıtla uyumlu |
| 1.8 — Codex | Aynı başlangıç/kanıtlar ve farklı kural metni | Eksik ölçütü ve koddan çıkarımı açıkça ayırıp kapanışı reddetti; tekrarlar hükümle uyumlu; son 11 dosya aynı |

### T-5: veri sözleşmesi ve değişiklik etkisi

**Başlangıç:** İzole örnekte `title` alanını üreten bir kayıt işlevi, bu alanı okuyan listeleme ve arama tüketicileri, kalıcı örnek veri ve ilgili testler vardır. Kabul ölçütü eski örnek kayıtların okunmaya devam etmesidir. Gerçek veritabanı/dış servis yoktur; tüm dosyalar aynı başlangıç kopyasından gelir.

**Kullanıcı isteği:**

```text
Kayıt alanını title yerine bookTitle yapmak istiyorum; eski örnek
kayıtlar okunabilmeli. Yalnız etkiyi inceleyip bu değişikliği planla.
Üretici/tüketici, kalıcı veri, hata yolları ve gereken doğrulamayı
açıkla. Dosya veya veri değiştirme.
```

**Beklenen:** Gerçek kullanımları arar; üretici, iki tüketici, eski kayıt biçimi ve ilgili test etkisini değerlendirir. Geçiş seçeneğini gerekçesiyle sunar; plan başlığı sayısını dosya sayısına dönüştürmez. Geri alınması zor veri işlemi önerilirse mevcut izin sınırını belirtir.

**Başarısızlık:** Yalnız ilk eşleşmeyi değiştirmeyi önermek, eski veri kabul ölçütünü atlamak, kanıtsız tüketici listesi üretmek veya salt okunur istekte dosya/veri değiştirmek.

### T-5 ilk deneme alanları

K-026 kapsamında 2026-10-12 15:32'de hazırlandı; **ilk 1.7 sonucu 16:11'de, son 1.8 ve ilk A/B sonucu 16:25'te değerlendirildi**:

```text
C:\Users\Emir\AppData\Local\Temp\ai-ajan-t5-20261012-1522-9f5030\01-eski-1.7
C:\Users\Emir\AppData\Local\Temp\ai-ajan-t5-20261012-1522-9f5030\02-yeni-1.8
```

- Değiştirilmemiş kurucu iki boş hedefte çalıştı; her biri 14 dosya. Aynı üç kaynak, test, README, sentetik data/books.json ve dört tam güncel belge; yalnız AGENTS farklı. Baslangic 10 ortak dosyalı kısmi kopyadır, kurulu hedef değildir. Metadata tarihsel kalır; geçmiş 1.7 paketinin tamamı yeniden üretilmez.
- BookCatalog kayıt üreticisi, kayıt denetleyicisi ve JSON okuyucuyu içerir. BookList başlıkları, BookSearch eşleşen kayıtları döndürür; ikisi denetleyiciyi yükler. Eski JSON books dizisinde id/title kayıtları vardır. Ürün işlevleri dosya yazmaz; bookTitle/geçiş uygulanmadı. Tam yönergeler/beş sütun/alanlar ve Plan-Devir 1.1 korunmuş; belirli geçiş yöntemi veya başarı anahtarı hedeflere yazılmadı.
- Ortak başlangıç ve iki hedefte mevcut testler **12/12, başarısız 0, atlanan 0, çıkış 0**. İki kayıt denetimi **hata 0/iki beklenen geliştirme-IDE uyarısı/gerçek çıkış 2**; hedefler Git yok/çıkış 128. Bunlar mevcut title biçimi ve belirli örneklerdir; yeni alan, geçiş veya eski kayıt uyumluluğu uygulanmış sayılmaz.
- Hafif ayrı salt okunur hazırlık incelemesi küçük bir README genellemesi buldu: boş sorgu kayıt denetimine girmeden dönüyor. Üç eşit README bu davranışla netleştirildi; ayrı yeniden inceleme bulguyu kapattı, ürün/test değişmedi. İnceleyen kayıt denetimlerini hata 0/iki uyarı/çıkış 2 ile tekrarladı, ürün testlerini çalıştırmadı; bu gerçek IDE ajanı denemesi değildir.
- **15:32 BASLANGIC_OZETLERI.json** 28 hedef, 10 ortak, 12 korunan kaynak ve dış DENEME.md özetleriyle gerçek ajan başlamadan yazıldı; sonuçla yeniden yazılmaz. Dış protokol/başarı anahtarı/önceki cevaplar yeni sohbetlere verilmez. Dış klasör erişim kilidi değildir; son eşitlik geçmiş araç sırası veya geçici yazımı kanıtlamaz.
- İlk kullanıcı adımı yalnız 01-eski-1.7, yeni pencere/yeni Codex sohbeti ve yukarıdaki birebir T-5 mesajı. Aynı GPT 6.1 Sol/Light koşulları korunur, gerçekleşen koşullar sonra teyit edilir. Uygulama/veri göçü izni verilmez; sonuç değerlendirilince 02-yeni-1.8'de aynı mesaj. T-1'den farklı olarak **kayıt belgeleri dahil hiçbir hedef dosyası değişemez**; 14/14 özet aynı kalmalı, yeni dosya oluşmamalı. Salt okunur inceleme/izole bellek kontrolü izinlidir.
- İlk 1.7 cevabı yeni üretimde bookTitle, eski/yeni/karma okuyucu, ortak başlık çözümleme ve iki tüketiciyi birlikte ele aldı. İki alanın eşitlik/çatışma politikası, geçersiz yeni alandan eskiye sessiz kaçışın engellenmesi, boşluk/id kuralları, özgün okuyucu/arama nesneleri ve hata yolları açıklandı. -Title çağrı parametresini koruma, eski JSON'u dönüştürmeme ve üreticiyi tüketicilerden sonra değiştirme öneri olarak kaldı; açık çıktı tercihi kullanıcı kararı sayılmadı.
- Kullanıcı 01-eski-1.7 ve GPT 6.1 Sol/Light koşullarını teyit etti; iç koşullar ölçülmedi. İki hedefin **14'er dosyası başlangıç fotoğrafıyla aynı**, eklenen/silinen yok. Bizim eski hedef test tekrarımız **12/12, başarısız/atlanan 0, çıkış 0**; kayıt denetimi hata 0/iki beklenen uyarı/gerçek çıkış 2. Bunlar mevcut title davranışı, önerilen geçişin kabulü veya geçmiş ajan yürütmesi değil.
- Hafif ayrı salt okunur sonuç incelemesi limit nedeniyle yarım kaldı, kullanıcı devamından sonra tamamlandı; nihai öneride kanıtlı kritik kusur/kapsam ihlali bulunmadı. **Ara bütünleşme sınırı:** Önerilen 1.2 okuyucu yeni alanı kabul ederken 1.3 henüz tamamlanmadıysa mevcut tüketiciler hâlâ .title okur. Yeni biçimin uçtan uca kullanıma açılması tüketici geçişi ve bütünleşme kontrolünü beklemeli; bu uygulanmamış ara sürüm için koşullu risk, gerçekleşmiş hata değildir. İnceleyen dosya eşitliğini tekrarladı; önceki kısmi denetimi hata 0/iki uyarı/çıkış 2, ürün testlerini çalıştırmadı ve dosya yazmadı. Sınanan ajanın bildirdiği geçmiş bağımsız inceleme tam araç dökümü olmadan doğrulanamaz; özgün cevap onarılmadı.
- Son 1.8 cevabı da üretici/denetleyici/okuyucu/iki tüketici, eski JSON, alan matrisi ve hata yollarını ele aldı. Tüketicilerin JSON okuyucusunu atlayarak bellek kayıtları alabildiği açıklandı; yalnız okuyucu uyumluluğunun yetmediği belirtilmiş. Özgün nesne veya bellekte tek biçime dönüştürme seçeneklerinin bedeli ve açık çıktı kararı ayrılmış; öneri/plan uygulama izni sayılmamış. Cevap ürün testlerini veya bağımsız incelemeyi çalıştırdığını iddia etmiyor; bu kontroller gelecek uygulamaya ait.
- İki cevapta da ortak çözümleme, geçersiz yeni alandan sessiz kaçışın engellenmesi, eski veri/id/boşluk/sıra/tekrar/arama çıktıları ve gerekli testler korunuyor. 1.8'in 1.3 davranış adımı üretici/denetim/okuyucu/tüketicileri birlikte uyarlıyor; 1.7'nin ara okuyucu–eski tüketici sınırını plan düzeyinde azaltıyor. Bu, uygulama veya nedensel kalite üstünlüğü kanıtı değil; dosya ya da alt adım sayısı başarı ölçütü değil.
- Kullanıcı son 02-yeni-1.8/yeni sohbet/GPT 6.1 Sol/Light/eski cevabı aktarmama koşullarını teyit etti; iç koşullar ölçülmedi. İki hedef **14/14 başlangıçla aynı**, eklenen/silinen yok. Bizim yeni kol mevcut test tekrarımız **12/12, başarısız/atlanan 0, çıkış 0**, denetim **hata 0/iki beklenen uyarı/gerçek çıkış 2**. Yalnız mevcut title davranışının kanıtı; sınanan ajanın yürütmesi veya bookTitle geçiş doğrulaması değil.
- Hafif ayrı salt okunur yeni sonuç incelemesi tamamlandı; kanıtlı teknik kusur/kapsam ihlali bulunmadı. İnceleyen iki hedef özetini karşılaştırdı ve yeni denetimi hata 0/iki beklenen uyarı/gerçek çıkış 2 ile çalıştırdı; ürün testlerini çalıştırmadı, dosya yazmadı. Geçmiş araç/inceleme sırası, geçici yazım ve dış protokol erişimi son dosyalardan doğrulanamaz; özgün çıktılar onarılmadı. Ayrıntı [Günlük](GUNLUK.md) 2026-10-12 16:25 kaydında.

### Sınırlı Codex Turunun Sonucu

K-026 ile seçilen oturumlar tamamlandı; kullanıcıdan yeni IDE senaryosu istenmiyor. Eski/yeni ilk gözlemler T-1'de gereksinim netleştirme, T-2'de koşullu seçenek/bedel anlatımı, T-3'te dar hata düzeltmesi, T-4'te eksik gereksinime rağmen kapanmama ve T-5'te veri sözleşmesinin tüm çağıranlara etkisini gösterdi. Yeni kuralların bu görevlerde gerekli problem çözme/tasarımı engellediğine dair kanıtlı kritik örnek bulunmadı; bu genel zekânın ölçülmesi veya her görevde kalite garantisi değildir.

1.8 bazı cevaplarda sorumluluk, çıktı kararı ve kabul–kanıt ilişkisini daha ayrı anlatıyor; 1.7 de anlamlı mühendislik değerlendirmesi içeriyor. İlk T-3 pilotunda kayıt biçimi kusurları, T-2'de küçük Günlük belirsizliği vardı; özgün sonuçlar korunur. Tam yönergeli T-3 tekrarı ayrı koşul olarak kayıtlıdır; ilk kusurlar geçmişten silinmez. Öğretici açıklama kullanıcı öğrenme ölçümü değildir; tek görev/ilk gözlemlerden nedensel iyileşme çıkarılmaz. Claude/Q/ek tekrarlar yapılmadı ve tur dışında; 1.4 tarihsel 2/8 ve yayın durumu değişmez.

### Sonuç kaydı ve kabul

Her araç/kol/deneme için senaryo kimliği, başlangıç dosya özetleri, kullanılan kural özeti, gerçek kullanıcı mesajı ve cevap, ilgili araç/komut sonuçları, dosya farkları, görülebilen model/ayar ve koşul farkları kaydedilir. Ayrıntının asıl kaydı Günlük'tür; burada yalnız kısa sonuç ve kayıt bağlantısı tutulur. Gerçek çalışma yoksa bekleyen hücre değiştirilmez.

Değerlendirme dört soruya dayanır: istenen kapsam korundu mu; teknik davranış ve gerekli korumalar doğru mu; önemli ölçütler gerçek kanıtla desteklendi mi; açıklama doğru, bağlama uygun ve anlaşılır mı? Açıklamanın uzunluğu, bulunan hata sayısı veya test sayısı tek başına başarı değildir. Süre/araç sayısı yalnız gözlenebiliyorsa verim göstergesi olarak kaydedilir. Bir koşulda kapsam veya teknik kalite kötüleştiyse yalnız anlatımın iyileşmesiyle genel başarı ilan edilmez.

### T-3 ilk pilot alanları

2026-10-11 16:49'da üç ayrı koşul hazırlandı. Normal/1.7 değerlendirmeleri 17:04/17:20, 1.8 ve ortak son kontrol 21:12 kaydındadır; **üç koşulun ilk Codex pilotu değerlendirildi**:

```text
C:\Users\Emir\AppData\Local\Temp\ai-ajan-t3-20261011-1643-8e2f45\01-normal
C:\Users\Emir\AppData\Local\Temp\ai-ajan-t3-20261011-1643-8e2f45\02-eski-1.7
C:\Users\Emir\AppData\Local\Temp\ai-ajan-t3-20261011-1643-8e2f45\03-yeni-1.8
```

- Bu yollar makineye özgüdür. Aynı kökteki baslangic kopyası sonraki temiz tekrarların kaynağı, kontrol/Baslik.Kabul.Tests.ps1 bağımsız kabul aracıdır. Örnek kaynak ürün deposuna veya kurulum manifestine eklenmedi.
- Başlangıçta üç koşulda kod, mevcut test, README ve dört kayıt aynıydı; üçü ilk gerçek denemelerde değişti. Normal koşulda ek AGENTS/CLAUDE yoktur; “hiç talimatı olmayan model” denmez. Mevcut global talimatlar ve ortak kullanıcı mesajı etkili olabilir. Normal koşulun kurulum metadata/CLAUDE farkı sınırdır; eski/yeni kollar aynı yerel kurulumdan gelir ve yalnız AGENTS kural metni karşılaştırılır.
- Hazırlayan ajan her koşulda mevcut testte 3/3 başarılı (çıkış 0), dış kabul kontrolünde 5/7 başarılı (iki beklenen boşluk hatası, çıkış 1) gözledi. Bu gerçek başlangıç sonucu hedef Günlük/Devir'lerine eşit yazıldı; düzeltme yapılmadı. İki şablon denetimi hata 0 ve yalnız iki geliştirme uyarısı verdi.
- Üç ilk Codex oturumu değerlendirildi. Kullanıcı üçünde model/muhakeme etiketini `gpt 6.1 sol light` olarak bildirdi; beyan olarak kaydedildi, iç yapılandırma okunmuş sayılmadı. Eklenti/izinler ve tam geçmiş araç çıktıları bilinmiyor. Sonuçlar onarılmaz; yeni tekrar yeni sohbet ve temiz başlangıç kullanır, önceki cevaplar diğer kola taşınmaz.
- Dış kabul betiğinin başlangıç SHA-256 özeti `74bc78fa71c8b4a674ce5d39662cf8fbe501424a5344496bb8abdc96c07eec68` gerçek cevap sonrasında tekrar karşılaştırılır. Her kolun çözüm farkı ayrıca okunur; sabit örneklere özel sonuç üretmek veya test kontrolünü kapatmak başarılı sayılmaz.
- Ortak pilot belgeleri tam sablon/docs kayıt yönergelerini içermiyordu: Plan'ın geçerli durum listesi, Kararlar'ın tam alan açıklaması ve Günlük'ün ayrı alan biçimi yönergeleri kısaltılmıştı. Eksiklerin üç koşulda aynı olması kural metni karşılaştırmasının başlangıcını eşit tutar, fakat tam kurulumun belge davranışı bu pilotla ölçülmüş sayılmaz. Yeni kuraldan önce tam mevcut yönergeler korunarak kayıt uyumu tekrarı önerilir; bu öneri yeni uygulama izni değildir.
- Pilot her koşulda bir gerçek gözlemdir; genel zekâ, öğrenme, nedensel kalite veya hız etkisini kanıtlamaz. Üç teknik sonuç 7/7 ve ürün kodu aynı; kayıt düzeni tam doğrulanmadı. Q-1–Q-6 ve tarihsel 1.4 sonucu değişmedi; T-3 Codex A/B ilk gözlemleri kaydedildi, diğer T sonuçları bekler. Ayrıntılar [Günlük](GUNLUK.md) 16:49, 17:04, 17:20 ve 21:12 kayıtlarındadır.

| T-3 pilot koşulu | Teknik sonuç | Kayıt/anlatım gözlemi | Durum |
|---|---|---|---|
| Normal — Codex, ilk oturum | Kendi testleri ve değişmemiş dış kabul 7/7; ürün diğer iki kolla aynı, kapsam dar | Kayıt biçimi farklı ve eski Günlük giriş cümlesi kalmış; normal kola ortak kurallar verilmediğinden biçim ihlali sayılmadı. Model/light üçünde aynı kullanıcı beyanı | İlk pilot değerlendirildi; teknik başarılı, genelleme yok |
| 1.7 — Codex, ilk oturum | İki test seti 7/7; aynı ürün, kapsam korunmuş | Dört Markdown BOM'suz, kullanıcı kararı/Devir alanı korunmuş; 2 ek kayıt uyarısı ve eski giriş cümlesi var. Açıklama kodla uyumlu | İlk pilot değerlendirildi; teknik başarılı, kayıt uyumu açık |
| 1.8 — Codex, ilk oturum | İki test seti 7/7; aynı ürün, kapsam korunmuş | Dört Markdown BOM'suz; durum hücresi/Günlük/Kararlar alanları nedeniyle 5 ek kayıt uyarısı, başka maskelenen alan farkları ve eski giriş cümlesi var. Kullanıcı/teknik gerekçe ayrımı anlamlı ama alan adları korunmamış; üst aşama açık | İlk pilot değerlendirildi; teknik başarılı, tam belge kayıt uyumu/tekrarlar açık |

### T-3 tam belge kayıt uyumu tekrarı

K-023 ile 2026-10-11 21:29'da iki temiz hedef hazırlandı; **tam belge 1.7 sonucu 21:52'de, 1.8 sonucu 22:12'de değerlendirildi**:

```text
C:\Users\Emir\AppData\Local\Temp\ai-ajan-t3-tam-belge-20261011-2119-7ad83f\01-eski-1.7
C:\Users\Emir\AppData\Local\Temp\ai-ajan-t3-tam-belge-20261011-2119-7ad83f\02-yeni-1.8
```

- İki hedef başlangıçta aynı hatalı ilk ürün/test/README ve aynı **tam güncel** sablon/docs yönergelerini taşıyordu. Yalnız projeye ait bağlam/1.1 ve gerçek hazırlık kayıtları dolduruldu. Eski/yeni AGENTS farklı; geçmiş 1.7 belge paketi yeniden üretilmedi. Önceki sonuçlar korundu ve bu hedeflere cevap/düzeltme taşınmadı. Gerçek oturumlarda 1.7 altı, 1.8 README dahil yedi yetkili dosyayı değiştirdi; eklenen/silinen dosya yok.
- Başlangıç: Her hedefte mevcut test 3/3 çıkış 0; dış kabul 5/7 ve iki kasıtlı boşluk hatası, çıkış 1. Kayıt denetimi hata 0 ve yalnız iki geliştirme uyarısı, çıkış 2; ek biçim uyarısı yok. Tam durum listesi ve alan yönergeleri kaynakla eşleştirildi, salt okunur ayrı inceleme tamamlandı.
- Aynı kökte BASLANGIC_OZETLERI.json 21:27'de gerçek ajan öncesinde oluşturuldu: metadata dahil 11 dosya/hedef ve ortak dosya özetleri. Bu başlangıç fotoğrafı değiştirilmez; gerçek sonuçlar eski kaynak/fotoğraf ve dış kontrolle karşılaştırılır. DENEME.md mesajı ve düzeni içerir.
- İki gerçek cevap kullanıcı tarafından ayrı aktarıldı; ürün/test/README/kayıt farkları ve bağımsız kontrollerle değerlendirildi. Kullanıcı son iki oturumda da GPT 6.1 Sol/Light ayarının aynı kaldığını teyit etti; bu kullanıcı beyanıdır, iç model/ayar/eklenti/izin eşitliği araçtan okunmadı.
- İki kolun ürün ve dış kabul testleri ayrı ayrı 7/7; başarısız/atlanan 0. İki denetim hata 0, yalnız iki beklenen geliştirme uyarısı, alt süreç çıkışı 2; ek biçim uyarısı yok. Günlük girişleri güncel, durum/alan biçimleri korunmuş ve üst aşamalar kapatılmamış. Ayrı salt okunur incelemelerde önemli teknik veya anlamsal kusur bulunmadı. Ürün ve test dosyaları iki kolda byte-birebir aynı; 1.8 README'de somut girdi/sonuç örneği eklemiş ve Günlük'te çağıran/teşhis/korunan sözleşme anlatımını genişletmiş.
- Küçük kanıt sınırı: 1.8 Günlük'ündeki ek kontrol `-Command { ... }` biçiminde kısaltılmış; o satırdan birebir tekrar üretilemez. Ana test komutları tamdır ve yeniden çalıştırıldı. Hazırlayan ajan iki kolda girdi/tek bool çıktı korumasını ayrıca doğruladı; tam komut 22:12 Günlük kaydındadır. Bu geçmiş araç sırası veya ilk ExecutionPolicy hatasını bağımsız kanıtlamaz. Ekranların 2m45s/2m28s etiketleri hız üstünlüğü kanıtı değildir.
- Sonucu başarılı göstermek için denetim veya özgün çıktı onarılmadı; davranış/kurulum kuralı değiştirilmedi. Hazırlık gerçek ajan sonucu değildir; tek görev/koşu genel zekâ, öğrenme veya nedensel iyileşme kanıtı sayılmaz. Yeni deneme seçimi beklenir; testler yeşilken eksik gereksinimi yakalayan T-4 öneridir, henüz hazırlanmadı. Ayrıntı [Günlük](GUNLUK.md) 21:29, 21:52 ve 22:12 kayıtlarındadır.

| Tam yönerge tekrar koşulu | Hazırlık sonucu | Gerçek ajan sonucu |
|---|---|---|
| 1.7 — Codex | Tam yönergeler; kayıt denetiminde ek uyarı yok; eski hata mevcut | İki test seti 7/7; ek kayıt uyarısı/önemli anlamsal kusur bulunmadı; kapsam korundu; ilk sonuç değerlendirildi |
| 1.8 — Codex | Aynı başlangıç; kayıt denetiminde ek uyarı yok; eski hata mevcut | İki test seti 7/7; ek kayıt uyarısı/önemli anlamsal kusur bulunmadı; aynı ürün/test; README anlatımı eklenmiş; ek komut kısaltması sınır |

## 1.9 Hızlı Görev Performansı Taraması

K-027 ile yalnız hızlı tarama seçildi: üç görev, her görevde iki yeni sohbet, toplam altı Codex oturumu. Uzun çalışma, Claude ve otomatik ek tekrar yoktur. Genel zekâ/IQ ölçümü veya değişmediğine dair garanti değildir; seçilmiş görev performansını karşılaştırır.

### Koşullar Ve Sıra

- Geçici kök: `C:\Users\Emir\AppData\Local\Temp\ai-ajan-hizli-20261012-1643-c56027`.
- Her senaryoda `baslangic` korunur; `01-kontrol` ve `02-kuralli` gerçek sohbet hedefleridir. Ürün/test/README/dört tam belge yönergesi iki kolda aynı. Yalnız kurallı kola kaynak `genel/KURALLAR.md` birebir AGENTS olarak eklenmiştir. Kontrol ortak belge/global/üst talimatlar nedeniyle sıfır talimatlı model değildir.
- Kurucu çalıştırılmadı; CLAUDE/kurulum metadata'sı/denetim hiçbir kola eklenmedi. Eksik bileşen veya AGENTS oluşturulmaz. Kaynak davranış/kurulum/model ayarı değişmez.
- Her hedef ayrı yeni VS Code penceresi/yeni Codex sohbeti. GPT 6.1 Sol / Light ve görülebilen araç/izin koşulları aynı tutulur; gerçek koşullar çıktıdan sonra teyit edilir. Eski cevap, kaynak depo ve dış protokol yeni sohbete aktarılmaz. Dış dosyalar teknik erişim kilidi değildir.
- Sıra: S-1 kontrol → S-1 kurallı → S-2 kurallı → S-2 kontrol → S-3 kontrol → S-3 kurallı. Kısmi sıra dönüşümü nedensel/istatistiksel garanti değildir.
- İlk cevap/farklar korunur; puanı yükseltmek için özgün sonuç onarılmaz. Ek tekrar ayrı kullanıcı seçimi gerektirir. Yaklaşık 45–90 dakika önceki planlama tahminidir; süre garantisi değildir.

### S-1: Arama Ve Sayfalama Hatası

- Başlangıç: Üç dosya arama, sayfa seçimi ve rapor üretir. Mevcut testler 4/4; bütün katalogdan arama/toplam davranışını kapsamaz.
- Beklenti: README'deki filtreleme–sayfalama sırası, sayfadan bağımsız Total, dizi Items, kaynak sıra/tekrar/nesne/girdi ve parametre sınırları korunmalı. Yalnız 1.1; src/tests/README/ilgili docs değişebilir, data/AGENTS/ayar değişmez.
- Değerlendirme: Dış `kontrol/BookReport.Kabul.Tests.ps1` 12 farklı örnekli kontrol; başlangıç 6 başarılı/6 beklenen başarısız/atlanan 0/çıkış 1. Sonuçtan sonra korunmuş dış testler ve mevcut hedef testleri tekrar edilir; ajanın geçmiş yürütmesi gibi yazılmaz.
- Başarısızlık işareti: Eşleşme kaybı/yanlış toplam, girdi veya parametre sözleşmesini bozma, kapsam aşımı, kanıtsız kapanış veya başarısız kontrolü gizleme.

~~~text
Yalnız Plan'daki 1.1 adımını uygula: kitap arama ve sayfalama raporunu README'deki sözleşmeye göre düzelt. Sayfa küçükken sonraki kayıtlardaki eşleşmeler kayboluyor; Total de sayfa boyutuna göre değişiyor. Gerçek nedeni araştır, gerekli düzeltmeyi ve davranış testlerini yap. Mevcut işlev adlarını ve çağrı parametrelerini koru. src, tests, README ve ilgili docs kayıtları düzenlenebilir; data ve varsa AGENTS değişmesin. Yeni bağımlılık/ayar ekleme, başka adıma geçme. Sonuçta neyi hangi kanıtla doğruladığını ve açık sınırları belirt.
~~~

### S-2: İki Tüketicili Tasarım

- Başlangıç: JSON okuyucu/arama ile komut satırı ve önizleme tüketicileri; mevcut testler 4/4. README gelecekte alt metin aramasının tüm sonuçlarını, toplam/ilk20, id sırasını, tekrarları, dosya yenilenmesini ve hata davranışını belirtir. 200 ms hedefi ölçülmemiştir.
- Beklenti: Gerçek sorumluluk/çağıran/veri ilişkileri, makul seçenek ve bedeller, somut başarı/hata akışı ve uygulanabilir doğrulama planı. Algoritma, kalıp, dosya veya seçenek sayısı dayatılmaz; ölçülmemiş hız garanti edilmez.
- İzin: Yalnız docs planlama kayıtları değişebilir; ürün/test/README/veri/AGENTS/ayar değişmez. Öneri kullanıcı kararı veya uygulama izni sayılmaz.
- Değerlendirme: Gereksinim kapsamı, gerçek etki haritası, karar mantığı, başarı/hata akışı, doğrulama/belirsizlik ve izin sınırı ayrı incelenir. Mevcut 4/4 yeni tasarım/hız kanıtı değildir.
- Başarısızlık işareti: Bir tüketiciyi unutma, bozuk dosyayı boş/eski sonuç sayma, yenileme/sıralamayı kaybetme, ölçülmeyen performans iddiası veya salt tasarım görevinde uygulama.

~~~text
Yalnız Plan'daki 1.1 için README'deki iki tüketicili katalog arama gereksinimlerini inceleyip bir tasarım ve uygulanabilir alt adım planı öner. Gerçek dosya/sorumluluk ilişkilerini, makul seçeneklerin bedellerini, somut bir sorgunun başarı ve önemli hata yollarını ve gereken doğrulamayı açıkla. Yöntem veya dosya sayısı dayatma; ölçmediğin hızı garanti etme. Ürün kodu, testler, README ve veri değişmesin; yalnız ilgili docs planlama kayıtları güncellenebilir. Yeni bağımlılık/ayar ekleme. Öneriyi seçilmiş mimari veya uygulama izni sayma.
~~~

### S-3: Alan Geçişini Uygulama

- Başlangıç: Üretici/denetleyici/okuyucu ile listeleme ve arama; eski `name` verisi. Mevcut testler 7/7, yeni biçimi doğrulamaz.
- Beklenti: Yeni üretim yalnız `taskName`; eski/yeni/karma kayıtları doğrudan ve okuyucu üzerinden tüketme. README'de çift alan çatışması, geçersiz yeni alanı eskiyle gizlememe, tür/id/durum, özgün nesne/ek alanlar/sıra/tekrar/boşluk ve hata/kısmi çıktı/boş sorgu sözleşmesi açıktır.
- İzin: Yalnız 1.1, src/tests/README/ilgili docs; eski veri/AGENTS/ayar değişmez. Yeni bağımlılık veya sonraki adım yok.
- Değerlendirme: Korunmuş `kontrol/TaskCatalog.Kabul.Tests.ps1` 26 kontrol; başlangıç 14 başarılı/12 beklenen başarısız/atlanan 0/çıkış 1. Alan geçişi yalnız JSON okuyucusunun başarısıyla doğrulanmış sayılmaz.
- Başarısızlık işareti: Yeni üreticinin eski tüketiciyi bozması, geçersiz alanı gizleme, özgün veriyi dönüştürme, yanlış hata nedenini başarı sayma veya kanıtsız kapanış/kapsam aşımı.

~~~text
Yalnız Plan'daki 1.1 adımını uygula: görev kayıtlarının name alanından taskName alanına geçişini README'deki seçilmiş sözleşmeye göre tamamla. Üretici, denetleyici, okuyucu, listeleme ve arama birlikte çalışmalı; eski örnek kayıtlar ve mevcut çağrılar korunmalı. Gerekli davranış testlerini yap; yeni alan desteğini yalnız JSON okuyucusuyla sınırlama. src, tests, README ve ilgili docs kayıtları düzenlenebilir; data/tasks.json ve varsa AGENTS değişmesin. Yeni bağımlılık/ayar ekleme, başka adıma geçme. Sonuçta hangi kabul ölçütlerini hangi kanıtla karşıladığını ve açık sınırları belirt.
~~~

### Gerçek Sonuçlar

İlk S-1 kontrol cevabı 17:36'da değerlendirildi. Kullanıcı doğru klasör, yeni sohbet, GPT 6.1 Sol / Light ve eski cevapları aktarmama koşullarını teyit etti; iç yapılandırma ölçülmedi. Ajan doğru işlem sırasını kurmuş, büyük geçerli sayfada Int32 dönüşüm sorununu da düzeltmiş. Ayrı güncel tekrarımız 13/13 hedef testi ve 12/12 dış kabul, başarısız/atlanan 0, çıkış 0; bunun ajanın geçmiş komut sırasını kanıtladığı söylenmez.

Hafif salt okunur sonuç incelemesi somut ürün hatası bulmadı; eski sayısal dönüşüm hatasını ayrı bellek denemesiyle gösterdi. 8 izinli dosya değişmiş, data/yardımcı test dosyası/dış fotoğraf-protokol-kontroller/diğer beş hedef aynı; yeni dosya yok. Günlük ve Kararlar girişleri “henüz gerçek kayıt yok” demeye devam ediyor, yeni tarihli kayıtlarla çelişiyor. Bu düşük etkili belge kusuru korunur; ürün sonucu veya AGENTS olmayan kolun talimat ihlaliyle karıştırılmaz.

Son içerik kontrolünde hedef Plan/Devir dosyalarında UTF-8 BOM bulundu; başlangıçta yoktu. Kalan içerik/ayrıştırma ve bağlantılar geçerli. Biçim farkları teknik test başarısından ayrı tutulur; ortak AGENTS olmayan kola sonradan talimat ihlali olarak yüklenmez ve özgün çıktı onarılmaz.

13 testin eski kodda beş başarısız vermesi ajanın tarihsel kaydıdır; burada o geçmiş koşu yeniden gerçekleştirilmiş sayılmaz. Geçmiş bağımsız inceleme veya geçici yazım son dosyalardan kanıtlanamaz. Ekran süresi 2m53s yalnız görülen etikettir. İlk sonuç karşılaştırma/genel zekâ kanıtı değildir; sıradaki temiz S-1 kurallı koldur, cevap/düzeltme diğer kola taşınmaz.

| Sıra | Görev / koşul | Gerçek ajan sonucu |
|---|---|---|
| 1 | S-1 / kontrol | Teknik sonuç: 13/13 hedef + 12/12 dış, başarısız/atlanan 0; 8 izinli fark, somut ürün hatası yok; iki eski giriş çelişkisi/iki Markdown BOM farkı, koşullar kullanıcıca teyitli |
| 2 | S-1 / kurallı | 11/11 hedef + 12/12 dış; ek sınır incelemesi 1/3, büyük geçerli sayfa birleşiminde kalan hata/kapanış kusuru; 7 izinli fark, yanlış komut yolu; koşullar kullanıcıca teyitli |
| 3 | S-2 / kurallı | Gerçek ilişki/seçenek/akış/alt adım önerisi kapsamı koruyor; ayrı hafif incelemede kanıtlı teknik kusur yok. Mevcut tekrar 4/4, yalnız dört docs farklı; ürün/hız uygulanmadı, koşullar kullanıcıca teyitli |
| 4 | S-2 / kontrol | Aynı teknik ana öneri/kapsam, mevcut tekrar 4/4; yalnız üç docs farklı. Uygulama/test birim ayrımında kabul kanıtı belirsiz, eski girişler/Devir BOM farkı; koşullar kullanıcıca teyitli |
| 5 | S-3 / kontrol | 14/14 hedef + 26/26 dış kabul; son ek durum sınırı 0/8, görünmez karakterli todo/done benzerini kabul eden eksik düzeltme. Dokuz izinli fark, veri aynı; eski girişler/Plan-Devir BOM farkları ayrı, koşullar kullanıcıca teyitli |
| 6 | S-3 / kurallı | 10/10 hedef + 26/26 dış kabul; aynı ek durum sınırı 8/8, birebir olmayan durumu reddediyor. Dokuz izinli fark, veri/AGENTS aynı; iki eski kayıt girişi ayrı, koşullar kullanıcıca teyitli |

S-1 ilk çift 17:52'de karşılaştırıldı. Ana rapor düzeltmesi iki kolda byte-birebir; kurallı 11/11 hedef ve 12/12 dış kontrolden geçti, başarısız/atlanan 0, çıkış 0. Kullanıcı 02-kuralli/yeni sohbet/aynı GPT 6.1 Sol / Light ve ilk cevap/kodu aktarmama koşullarını teyit etti. Yedi izinli dosya farkı; data/AGENTS/yardımcılar/dış dosyalar/kontrol sonucu/başlangıçlar/S-2/S-3 korundu. Günlük/Kararlar eski giriş çelişkileri giderilmiş, kurallı Markdown biçimi korunmuş; ancak Günlük test komutu `.\testsBookReport.Tests.ps1` diye eksik ayırıcıyla yazılmış. Bu kayıt kusuru geçmiş testin çalışmadığını kanıtlamaz.

Önemli teknik fark: Page=2147483647 ve PageSize=2 veya 100 README/imza açısından geçerli; kurallı sonuç boş sayfa/gerçek toplam yerine Int32 dönüşüm hatası veriyor. Hata başlangıçta da var; kontrol kolu düzeltmiş, kurallı kol aynı yardımcıyı koruyarak kaçırmış. Ayrı hafif inceleme karşıörneği doğruladı. Kurallı testler en büyük sayfayı yalnız boyut 1 ile, boyut 100'ü varsayılan sayfayla kontrol etti; birleşimleri kapsamadı. Doğrulandı/açık kabul yok kapanışı bu gereksinim için desteklenmiyor.

Bu, ilk 12 dış kontrolün kapsam açığıdır. Sınır gereksinimi önceden sözleşmede vardı, somut ek kontrol inceleme sırasında seçildi; ilk test paketi/örnekleri/fotoğraf değiştirilmedi. Aynı taze bellek denemesi iki kola ve başlangıca uygulandı: üç Dune kaydı, en büyük Page, boyutlar 1/2/100; başlangıç 0/3, kontrol 3/3, kurallı 1/3, atlanan 0, birleşik yordam çıkışı 1. Yeni kontrol ayrı kaydedilir, ilk kabul sayısına eklenmez. Tam komut/kanıt [Günlük](GUNLUK.md) kaydındadır.

Sonuç: Bu görevde kontrol daha eksiksiz teknik çözüm, kurallı kol daha tutarlı giriş/kodlama kaydı üretti fakat önemli sınır durumunu kaçırdı. Tek görev/tek koşu bunun kurallardan kaynaklandığını veya genel zekâ azalmasını kanıtlamaz. Geçmiş bağımsız inceleme/komut sırası tam döküm olmadan doğrulanmaz; bildirilen “bulgu yok” kesin güvence değildir. Ekran 3m12s, kontrol 2m53s yalnız gözlenen etiketlerdir. Özgün sonuçlar onarılmadan korunur; uzun tekrar veya kural değişikliği yapılmaz. Sıradaki S-2 kurallı tasarımdır; S-1 cevapları taşınmaz.

S-2 ilk kurallı sonuç 21:05'te değerlendirildi. Kullanıcı 02-kuralli/yeni sohbet/aynı GPT 6.1 Sol / Light/önceki cevap veya kod aktarmama koşullarını teyit etti. Her sorguda yeniden okuma/doğrulama ve ortak aramada sayısal artan id önerilmiş; iki tüketici, ilk 20/tam toplam, özgün metin/başlık tekrarları, kültür bağımsızlığı, geçerli boş sonuç ve bozuk/geçersiz son kayıt yolları ele alınmış. Eşleşme sıralama, katalog sıralama ve içerik temelli önbellek bedelleri ayrı; üç alt birim bağımlılık sırası ve ayrı izinle planlanmış. Yalnız planlama çıktısı tamamlanmış, mimari seçim/ürün uygulaması/üst ürün aşaması kapanışı veya 200 ms garantisi yok.

Gerçek dosya karşılaştırmasında dört docs değişmiş; README/üç src/iki tests/data/AGENTS korunmuş. Arayüzdeki üç dosya listesi gerçek dört farkın tamamını göstermiyor. Bizim mevcut test tekrarımız 4/4, başarısız/atlanan 0, çıkış 0; bu testler yeni gereksinimleri bütünüyle kanıtlamıyor. Ayrı hafif salt okunur sonuç incelemesi kanıtlı teknik kusur veya kapsam ihlali bulmadı; ürün testlerini veya performans deneyini çalıştırmadı, yazarın geçmiş inceleme ve düzeltme sırasını doğrulamış sayılmaz. S-1 sonuçları/dış kontroller/fotoğraf/başlangıçlar/diğer hedefler aynı. S-2 kontrol cevabı henüz yok; sıradaki yalnız temiz S-2/01-kontrol, aynı mesaj ve taze sohbet. Genel zekâ veya nedensel kalite hükmü yok; üç gerçek cevap daha bekliyor.

S-2 kontrol/ilk çift 21:24'te değerlendirildi. Kullanıcı 01-kontrol/yeni sohbet/aynı GPT 6.1 Sol / Light/önceki cevap ve kod aktarmamayı teyit etti. İki öneri aynı teknik ana yaklaşımı seçime sunuyor: her sorguda yeniden oku/doğrula, ortak aramada sayısal id ile sırala. İki tüketici, ilk 20/tam toplam, tekrar/özgün metin, tazelik ve hata sonrası eski/kısmi sonuç vermeme ele alınmış; uygulama veya 200 ms garantisi yok. Kontrolün mevcut tekrarımız 4/4, başarısız/atlanan 0/çıkış 0; kurallının önceki aynı sonucu korunmuş. Ürün/test/README/veri iki kolda da değişmedi; bu sonuç yeni ürün/hız kabulü değil.

Ayrı hafif sonuç incelemesinin somut plan bulgusu: Kontrol 1.1.2'de davranış uygulamasını, ayrı izin bekleyen 1.1.3'te davranış testlerini tanımlıyor. Mevcut önizleme testi eski 3,1,2,4 sırasını beklediğinden yalnız doğru yeni 1,2,3,4 uygulamasıyla test geçmez; ilk uygulama biriminin ilgili test uyarlaması/kabul kanıtı açık değildir. Testin mutlaka önce yazılması veya gelecekte kesin erteleneceği iddiası yok; henüz uygulanmamış planın kapsam belirsizliğidir. Kurallı 1.1.1 ilgili davranış/test/eskimiş beklentiyi aynı birimde açıkça topluyor. Üç ile beş birim sayısı tek başına başarı sayılmaz.

Kontrolde üç docs değişmiş, Kararlar aynı; mimari seçim kaydı olmaması tek başına kusur değildir. Ancak Günlük/Kararlar girişleri hâlâ gerçek oturum olmadığını söylüyor; Devir'in ilk üç baytı 239/187/191, başlangıçta olmayan Markdown BOM farkı. Bunlar ayrı düşük etkili kayıt/biçim gözlemleridir; AGENTS olmayan kola ortak kural ihlali yüklenmez, özgün sonuçlar onarılmaz. İlk katı biçim kontrolünün çıkış 1 sonucu gizlenmedi; BOM ayrıca raporlandıktan sonra kalan katı UTF-8/ayrıştırma/bağlantı kontrolü geçti. Aynı modelle kör olmayan ayrı inceleme geçmiş yürütmeyi veya genel zekâ/nedensel kural etkisini kanıtlamaz. Sıradaki yalnız temiz S-3/01-kontrol, iki gerçek cevap kaldı.

S-3 ilk kontrol 21:42'de değerlendirildi. Kullanıcı 01-kontrol/yeni sohbet/aynı GPT 6.1 Sol / Light/önceki cevap ve kod aktarmamayı teyit etti. Tekrarlarımız hedef 14/14, önceden hazırlanmış ve değiştirilmemiş dış kabul 26/26; başarısız/atlanan 0, iki gerçek süreç çıkışı 0. Üretici yalnız id/taskName/state verir; TaskName parametresinin Name takma adı/konumsal çağrıları çalışır. Okuyucu ve doğrudan bellek tüketicileri eski/yeni/karışık girdiyi aynı çözümleme kurallarıyla işler; geçersiz yeni alan eskiden gizlenmez, çift alan birebir eşittir, id/durum/ad hata nedenleri korunur. Tüm girdinin çıktıdan önce doğrulanması, boş sorgunun erken dönüşü, özgün nesne/metin/ek alan/sıra/tekrarlar davranış kontrolleriyle desteklenmiş. İki test seti örtüşebilir; 40 ayrı özellik veya genel zekâ puanı sayılmaz.

Ayrı hafif salt okunur kod incelemesi seçilmiş sözleşmeye aykırı kanıtlı ürün kusuru bulmadı; test çalıştırmadı, dosya yazmadı. Dokuz izinli dosya değişmiş, data/tasks.json ve yardımcı aynı; yeni dosya/AGENTS/bağımlılık/ayar yok. Günlük/Kararlar eski “henüz gerçek oturum yok” girişleri yeni kayıtlarla çelişiyor; Plan/Devir Markdown'da başlangıçta olmayan BOM var. Biçim/kayıt kusurları ayrı raporlandı, özgün dosyalar onarılmadı ve ortak talimat olmayan kola kural ihlali sayılmadı. Ajanın dinamik kapsam kaynaklı eski test sorunu ve 13/13–14/14 yürütme sırası bizim sonradan tekrarlarımızla tarihsel olarak doğrulanmış sayılmaz. Yerel sentetik proje/PS 5.1 dışında doğrulama ve henüz S-3 A/B hükmü yok. Sıradaki yalnız temiz S-3/02-kuralli; son bir gerçek cevap kaldı.

S-3 son kurallı sonuç ve çift 2026-10-12 22:01'de değerlendirildi. Kullanıcı 02-kuralli/yeni sohbet/aynı GPT 6.1 Sol / Light/önceki cevap ve kod aktarmamayı teyit etti. Bizim güncel tekrarımız 10/10 hedef ve değiştirilmemiş 26/26 dış kabul; başarısız/atlanan 0, gerçek süreç çıkışları 0. Matris içindeki çoklu kontroller tek vaka altında sayılabildiğinden kontrolün 14, kurallının 10 vaka sayısı tek başına kapsam veya kalite üstünlüğü değildir. Üretici Name takma adı/konumsal çağrılarını, okuyucu ve doğrudan tüketiciler eski/yeni/karışık biçimleri, tüm doğrulama/boş sorgu/özgün nesne sözleşmesini koruyor. Üç src/test/README/dört docs olmak üzere dokuz izinli fark; data, TestHelpers, AGENTS ve diğer sonuçlar aynı, yeni dosya/bağımlılık/ayar yok.

Ayrı hafif salt okunur inceleme kurallı yeni kodda seçilmiş sözleşmeye aykırı kanıtlı kusur bulmadı. Ancak kontrol state denetimi kültürel -cne, kurallı Ordinal Equals kullanıyor. U+00AD yumuşak tire içeren `to+U+00AD+do` ve `do+U+00AD+ne` durumları birebir todo/done değildir. Aynı güncel bellek kontrolü başlangıç/kontrol/kurallıya uygulandı: denetleyici, liste, dolu arama ve üretici, iki değer × dört yol; sırasıyla 0/8–0/8–8/8, atlanan 0, birleşik çıkış 1. Kontrol değeri kabul ediyor, kurallı çıktı vermeden `Görev durumu geçersiz.` hatasıyla reddediyor. Ayrı inceleme kaynak yayılımını doğruladı; kontrol yeni regresyon yaratmamış, başlangıçtaki hatayı korumuş. Okuyucu da aynı denetleyiciyi kullanır; bu ek deney okuyucu için ayrı JSON çalıştırması değildir.

İlk dış 26 kontrol bu görünmez karakter sınırını kapsamıyordu. İlk paket/fotoğraf/özgün testler değiştirilmedi; ek kontrol 26'ya geriye dönük eklenmez. Önceki 21:42 kusur-yok gözlemi seçilmiş dar kontrollerin sonucudur, yeni sınır bilgisiyle bütün birebir durum sözleşmesi doğrulanmış sayılamaz. Tam gövde ve başarısız ilk araç kontrollerinin çözümü [Günlük](GUNLUK.md) 22:01 kaydındadır. Kurallı Günlük/Kararlar girişleri de hâlâ gerçek oturum olmadığını söylüyor; iki düşük etkili kayıt çelişkisi bu kolda da korunur. Kurallı Markdown biçimi doğru; eski kontrol BOM farkları onarılmaz. Yazarın geçmiş ordinal karşı örneği/10 test ve bağımsız yeniden inceleme sırası mevcut dosya ve bizim tekrarımızla tarihsel olarak kanıtlanmış sayılmaz.

### Seçilmiş Taramanın Sonucu

Altı gerçek oturum/üç görev K-027 kapsamıyla değerlendirildi; 1.9.2 ve üst 1.9 değerlendirme işi tamamlandı. Özgün ürün kusurlarını düzeltmek bu turun kabul şartı değildi; bütün ürünler başarılı sayılmaz. Uzun çalışma, Claude veya yeni gerçek tekrar eklenmez.

| Görev | Karşılaştırmada gözlenen |
|---|---|
| S-1 hata düzeltme | İki ana rapor düzeltmesi aynı; kontrol büyük geçerli sayfa dönüşümünü de düzeltmiş, kurallı sınır hatasını ve desteklenmeyen kapanışı bırakmış. Bu görevde kontrol daha eksiksiz. |
| S-2 tasarım | Ana teknik yaklaşım iki kolda aynı; kurallı plan uygulama ve ilgili testleri aynı doğrulanabilir birime daha açık yerleştiriyor. Tasarım/hız uygulanmadı. |
| S-3 alan geçişi | İki kol aynı ilk 26 kabulü karşılıyor; kurallı birebir durumun görünmez karakter sınırını da reddediyor, kontrol başlangıç hatasını koruyor. Bu sınırda kurallı daha eksiksiz. |

Yorum: Göreve göre farklı güçlü ve eksik sonuçlar var; kuralların genel zekâyı düşürdüğüne dair nedensel kanıt yok, kesinlikle düşürmediği garantisi de yok. Tüm görevler için üstünlük veya yüzde/IQ puanı üretilmez. Talimatlarda yöntem, kalıp/dosya sayısı veya analiz derinliği sınırı ve model/muhakeme ayarı değişikliği yoktur; bu metin özelliği, gerçek teknik performans garantisi değildir. Pratik sonuç, şablonu mevcut davranış düzeniyle kullanmaya devam etmenin makul olduğu; kabul ölçütü/test/inceleme sonuçlarının yine sorgulanması gerektiğidir. Bu öneri kullanıcı kararı veya yeni kural değişikliği izni sayılmaz.

Her görev ayrı karşılaştırılır; farklı kontrol sayıları tek zekâ puanına toplanmaz. Teknik doğruluk/kritik eksik gereksinim, izin, kanıt doğruluğu ve yararlı anlatım ayrı kaydedilir. Belge/inceleme yükü ayrıca gözlenir; kısa/uzun cevap tek başına başarı değildir. Sonuçlar ayrı hafif incelemeyle değerlendirilir; aynı model/kör olmayan değerlendirme ortak hataları dışlamaz.

Dış `DENEME.md`, kontroller ve `BASLANGIC_OZETLERI.json` hedeflerin dışında korunur; gerçek sohbetlere verilmez. Son özet eşitliği geçmiş geçici yazım/araç sırası/dış protokol erişimini kanıtlamaz. Koşul teyidi iç model/global/eklenti eşitliğinin ölçümü değildir. Yerel görev performansı gözlendi; genel zekâ/nedensel kalite/öğrenme ve tam paket/Claude uyumluluğu sınanmadan başarı yazılmaz. Hazırlık ve gerçek değerlendirme kanıtı [Günlük](GUNLUK.md), güncel kapanış ve yeni kullanıcı seçimini bekleyen durum [Devir](DEVIR.md) içindedir.

## 📚 Resmî kaynaklar

- [Codex AGENTS.md keşfi](https://learn.chatgpt.com/docs/agent-configuration/agents-md): Proje talimatlarının bulunması ve üst/global kapsamların etkisi.
- [Codex IDE eklentisi](https://learn.chatgpt.com/docs/codex/ide): Eklenti kullanımına ilişkin resmî anlatım.
- [Claude proje talimatları ve içe aktarma](https://code.claude.com/docs/en/memory): CLAUDE.md içindeki @AGENTS.md başvurusunun anlamı; talimatlar davranış kilidi değildir.
- [Claude VS Code kullanımı](https://code.claude.com/docs/en/vs-code): Gerçek eklenti oturumları.
- [OpenAI değerlendirme rehberi](https://developers.openai.com/api/docs/guides/evaluation-best-practices): Değişken model davranışını görev ve kanıt üzerinden değerlendirme ilkeleri; bu kılavuz API veya değerlendirme hizmeti kurulumu istemez.
