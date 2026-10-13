# Şablon kararları

Bu dosya şablon deposunun karar geçmişidir; hedef projeye kopyalanmaz. Aşağıdaki tarih, kullanıcının eski mesajlarının zamanı değil, kararların dosyaya geçirilme zamanıdır.

## K-001 — Proje içinde sabit kurulum

- Kayıt zamanı: 2026-10-01 23:57.
- Kullanıcı kararı: Belirli GitHub sürümünden alınan şablon yerel PowerShell betiğiyle hedef proje içine kurulacak.
- Kullanıcının gerekçesi: Mevcut skill ve kurulum dosyaları ilk kurulduğu gibi kalmalı; eski projeler başlangıç düzenini korumalı.
- Etki: Global ayar veya skill değişmez. Merkezi dosyaya canlı bağlantı ve otomatik güncelleme olmaz. Kurucu ağ/Git işlemi yapmaz.

## K-002 — Tek alt adım ve açık uygulama yönlendirmesi

- Kayıt zamanı: 2026-10-01 23:57.
- Kullanıcı kararı: Genel yol haritasından sonra yalnız seçilen aşama ayrıntılandırılır; uygulama tek seçilmiş alt adımla sınırlıdır.
- Kullanıcının gerekçesi: Orta/büyük projelerde karmaşıklığı yönetmek ve projeye hakimiyetini kaybetmemek.
- Etki: Plan kabulü uygulama izni sayılmaz. Yetkili alt adımın gerekli dosyaları, testleri ve kayıtları tamamlanınca ajan durur.

## K-003 — Ortak repo kayıtları

- Kayıt zamanı: 2026-10-01 23:57.
- Kullanıcı kararı: Plan, Kararlar, Günlük ve Devir ayrı dosyalarda tutulur; Codex ve Claude aynı kayıtları okur.
- Kullanıcının gerekçesi: Araç değişiminde ve geçmiş işlerin kaydında yaşanan unutma sorununu azaltmak.
- Etki: Durumun kaynağı Plan'dır; karar ve test geçmişi kendi belgelerindedir. Devir yeniden yazılır. Kayıttaki sonraki adım izin sayılmaz.

## K-004 — Elle denetim ve projeye uygun doğrulama

- Kayıt zamanı: 2026-10-01 23:57.
- Kullanıcı kararı: İlk sürümde hook veya yeni paket kurulmaz. Mevcut araçlar kullanılır; test dosyaları özellik/modül sorumluluğuna göre düzenlenir.
- Gerekçe: Kabul edilen plan bu sınırı belirtiyor; ayrıca ayrı bir kişisel gerekçe verilmedi.
- Etki: Davranış değişikliği uygun testlerle, belge değişikliği içerik kontrolleriyle doğrulanır. Yeni bağımlılık kullanıcı kararıdır. Flake8 bütün projelere zorunlu değildir.

## K-005 — Kurulumda çakışma güvenliği

- Kayıt zamanı: 2026-10-01 23:57.
- Kullanıcı kararı: Hedef yollar ve bütün çakışmalar yazmadan kontrol edilir. Hedef dosyalardan biri varsa hiçbir dosyaya dokunulmaz; kaynak paket içine kurulum reddedilir.
- Gerekçe: Kabul edilen plan bu davranışı belirtiyor; ayrıca ayrı bir kişisel gerekçe verilmedi.
- Etki: Otomatik üzerine yazma/güncelleme yoktur. Sürüm, kurulum tarihi ve kaynak dosya özetleri kaydedilir; kopyalama hatası kısmi sonucu bildirir. Uygulama 1.2'dedir.

## K-006 — Bu tur yalnız 1.1

- Kayıt zamanı: 2026-10-01 23:57.
- Kullanıcı kararı: Sunulan plan uygulansın; plandaki ilk uygulama birimi 1.1 olsun ve her adım sonunda durulsun.
- Gerekçe: Planın açık çalışma birimi ve durma kuralı.
- Etki: Bu tur belgeler ve iki SVG oluşturulur. Kurucu, sürüm kaydı, denetim/test betikleri ve VS Code davranış denemeleri sonraki adımlardır. Git kurulumunu kullanıcı yapar; commit/push ayrı izin gerektirir.

## K-007 — GitHub deposu ve 1.1 commit onayı

- Kayıt zamanı: 2026-10-02 00:19.
- Kullanıcı kararı: `https://github.com/Emir-Ars/AI-Sablonum` deposunu oluşturdu ve 1.1'in commit edilmesini istedi.
- Gerekçe: Kullanıcı mevcut planlama ve ortak kayıt düzenini yeterli gördüğünü belirtti.
- Etki: 1.1 dosyaları için commit onayı var; push onayı yok. İlk kontrolde yerel Git deposu olmadığı için kullanıcıya yerel kurulum komutları verildi; kullanıcı daha sonra yerel depoyu ve doğru uzak adresi kurdu. 1.2–1.4 uygulanmadı; bu mesaj bu adımların otomatik uygulama veya iptal kararı sayılmadı.

## K-008 — Eski global kurulumun kaldırılması talebi

