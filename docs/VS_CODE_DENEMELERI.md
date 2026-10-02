# 🧪 VS Code davranış denemeleri — 1.4

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

## 📚 Resmî kaynaklar

- [Codex AGENTS.md keşfi](https://learn.chatgpt.com/docs/agent-configuration/agents-md): Proje talimatlarının bulunması ve üst/global kapsamların etkisi.
- [Codex IDE eklentisi](https://learn.chatgpt.com/docs/codex/ide): Eklenti kullanımına ilişkin resmî anlatım.
- [Claude proje talimatları ve içe aktarma](https://code.claude.com/docs/en/memory): CLAUDE.md içindeki @AGENTS.md başvurusunun anlamı; talimatlar davranış kilidi değildir.
- [Claude VS Code kullanımı](https://code.claude.com/docs/en/vs-code): Gerçek eklenti oturumları.
