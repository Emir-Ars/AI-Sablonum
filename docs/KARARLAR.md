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