- Kayıt zamanı: 2026-10-02 00:19.
- Kullanıcı kararı: Daha önce kurduğu `Emir-Ars/ai-sablon` deposunun getirdiği global eklemeleri kaldırmayı istedi.
- Kullanıcının gerekçesi: Codex/Claude'un ilk kurulum düzenine dönmek ve kuralları yeni projelerin içinde tutmak.
- Etki: Önce eski kurucunun hedefleri ve mevcut dosyalar salt okunur incelenir. Yeni talep yalnız eski kurulumla ilişkili eklemeler için global dosyalara dokunmama kuralına istisnadır; ürünün yerleşik skill, eklenti, kimlik veya genel ayarları kapsam dışıdır. Dosyaların ilk kurulumda boş olduğu varsayılmaz; yedekler ve kaynak eşleşmesi değerlendirilir.
- Sonuç: 2026-10-02 00:30 kaydında doğrulanmış iki global dosya ve sekiz özel skill klasörü silinmeden yedeğe taşındı. Eski kurucunun eklediği `attribution` alanı, en eski ayar yedeğinde bulunmadığı doğrulanarak kaldırıldı. Diğer Claude ayarları aynı kaldı; kaynak depo ve eski yedekler korunuyor.

## K-009 — 1.1 push onayı ve o oturumda durma

- Kayıt zamanı: 2026-10-02 10:02; önceki kullanıcı mesajının zamanı değildir.
- Kullanıcı kararı: Önceki mesajında yalnız push yapılmasını, sonraki adımın o oturumda uygulanmamasını istedi.
- Kullanıcının gerekçesi: Sonraki adıma ertesi gün geçmek istediğini belirtti.
- Sonuç ve etki: `1dde9d6` commiti `origin/main` dalına gönderildi; uzak dal aynı commit kimliğiyle doğrulandı. Sürüm etiketi/yayını oluşturulmadı. Bu onay yeni 1.2 değişikliklerine uygulanmaz.

## K-010 — Yalnız 1.2 uygulama izni

- Kayıt zamanı: 2026-10-02 10:02.
- Kullanıcı kararı: “1.2 ye başlayalım”.
- Gerekçe: Önceden kabul edilen plandaki sıradaki alt adımı açıkça seçti; ayrıca bir gerekçe verilmedi.
- Etki: Yerel kurucu, kaynak sürüm bilgisi, bu davranışın doğrulaması ve ilgili belgeler tamamlanır. 1.3/1.4'e geçilmez; 1.2 commit ve push için ayrı onay beklenir. Global skill, eklenti ve ayarlar bu adımda değiştirilmez.

## K-011 — 1.2 yerel commit onayı

- Kayıt zamanı: 2026-10-02 10:24.
- Kullanıcı kararı: “commit edebilir miyiz fakat şu anda windows görev zamanlayıcı çalışıyor?” mesajıyla commit istedi; çalışan görevlerin etkisini sordu.
- Gerekçe: Görev Zamanlayıcı çalışırken commit işleminin uygunluğunu netleştirmek istedi.
- Etki: Çalışan görevler salt okunur kontrol edildi; tanımlı eylemlerinde bu depoya açık referans görülmedi. Önceden önerilen 9 dosya ve Türkçe mesajla yerel commit yapılır. Görevleri durdurma/değiştirme, push veya 1.3 uygulama izni yoktur.

## K-012 — 1.2 push onayı

- Kayıt zamanı: 2026-10-02 11:07; önceki mesajın zamanı değildir.
- Kullanıcı kararı: “pushla”.
- Gerekçe: Ayrıca bir gerekçe verilmedi.
- Sonuç ve etki: `1e2fdfcd662a6e17e372ab50f054d903764ebffd` commiti `origin/main` dalına gönderildi. Çalışma ağacı temizdi; yeni adım uygulanmadı. Sürüm etiketi/yayını oluşturulmadı. Bu onay 1.3 değişikliklerine uygulanmaz.

## K-013 — Yalnız 1.3 uygulama izni

- Kayıt zamanı: 2026-10-02 11:07.
- Kullanıcı kararı: “1.3 e geçelim”.
- Gerekçe: Önceden kabul edilen sıradaki alt adımı seçti; ayrıca bir gerekçe verilmedi.
- Etki: Elle denetim betiği, bağımlılıksız kurulum testleri, kaynak listesine ekleme ve ilgili belgeler tamamlanır. Global dosya/ayar veya görev değişikliği, yeni paket, 1.4 uygulaması, commit veya push izni yoktur.

## K-014 — 1.3 commit/push ve 1.4 uygulama onayı

- Tarih/saat: 2026-10-02 11:39; kayıt zamanı kabuktan alındı.
- Karar: Kullanıcı “commit push yap 1.4 son adımı için ilerleyelim artk bitsin ki yeni projeme rahatça başlayayım” dedi. 1.3'ün Devir'deki 14 dosyalık commit kapsamı ve push işlemi açıkça onaylandı; ardından 1.4 uygulaması seçildi.
- Gerekçe: Kullanıcı şablonun son adımını tamamlayıp yeni projesine başlamak istiyor.
- Etki: Önce doğrulanmış 1.3 commit edilip gönderilir; ardından gerçek Codex/Claude VS Code davranışları değerlendirilir. Genel plan kabulü yerine doğrudan kullanıcı izni vardır. Global skill/ayar değişikliği, yeni paket, sürüm etiketi/yayını veya sonraki bir commit bu karardan kendiliğinden çıkarılmaz.

## K-015 — 1.4 denemeleri için adım adım yönlendirme

- Tarih/saat: 2026-10-02 13:24; kabuktan alınan kayıt zamanı.
- Karar: Kullanıcı “tamamdır şimdi 1.4ü de halledelim neler yapmam gerekiyor” diyerek önceki 1.4 iznini sürdürdü ve kendi yapacağı işlemleri sordu.
- Gerekçe: Gerçek VS Code denemelerinin nasıl tamamlanacağını öğrenmek istiyor.
- Etki: Hazır geçici alanlar kontrol edilir; mesaj sırası ve kabul ölçütleri kılavuzla açıklanır. İlk Codex mesajından başlayarak her gerçek sonuç ayrı değerlendirilir. Kullanıcı mesajının kendisi başarılı deneme sonucu değildir; global ayar/skill veya yeni paket değişikliği yoktur.

