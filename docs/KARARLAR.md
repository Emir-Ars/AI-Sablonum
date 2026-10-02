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