## K-016 — Küçük adımları koruma ve son yerel commit

- Tarih/saat: 2026-10-02 13:55; kabuktan alınan kayıt zamanı.
- Karar: Kullanıcı küçük işlere bölünmesini sevdiğini, biraz yavaşlasa da bu yapıyla düzenli ilerlediğini açıkladı; mevcut yapı uygunsa son commitle bitirmeyi istedi.
- Gerekçe: Düzenli ve küçük adımlı proje geliştirme tercihinin korunması.
- Etki: Önceki sadeleştirme önerisi uygulanmaz; ortak kurallar değişmez. Codex'in ikinci cevabı gerçek dosyalarla karşılaştırılır ve mevcut sekiz dosyalık kaynak düzeltmesi/kayıt kapsamı son yerel commite alınır. Kalan altı denemenin yapıldığı veya 1.4'ün tümüyle doğrulandığı sonucu çıkarılmaz; paket geliştirme durumunda kalır. Bu mesaj yeni push veya sürüm yayını onayı değildir.

## K-017 — Son push, eski yedeğin silinmesi ve denemelerin ertelenmesi

- Tarih/saat: 2026-10-02 14:13; kabuktan alınan kayıt zamanı.
- Karar: Kullanıcı önce son değişikliklerin push edilmesini istedi; ardından eski kurulum yedeğinin yanlışlıkla okunmasını önlemek için silinmesini istedi. Kalan altı gerçek ajan davranışını yeni projesinde gözlemleyeceğini belirtti.
- Etki: 792d570 commiti origin/main dalına gönderildi. Yalnız C:\Users\Emir\ai-sablon-kaldirma-yedekleri\20261002-002951 klasörü açık kullanıcı isteği ve araç izniyle kalıcı silindi. Başka yedek veya aktif global ayar silinmedi. Altı deneme bekliyor; 1.4 doğrulandı veya sürüm yayımlandı sayılmaz. Bu kayıt değişiklikleri için yeni commit/push yapılmaz.

## K-018 — Genel araştırma ve risk temelli bağımsız inceleme

- Tarih/saat: 2026-10-11 12:52; kabuktan alındı.
- Karar: Kullanıcı, başka projesindeki iki davranışın artı/eksi değerlendirmesinden sonra önerilen düzenlemelerle genel şablona eklenmesini istedi. Projeye özgü terimler ve o projenin karar numaraları taşınmayacak.
- Gerekçe: Sonucu etkileyen belirsizliğin doğrulanması ve çözümün ayrı bir gözle sınanması bütün yeni projelerde kullanılacak; düşük etkili işleri gereksiz araştırma veya sürekli zorunlu inceleme yavaşlatmayacak.
- Etki: Ortak kaynağa araştırma sırası ve zorunlu/hafif/yok inceleme katmanları eklenir. Doğrulanmayan bilgi belirsizliğiyle yazılabilir; sonuçlar doğrulanmış gibi sunulamaz. İlk iletişim maddesi bu ayrımı açıklar. İnceleme her değişikliğin etkisine göre seçilir; önceki katman yeni işi kendiliğinden bağlamaz. Bulgulara uygun doğrulama uygulanır. Kaynak/giriş eşleşmesi ve ilgili kayıtlar tek 1.5 adımında tamamlanır.
- Sınır: Yayımlanmamış v0.1.0 geliştirme paketi hazırlanır; kurulu projeler/global dosyalar değişmez. Yeni bağımlılık, teknik izin kilidi, commit/push, sürüm yayını veya tam araç uyumluluğu onayı yoktur.

## K-019 — Ana aşama kapanışında ilgili geçmişi arşivleme

- Tarih/saat: 2026-10-11 13:21; kabuktan alındı.
- Karar: Kullanıcı, ana aşama tamamlanınca yalnız o aşamaya özgü geçmişin `docs/arsiv/01-asama-adi/` gibi numaralı ve adlandırılmış bir klasöre alınması önerisinin kendi isteğiyle aynı olduğunu doğruladı.
- Gerekçe: Güncel belgelerin sürekli büyümesini azaltmak ve önceki çalışma, karar, araştırma ve doğrulama kayıtlarını kaybetmemek.
- Etki: Aşamaya özgü tamamlanmış Plan/Günlük/Kararlar ve varsa araştırma/teknik bölümler arşivlenir. Ana Plan'da kısa sonuç, durum ve arşiv bağlantısı kalır; yürürlükteki ortak kararlar ile açık işler güncel belgelerde erişilebilir tutulur. Kayıt kimlikleri korunur, ayrıntının asıl kaydı tek yerde olur. Son alt adımın bitmesi tek başına kapanış sayılmaz; aşama doğrulamaları da değerlendirilir. Denetim ve eski hata araması arşivleri kapsayacak şekilde uyarlanmalıdır.
- Sınır: Bu mesaj yaklaşımın kabulüdür; 1.6 uygulama adımı ayrıca seçilmedi. Şimdilik yalnız proje kayıtları güncellenir; ortak davranış kuralları veya betikler değiştirilmez, geçmiş kayıtlar taşınmaz. Commit/push, yeni bağımlılık veya mevcut projelere aktarım onayı yoktur.

## K-020 — Teknik kaliteyi koruyan anlaşılır çalışma düzeninin uygulanması

- Tarih/saat: 2026-10-11 14:36; kabuktan alındı.
- Karar: Kullanıcı son planı açıkça uygulamamı istedi. Ajanın araştırma, analiz, problem çözme ve tasarım yöntemlerine yapay sınır konmayacak; doğruluk, güvenlik ve gerekli teknik kalite korunarak anlaşılır yapı ve anlatım sağlanacak.
- Gerekçe: Kullanıcı yazılımı öğrenerek takip etmek istiyor; ajanın teknik çözüm üretme yeteneğini sınırlandırmak istemediğini özellikle belirtti. Seçtiği anlatım düzeyi başlangıçta kısa harita, seçilen aşamada dosya görevleri ve somut çalışma akışıdır.
- Etki: 1.7'de genel kurallara ihtiyaca uygun mimari, gerekçeli karmaşıklık, sorumlulukla dosya ayrımı, bağımsız sonuçlara yeniden bölme ve üst adım kapanış ölçütleri eklenir. Harita README varsa orada, yoksa Plan'ın Proje özeti altında tutulur. Ortak kaynak/giriş/özet, anlatım, senaryolar ve kayıtlar tamamlanır; mevcut izin sınırları korunur.
- Sınır: Model, muhakeme veya araç ayarı, kurucu/kontrol/test kodu ve yeni bağımlılık değişmez. Arşivleme 1.6 olarak ayrı bekler. Yeni davranış veya çıktı kalitesi gerçek ajan denemesi olmadan doğrulandı sayılmaz; bu mesaj commit/push, sürüm yayını veya mevcut projelere aktarım izni değildir.

## K-021 — Projede mühendislik öğreten çalışma düzeninin uygulanması

- Tarih/saat: 2026-10-11 15:48; kabuktan alındı.
- Karar: Kullanıcı 1.8 planının tamamını açıkça uygulamamı istedi. Planlama görüşmesinde hedefe zaten kopyalanan dört başlangıç Markdown belgesinin içeriklerinin geliştirilmesini de seçti; kurucu, denetim, kurulum test betikleri ve sürüm manifesti aynı kalacak.
- Gerekçe: Kullanıcı kod üretimini AI ajanlarına bırakırken yazılım dünyasındaki yöntemleri, mantığı ve mühendisliği öğrenmek istiyor; gerekli teknik düşünme yöntemlerini sınırlandırmak istemiyor. Şablon yalnız kurulduğu proje klasöründe kullanılacak.
- Teknik değerlendirme: İki rapordaki araştırma, küçük adım, teknik kalite ve risk temelli inceleme önerileri mevcut kurallarda zaten var. Gerçek boşluklar tasarım seçeneklerinin bedelleri, kanıtlı hata teşhisi, değişiklik etkisi ve kabul ölçütü–kanıt ilişkisinin öğretici anlatımıdır. Kısa kurallar mevcut maddelerle birleştirilir; ayrıntılı kaynak raporları hedefe kopyalanmaz.
- Etki: 1.8.1 ortak kurallar/AGENTS kaynak özeti ve README; 1.8.2 dört temiz başlangıç belgesinin geriye uyumlu yönergeleri; 1.8.3 mevcut deneme kılavuzuna karşılaştırmalı senaryolar ve ayrı gerçek araç sonuçları. Kaynak depoda 1.7 kurallarının birebir deneme örneği korunur; bu dosya kurulum kapsamına eklenmez. Kullanıcının bu mesajı üç alt adımın uygulama yönlendirmesidir; genel ortak tek-adım kuralı kalıcı olarak değiştirilmez.
- Sınır: Kurucu/denetim/test betikleri, sürüm manifesti, global dosya/ayar, model/muhakeme ayarı, araştırma dosyaları ve kurulu projeler değiştirilmez. 1.6 arşivleme ayrı bekler; geçmiş kayıtlar taşınmaz. Gerçek Codex/Claude denemesi olmadan öğrenme veya kalite etkisi doğrulandı sayılmaz. Commit/push veya sürüm yayını onayı yoktur.

## K-022 — Gerçek davranış denemesine birlikte başlama

- Tarih/saat: 2026-10-11 16:49; kabuktan alındı.
- Karar: Kullanıcı “tamma nasıl yapalım söyle birlikte yapalım” diyerek önerilen gerçek davranış karşılaştırmasına birlikte başlamayı seçti.
- Gerekçe: Kullanıcı talimatların teknik kaliteye etkisini gerçek proje davranışı üzerinden görmek istiyor; modelin gerekli çözüm yeteneğini kısıtlamak istemiyor.
- Teknik değerlendirme: İlk T-3 pilotu için mevcut Windows PowerShell 5.1 ile çalışan başlık doğrulama örneği seçildi. Aynı başlangıç kodu, README, test ve kayıtlar normal/1.7/1.8 koşullarına verilir. Normal koşul yalnız ek proje talimatı olmayan karşılaştırmadır; mevcut global talimatlar veya görev bağlamı yok sayılmaz. Bir kez çalıştırma genel kalite veya zekâ etkisini kanıtlamaz.
- Etki: İzole geçici alanlar hazırlanır ve gerçekten kontrol edilir; kullanıcı aynı mesajı ayrı yeni IDE sohbetlerinde gönderir. Her cevap sonrası dosya farkları, bağımsız kabul kontrolü ve açıklama birlikte değerlendirilir. Gerçek araç/model koşulları görülebildiği kadar kaydedilir; bilinmeyen tahmin edilmez.
- Sınır: Kurulum betikleri/manifest, global/araç/model/muhakeme ayarı ve gerçek projeler değişmez. Yeni paket, commit/push, yayın, arşivleme veya diğer aşamalara geçiş izni yoktur.

## K-023 — Tam belge yönergeleriyle kayıt uyumunu yeniden sınama

- Tarih/saat: 2026-10-11 21:29; kabuktan alındı.
- Karar: Kullanıcı “tamam önerini nasıl yapalım” diyerek yeni kural eklemeden tam başlangıç yönergeleriyle kayıt uyumunu tekrar sınama önerisini kabul etti; birlikte nasıl ilerleyeceğini sordu.
- Gerekçe: Kullanıcı bu mesajda ayrı gerekçe bildirmedi. Kabul ettiği öneri önceki ortak pilot belgelerinin kısaltılması nedeniyle oluşan değerlendirme sınırını gidermektir.
- Teknik değerlendirme: İki temiz hedefte aynı hatalı kod/test/README, aynı güncel tam başlangıç belgeleri ve farklı 1.7/1.8 AGENTS metinleri kullanılır. Bu, geçmiş 1.7 belge paketinin tamamını değil kural metnini karşılaştırır. Önceki cevaplar/sonuçlar yeni hedeflere taşınmaz; başlangıç metadata'sı dahil dosya özetleri gerçek ajan başlamadan kaydedilir.
- Etki: 1.8.3 içinde yerel izole hazırlık, kullanıcıyla ayrı yeni IDE oturumları ve her gerçek sonuç için bağımsız ürün/kayıt değerlendirmesi. Yalnız ilk 1.7 oturumundan başlanır; model/Light ve izinler değiştirilmez.
- Sınır: Davranış kaynağı, kurucu/denetim/kurulum testleri, manifest, global ayar veya önceki gerçek projeler değişmez. Yeni paket, commit/push, yayın, arşivleme veya başka aşama uygulama izni yoktur.

## K-024 — Yeşil testler ile aşama kabul ölçütlerini karşılaştırma denemesi

- Tarih/saat: 2026-10-11 22:36; kabuktan alındı.
- Karar: Kullanıcı “tamam önerinle ilerleyelim” diyerek T-4 denemesine geçme önerisini kabul etti.
- Gerekçe: Kullanıcı bu mesajda ayrı gerekçe bildirmedi. Kabul ettiği öneri, mevcut testler geçse bile karşılanmayan gereksinimin fark edilip edilmediğini ve aşamanın erken kapatılmamasını sınamaktır.
- Teknik değerlendirme: Aynı bellek içi kitap başlığı örneği, mevcut iki test ve tam güncel başlangıç belgeleri üzerinde eski/yeni AGENTS karşılaştırılır. Üç kabul ölçütü önceden Plan'da yer alır; dış kabul karşı örneği ve değerlendirme anahtarı hedeflere taşınmaz. Salt okunur istek nedeniyle bütün hedef dosyaları test öncesi özetlerle aynı kalmalıdır.
- Etki: 1.8.3 içinde iki yeni geçici alanın hazırlanması, ilk 1.7 yeni IDE sohbeti ve gerçek sonuç gelince değerlendirme. Sonra 1.8 ayrı sohbetle yapılır; T-3 cevapları/düzeltmeleri aktarılmaz. Bir görev/bir koşu genel kalite veya zekâ etkisini kanıtlamaz.
- Sınır: Kurucu/denetim/kurulum testleri, sürüm manifesti, davranış kaynağı, sablon/docs, global/araç/model/muhakeme ayarı ve eski sonuçlar değiştirilmez. Yeni paket, arşivleme, commit/push, yayın veya gerçek ürün uygulaması yetkisi yoktur.

## K-025 — Tasarım seçenekleri ve bedelleri deneme alanlarının hazırlanması

- Tarih/saat: 2026-10-12 11:22; kabuktan alındı.
- Karar: Kullanıcı, “T-2 için iki temiz deneme klasörünü hazırlayayım mı?” sorusuna “Evet, deneme alanlarını hazırla.” yanıtını verdi. Yalnız geçici deneme alanları ve proje kayıtları hazırlanacak; kurulum dosyaları, davranış kuralları ve model ayarları değişmeyecek.
- Gerekçe: Kullanıcı bu onay mesajında ayrı gerekçe bildirmedi.
- Teknik değerlendirme: T-3/T-4'ün ilk örnekleri dışında mühendislik kararının gerekçesini sınamak için T-2 seçilir. Üç gereksinim önceden sabitlenir; depolama yöntemi veya doğru cevap dayatılmaz. İki kol aynı mevcut doğrulama işlevi ve tam güncel belgelerle başlar; yalnız 1.7/1.8 kuralları farklıdır. Önceki çözüm/görüşme kayıtları taşınmaz, geçmiş 1.7 paketi bütünüyle yeniden üretilmez.
- Etki: 1.8.3 içinde yerel hazırlık ve kullanıcıyla ayrı yeni Codex sohbetleri. İlk eski kural cevabı değerlendirilir, sonra yeni kuralda aynı görev yapılır. Tasarım görüşmesi ilgili planlama kayıtlarını güncelleyebilir; ürün/test/kurulum/ayar uygulaması veya önerinin kullanıcı kararı gibi kaydı yasaktır. Hazırlık ve sınanan tasarımın inceleme gereksinimleri ayrıdır.
- Sınır: Gerçek tasarım sonucu veya öğrenme/zekâ/kalite etkisi henüz yoktur. Kurucu/denetim/kurulum testleri, manifest, genel kurallar/AGENTS/sablon/docs, araştırmalar, global ayarlar ve eski sonuçlar korunur. Depolama seçimi/ürün uygulaması, bağımlılık, arşivleme, commit/push veya yayın yetkisi verilmedi.

## K-026 — Kalan davranış denemelerini sınırlı Codex turuyla tamamlama

- Tarih/saat: 2026-10-12 14:14; kabuktan alındı.
- Karar: Kullanıcı “2 senaryoyu codexde deneyelim yeter claude de aynı davranışı yapar merak etme” dedi ve “tamam deva et ne yapmam gerrekiyotr” ile devamı istedi. Kalan T-1 ve T-5 yalnız Codex'te, her senaryoda eski/yeni birer oturum olarak seçildi; toplam dört yeni sohbet. Ek tekrar, Claude ve Q senaryoları bu sınırlı turun dışında.
- Gerekçe: Kullanıcı iki Codex senaryosunu yeterli görüyor ve Claude'un da aynı davranacağına inandığını belirtti. Bu ikinci ifade kullanıcı beklentisidir, ölçülmüş sonuç değildir.
- Teknik değerlendirme: Sınırlı tur pratik kapsam/netleştirme/etki kontrolü sağlar; genel zekâ, öğrenme, nedensel iyileşme veya Claude eşdeğerliği kanıtı oluşturmaz. Yapılmayan senaryolar kılavuzdan silinmez, başarılı sayılmaz ve bu turun kapanışına sonradan zorunlu eklenmez.
- Etki: Önce T-1 iki temiz hedef hazırlanır; ilk 1.7 yeni sohbeti değerlendirilip sonra aynı mesaj 1.8'de denenir. Çift sonrası T-5 hazırlanır. 1.8.3 sınırlı Codex sonuçları ve açık sınırlarıyla değerlendirilir; 1.4'ün tarihsel 2/8 sonucu, ortak iki-araç kuralları ve 1.6'nın ayrı kapsamı korunur.
- Sınır: Kurucu/denetim/kurulum testleri, manifest, ortak kurallar/AGENTS/sablon/docs, global/model/muhakeme ayarı, araştırmalar ve önceki sonuçlar değişmez. Ürün uygulaması, yeni bağımlılık, arşivleme, commit/push veya yayın onayı yoktur. Gerçek Codex mesajlarını kullanıcı gönderir; hazırlık/test kayıtları gerçek ajan sonucu diye sunulmaz.

## K-027 — Yalnız hızlı görev performansı taramasını hazırlama

- Tarih/saat: 2026-10-12 17:05; kabuktan alındı.
- Karar: Kullanıcı hızlı tarama önerisinin ardından “evet yapalım hızlı tarama diğer uzunu yapmaya gerek yok?” dedi. Üç görev/iki koşul, toplam altı yeni Codex sohbeti için yerel hazırlık seçildi; uzun değerlendirme eklenmeyecek.
- Gerekçe: Kullanıcı uzun çalışmayı istemediğini belirtti; ayrı gerekçe bildirmedi.
- Teknik değerlendirme: Genel model zekâsı bu küçük deneyle ölçülemez. Aynı ürün/test/belge bağlamına güncel proje AGENTS eklenmesinin görev performansı karşılaştırılır; ortak belge/global/üst yönergeler kontrolde de kalabilir. Kontrol sıfır talimatlı model değildir. Arama hatası, iki tüketicili tasarım ve uygulanan alan geçişi seçilir; teknik doğruluk, izin, kanıt ve yararlı açıklama ayrı incelenir. Ölçülmeyen nedensel kalite/öğrenme iddiası üretilmez.
- Etki: Yeni 1.9.1 yalnız geçici alanlar/dış kontroller/fotoğraf/kılavuz ve mevcut beş proje kaydı. 1.9.2'de kullanıcı aynı GPT 6.1 Sol / Light ile tek tek gerçek yeni sohbetleri açar; önce S-1 kontrol sonucu beklenir. İki koşula aynı açık görev yetkisi verilir. Belge/inceleme yükü teknik sonuçtan ayrı gözlenir.
- Sınır: Kurucu, denetim, kurulum test betikleri, manifest, kaynak kurallar/AGENTS/başlangıç şablonları, global/model/araç ayarı, araştırmalar ve önceki sonuçlar değişmez. Paket kurulumu, Claude, uzun tur/ek tekrar, arşivleme, commit/push veya yayın yoktur. 1.8'in seçilmiş kapanışı korunur; hazırlık gerçek ajan denemesi diye yazılmaz.

## K-028 — Git işlemlerine genel onay; dosya kapsamı bekliyor

- Tarih/saat: 2026-10-12 22:53; bu kaydın zamanı kabuktan alındı, önceki mesajın gönderim zamanı değildir.
- Karar: Kullanıcı hızlı tarama kapanışı sonrasında “commit push atabilirsin” dedi. Yalnız son dört kayıt veya tüm ilgili şablon değişiklikleri sorulduğunda henüz dosya kapsamı seçmedi; önce şablonun açıklanmasını, sonra arşivleme senaryosunun değerlendirilmesini istedi.
- Gerekçe: Kullanıcı Git onayına ayrı gerekçe bildirmedi.
- Etki: Genel commit ve push izni vardır; dahil edilecek dosyalar ve gerçek doğrulama tamamlanmadan işlem başlatılmaz. Kullanıcı değişiklikleri ve araştırmalar kör biçimde topluca eklenmez; commit/push yapılmadı. Önce arşivleme işi önerilmesi bu dosya kapsamını kendi başına seçmez.

## K-029 — Arşiv uyumu için denetim ve test kapsamına onay

- Tarih/saat: 2026-10-12 22:53; kabuktan alındı.
- Karar: Kullanıcı, “Kurucuya dokunmadan, denetim betiği ve testlerin arşiv uyumu için değiştirilmesini onaylıyor musun?” sorusuna “onaylıyorum” dedi. Soruda açıklandığı gibi bu onay bütün alt adımları topluca uygulama izni değildir; ardından yalnız 1.6.1'in uygulama kapsamı sunulur.
- Gerekçe: Bu onay mesajında ayrı gerekçe bildirilmedi. Kullanıcı önceki mesajında hazırlık ve kapanan aşama geçmişinin kaybolmadan arşivlenmesini, genel plan ve projeyi etkileyen kararların aktif kalmasını istedi.
- Ajanın teknik değerlendirmesi: Mevcut denetim sabit ana belgeleri okur ve uygulanmış adımın Günlük karşılığını yalnız aktif dosyada arar. Arşivlerin de okunması için denetim/test kapsamı gerekir; kurucuya yeni arşiv mekanizması eklenmesi zorunlu değildir. Aynı Plan biçimi yeniden kullanılabilir, genel yol haritası sıfırlanmaz. Kayıp/yarım taşıma/kimlik/bağlantı ve yürürlükteki bilgiyi ayırma riskleri tasarımda açık ele alınmalıdır.
- Etki: 1.6, ayrı 1.6.1 kural/belge, 1.6.2 denetim/ilgili test ve 1.6.3 bütün akış değerlendirmesi birimlerine ayrılır. Bu tur karar ve kapsam kaydı, ardından yalnız 1.6.1 için açık uygulama yönlendirmesi beklenir.
- Sınır: Kurucu, manifest, global/model/araç ayarları, araştırmalar ve özgün deneyler değişmez. Bu deponun ana aşama 1'i açık; mevcut geçmiş şimdi taşınmaz. Ortak kaynak/AGENTS/başlangıç belgeleri veya betikler henüz değiştirilmez. Yeni otomasyon/bağımlılık, mevcut projelere aktarım veya ek gerçek ajan denemesi izni çıkarılmaz. K-028 dosya kapsamı ayrı kalır; bu tur commit/push yapılmaz.

## K-030 — Yalnız 1.6.1 arşivleme kurallarını ve belgelerini uygulama

- Tarih/saat: 2026-10-12 23:05; kabuktan alındı.
- Karar: Kullanıcı, 1.6.1 kapsamı ve önce zorunlu bağımsız tasarım incelemesi yapılacağı açıklandıktan sonra “evet onaylıyorum” dedi. Yalnız ortak arşivleme kuralları, AGENTS kaynak eşleşmesi/özeti, README, dört temiz başlangıç belgesi ve ilgili proje kayıtlarının uygulanması seçildi.
- Gerekçe: Kullanıcı bu mesajda ayrı gerekçe bildirmedi; hazırlık ve kapanmış aşama geçmişini kaybetmeden aktif belgelerin büyümesini azaltma ihtiyacını önceki görüşmede açıkladı.
- Ajanın teknik değerlendirmesi: Aktif Plan genel yol haritasını ve yürürlükteki bilgiyi korumalı; bitmiş yerel ayrıntılar tek tarihsel kayda bağlanmalı. Kayıt kaybı riski nedeniyle güvenli aktarım, kimlikler, bağlantılar, yarım işlem ve yeniden açılma kuralları tasarım öncesi ve son metinde bağımsız incelenecek. Belge doğrulaması fiili arşivleme akışının doğrulandığını göstermez.
- Etki: 1.6.1 uygulaması başlar; kendi doğrulamaları ve kayıtları tamamlanınca durulur. 1.6.2 denetim/test uyumu ve 1.6.3 izole tam akış ayrıca seçilecektir. Denetim uyumu ve izole akış doğrulanmadan gerçek geçmiş taşınmaz; üst 1.6 ve ana aşama 1 açık kalır.
- Sınır: Kurucu, denetim ve kurulum test betikleri ile manifest bu adımda değişmez. Kaynak geçmişi, araştırmalar ve özgün deneyler taşınmaz; kurulu projeler/global/model/araç ayarları değiştirilmez. Yeni otomasyon/bağımlılık veya gerçek ajan denemesi eklenmez. K-028'in Git dosya kapsamı hâlâ ayrıdır; commit/push yapılmaz.

## K-031 — Yalnız 1.6.2 arşiv uyumlu denetimi ve testlerini uygulama

- Tarih/saat: 2026-10-12 23:32; kabuktan alındı.
- Karar: Kullanıcı “1.6.2 yi uygula” dedi. Denetimin aktif/arşiv kayıtlarıyla çalışması ve ilgili izole otomatik testler aynı çalışma biriminde seçildi.
- Gerekçe: Bu mesajda ayrı gerekçe bildirilmedi; hazırlık/aşama arşivleme ihtiyacı önceki kararlarda kayıtlıdır.
- Ajanın teknik değerlendirmesi: Arşiv dosyası eksikliği yalnız üçlü belge sayısıyla ölçülemez; hiç yerel karar olmayabilir. Aktif veya tarihsel Plan kendi Günlük kanıtına bağlanmalı; eski arşiv yeni işin doğrulamasını karşılamamalı. Kapanışa açık kayıt bağlantısı ve ilişkili yeniden açılma geçmişi yapısal olarak değerlendirilebilir; gerçek test yürütmesi ve kaynakta iz bırakmadan silinmiş kayıtların kayıpsızlığı denetimden çıkarılamaz.
- Etki: Zorunlu bağımsız tasarım/kod incelemesiyle kontrol.ps1 ve Kurulum.Tests.ps1 güncellenir; ilgili README/başlangıç yönergeleri ve proje kayıtları yeni kabiliyete uydurulur. Mevcut arşivsiz davranış korunur. 1.6.2 sonunda durulur; 1.6.3 izole tam aktarım akışı ayrıca seçilir.
- Sınır: kur.ps1 ve surum.json değişmez. Ortak davranış/model/global/araç ayarı, yeni bağımlılık/taşıma otomasyonu, gerçek geçmiş/araştırmalar/özgün deneyler ve kurulu projeler değiştirilmez; arşiv testleri yalnız yeni izole geçici veriler kullanır. K-028 Git dosya kapsamı ayrı kalır; commit/push yapılmaz.

## K-032 — 1.6.2'nin açık doğrulamasını tamamlamak

- Tarih/saat: 2026-10-13 09:39; kabuktan alındı.
- Karar: Kullanıcı “1.6.2 yi doğrulayalım ne kadr sürer?” dedi; mevcut alt adımın doğrulama çalışması seçildi, süre sorusu yaklaşık 5–10 dakika olarak yanıtlandı.
- Gerekçe: Ayrı gerekçe bildirilmedi; önceki turda dosya sembolik bağlantısı güvenlik kontrolü Windows yetkisi nedeniyle atlanmıştı.
- Ajanın teknik değerlendirmesi: Aynı test ve denetim kodu korunarak mevcut 108 kabul kontrolü yeni izole geçici hedeflerde yeniden çalıştırılır. Eksik test için tek seferlik Windows RunAs işlemi kullanılır; bunun sonucu kalıcı izin veya ayar değişikliği değildir. Sonuç raporu ve özellikle önceki atlanan testin durumu gözlenmeden adım doğrulandı sayılmaz.
- Etki: Yalnız mevcut 1.6.2 doğrulaması ve ilgili README/Plan/Kararlar/Günlük/Devir kayıtları güncellenebilir. Windows PowerShell 5.1 test işlemi 09:35'te başladı; bu karar kaydı yazılırken sonuç raporu henüz yoktu.
- Sınır: Kod, kurucu, test betiği, manifest, ortak kaynak/AGENTS, başlangıç belgeleri, bağımlılıklar ve global/model/araç ayarları değişmez. Araştırmalar, özgün deneyler ve kurulu projeler korunur; gerçek arşiv/aktarım, 1.6.3, commit veya push izni oluşturulmaz.

## K-033 — Son arşivleme akışını tamamlayıp seçilmiş şablon çalışmasını bitirmek

- Tarih/saat: 2026-10-13 10:01; kabuktan alındı.
- Karar: Kullanıcı 1.6.3'ün tamamlanmasını ve şablon çalışmasının artık bitirilmesini istedi. Yeni davranış veya değerlendirme turları eklenmeyecek.
- Gerekçe: Kullanıcı yalnız birkaç kural/davranış kurmak istediğini, sürecin fazla uzadığını bildirdi.
- Ajanın teknik değerlendirmesi: Son iş mevcut test yordamındaki izole hazırlık/aşama arşivi, yarım aktarım/yeniden deneme ve yeniden açılma bütünleşmesidir. Kaynak bölüm gerçekten kopyalanır; özgün içerik ve yalnız izinli bağlantı değişimi karşılaştırılır. Kaynak değişimi veya arşiv farkı aktif geçmişin çıkarılmasını durdurur. Bu, üretim taşıma aracı veya gerçek proje geçmişi aktarımı değildir.
- Etki: Mevcut tests/Kurulum.Tests.ps1 içinde sentetik akış testleri ve ilgili README/dört proje kaydı güncellenir; zorunlu tasarım/uygulama incelemesi ve tek son tam kabul turu yapılır. 1.6.3 ve üst 1.6 kabulü sağlanınca seçilmiş davranış şablonu kapsamı bitirilir; tarihsel yapılmamış deneyler başarıya çevrilmez.
- Sınır: Kurucu/denetim/manifest/ortak kaynak/AGENTS/başlangıç belgeleri, global/model/araç ayarı, bağımlılıklar ve gerçek geçmiş korunur. Yayın, yeni gerçek ajan denemesi, kurulu projelere aktarım, commit veya push başlatılmaz.

## K-034 — Şablon değişikliklerini commit etmek ve araştırmaları yerelde tutmak

- Tarih/saat: 2026-10-13 10:44; kabuktan alındı.
- Karar: Kullanıcı tamamlanan şablon için commit ve push izni verdi. Sunulan dosya kapsamından iki araştırma belgesini çıkardı ve bunların bağlantılarının önce düzenlenmesini seçti. Onaylı kapsam 14 değiştirilmiş şablon/kayıt dosyası ile tests/ornekler/1.7-kurallar.txt dosyasıdır; Desktop/Downloads'taki proje anlatımları dahil değildir.
- Gerekçe: Kullanıcı araştırma belgelerinin yayımlanmasını istemedi; ayrıca bir gerekçe bildirmedi.
- Ajanın teknik değerlendirmesi: Yerel özgün belgeler silinmeden korunur; Plan'daki bu dosyalara bağlantılar, yayımlanan deponun gerektirmeyeceği kaynak notuna çevrilir. Dosyalar tek tek seçilir; toplu ekleme, kimlik/uzak depo ayarı, force push veya sürüm etiketi yapılmaz.
- Etki: Bağlantı ve ilgili Plan/Günlük/Devir kayıtları güncellenir. Commit mesajı: Proje davranış şablonunu ve güvenli aşama arşivini tamamla. Kullanıcı mevcut origin/main için push izni verdi; gözlenmeyen sonuç başarılı sayılmaz.
- Sınır: İki özgün araştırma belgesi Git indeksine alınmaz ve yayımlanmaz. Yeni projeye kurulum henüz yapılmaz; hedef yol seçilmedi. Kurucu/manifest, model/global ayarlar, gerçek geçmiş ve özgün deneyler değişmez. Sürüm hâlâ geliştirme paketidir; bu onay release veya tam araç uyumluluğu doğrulaması değildir.
