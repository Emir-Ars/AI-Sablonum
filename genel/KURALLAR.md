# Çalışma kuralları

Bu dosya her oturumda otomatik yüklenir; gereksiz yere yeniden okunmaz. `docs/kurallar/` altındaki ayrıntılı prosedürler "Ne zaman ne okunur" tablosundaki durumda okunur.

## 1. Yetki ve kırmızı çizgiler

1. Uygulama izni yalnız kullanıcının mesajından gelir. Plan, durum notu, yazılmış "sonraki adım" ve "tamam/olur" gibi planın kabulü uygulama izni değildir; açık "uygula" veya eşdeğeri gerekir. Belirsiz "devam" mesajında hangi adımın kastedildiğini sor.
2. Yalnız açıkça yetkilendirilen kapsam uygulanır: tek alt adım ("yalnız 2.3"), aralık ("2.3–2.5") veya sohbet planı (yalnız 1.2'nin planı sunulduysa hemen ardından gelen "uygula" yalnız 1.2'yi yetkilendirir; yeniden onay sorulmaz, 1.3'e geçilmez). Birden fazla adım veya plan makul biçimde kastedilebiliyorsa ya da bağlam kaybolduysa ("planı uygula") önce tek kapsam sorusu sor. Kendi çıkardığın kapsamı kayıtlara "kullanıcı istedi" diye yazma; "'uygula', sunulan 1.2 planına bağlandı" yaz. İşe başlarken kapsamı tek satırla yaz (`Kapsam: 2.3–2.5`) ve aralıktaki bütün adımların kabul ölçütlerini ve kaynaklarını incele. Adımlar arasında onay beklenmez; araya commit, push, birleştirme veya dal silme girerse o işlemden sonra dur: Git onayı yalnız adını taşıdığı işi kapsar, sonraki adımı başlatmaz. Kapsam bitince özetle, tek commit öner (kullanıcı aksini istemedikçe) ve dur. Kapsam dışına geçme; "dur ve danış" durumu çıkarsa orada dur.
3. `git add .` / `git add -A` kullanılmaz. Commit açık onayla, push ve birleştirme ayrı onayla yapılır. `git push --force`, `git reset --hard`, `git clean`, dal silme (yerel veya uzak) ve toplu silme açık onay ister. Dosyalar tek tek eklenir; `.gitignore` kapsamındaki dosya commit'e katılmaz. Commit ve PR açıklamasına yapay zekâ imzası veya `Co-Authored-By` eklenmez.
4. Şifre, anahtar ve token hiçbir dosyaya, komuta veya mesaja yazılmaz. `.env` ve gizli ayar değişikliği önce sorulur.
5. Çalıştırılmayan test veya gözlenmeyen sonuç "doğrulandı" diye yazılmaz.
6. Global ayar, skill, eklenti ve `.claude` / `.codex` klasörleri değiştirilmez.
7. Alt ajana iş verirken kapsamı ve bu dosyadaki sınırları (ağ, canlı sistem, gerçek veri, yazma yetkisi) görevle birlikte ver; alt ajanın sınır aşımını kullanıcıya bildir.

- **Dur ve danış:** planda olmayan iş (küçük iş istisnası dışında), kapsam değişikliği, yeni bağımlılık, mimari seçim, gizli ayar, biten aşamanın arayüzünü değiştirme, çözülemeyen test hatası, geri alınması zor işlem.
- **Küçük iş istisnası:** kullanıcının doğrudan istediği, birkaç dosyalık; bağımlılık, mimari, veri biçimi veya arayüz değiştirmeyen ve `docs/kurallar/INCELEME.md` "Zorunlu"/"Hafif" katmanına girmeyen iş (yazım hatası, küçük hata veya belge düzeltmesi) plan adımı açılmadan yapılır; aktif aşama varsa `GUNLUK.md` dosyasına "Plan dışı küçük iş: …" satırı yazılır; commit kuralları aynıdır. Sınır aşılırsa dur ve plan adımı öner.
- Yetkili işin içinde dosya düzenlemesi ve olağan kayıt güncellemesi için yeniden onay istenmez.

## 2. İletişim

- Açıklamalar ve belgeler Türkçedir. Kod tanımlayıcıları İngilizce, kod yorumları Türkçedir ve yalnız gerekçeyi anlatır.
- Teknik terim ilk geçtiğinde yarım cümleyle açıklanır; aynı oturumda tekrar açıklanmaz.
- Adım sonu özeti kısadır: ne yapıldı, neden, nasıl doğrulandı, açık kalan ne. Kullanıcıya veya çağıran sisteme görünen davranış değiştiyse doğrulama durumunu belirterek tek somut örnek ekle; belge düzenlemesi veya davranışı koruyan yeniden düzenleme için gerekmez.
- Durum sorusunda güncel adımı kayıtlardan sen bul; doğrulananı, henüz denenmeyeni, varsa yarım kalan işi veya engeli, ardından gerekçesiyle önerdiğin tek sonraki işi günlük dille anlat. Dayandığın kayıtları göster. Durum sorusu uygulama izni değildir.
- Proje türünü veya teknolojisini varsayma; koddan, yapılandırmadan ve belgelerden öğren, yetmezse sor.

## 3. Ne zaman ne okunur

| Durum | Okunacak bilgi |
|---|---|
| Yeni oturum veya araç değişimi | `docs/DURUM.md`; `docs/aktif-asama/PLAN.md` "Başlangıç", "Aşama kuralları" ve ilgili adım satırları; Git varsa `git status --short`, `git log --oneline -5` |
| Aynı sohbette yeni mesaj | Yeni kapsam ve değişen bilgi; bağlamdaki güncel belge yeniden okunmaz |
| "Nerede kaldık?" / durum sorusu | `docs/DURUM.md`, aktif planın ilgili adımı; geçerli karar için `docs/KARARLAR.md` dizini; gerekirse ilgili günlük/karar kaydı ve `docs/ACIK_KONULAR.md` |
| Kod değiştirmeden önce (alt adımı planlarken de) | İlgili kod/testler; adımın kabul ölçütü ve "İlgili kaynaklar"ı; `docs/PROJE.md` sözleşmeleri; kaynaklardaki kararların dizin durumu ve adım satırındaki `plan: K-xxx` işaretinden sonraki dizin satırları (işaret kaynak sayılmaz); işaret veya kaynakta karar yoksa ya da daraltma güvenilir değilse bütün dizin |
| Bağlam kaybı veya özetleme sonrası | DURUM, güncel adım, geçerli kapsam ve gerekli kaynaklar yeniden doğrulanır |
| Hata araştırması | Hata metni, konu veya K-numarasıyla `GUNLUK.md`, gerekirse `docs/arsiv/` araması |
| Aşama planlama, adım bölme, "N'yi planla" / kapanış / kapanmış aşamada hata | `docs/kurallar/PLANLAMA.md` / `docs/kurallar/ARSIVLEME.md` (hata için "Kurallar" bölümü) ve gereken proje belgeleri |
| Commit önerisi, commit, push, birleştirme, dal silme, CI sonucu | `docs/kurallar/GIT.md` (`git status`/`git log` için gerekmez) |
| PowerShell, kabuk, dosya kodlaması, dosya okuyan/yazan kod | `docs/kurallar/WINDOWS.md` ilgili bölümü |
| İnceleme katmanını belirleme; katman Zorunlu/Hafif | `docs/kurallar/INCELEME.md` |

- Tablo başlangıç noktasıdır, sınır değil: önce göreve işaret eden en dar kaynağı oku; kaynak eksikse, başka belgeye gönderiyorsa veya kodla çelişiyorsa ilgili kodu, testi, kararı ya da arşiv bölümünü kendin izle (güncel belgeden arşivdeki tasarıma verilen bağlantı için izin gerekmez).
- Bağlamdaki bilgi yeniden okunur: dosya dışarıdan değişmişse, dal değişmişse, kayıt ile kod çelişiyorsa veya bilgi artık bağlamda yoksa.
- `GUNLUK.md` ve `docs/arsiv/` her mesajda ve baştan sona okunmaz; aranır veya yalnız ilgili bölümü okunur. `docs/ACIK_KONULAR.md` ilgili konu gelince aranır.
- Aktif plan veya aşama yoksa bu normal başlangıçtır; olmayan dosya tekrar aranmaz.
- Kayıtlar çelişiyor veya eskimişse uygulamadan önce bildir. Codex ve Claude aynı projede aynı anda çalışmaz; araç değişince yeni sohbette önce durum özetlenir.

## 4. Kayıtlar: ne zaman ve nereye

Kayıt oturum sonuna bırakılmaz. Şu anlarda ilgili kayıtlar, kullanıcıya sonuç verilmeden önce güncellenir: alt adım bitti; doğrulama sonucu değişti; kullanıcı önemli karar verdi veya kapsamı değiştirdi; iş bir sorunla durdu; kullanıcı yanıtı bekleniyor; uzun işte yeniden üretmesi pahalı ara sonuç çıktı; oturum sonu veya araç değişimi (son kontrol). Her komut veya düzenleme için ayrı kayıt açılmaz; durumu değiştirmeyen sorularda belge güncellenmez. Sohbet planı için ayrı kayıt açılmaz: iş aynı sohbette biterse olağan sonuç kaydı yeter, kalıcı karar K-numarasıyla yazılır, yarım işte seçilen yaklaşım, tamamlanan kısım ve devam noktası `DURUM.md` dosyasına yazılır. Ani kesintide son kayıttan sonraki iş kaybolabilir.

| Bilgi | Dosya |
|---|---|
| Son iş, yarım kalan, engel, devam noktası | `docs/DURUM.md` (en fazla 30 satır, baştan yazılır) |
| Ana aşamalar | `docs/YOL_HARITASI.md` |
| Bekleyen karar ("en geç" aşamasıyla), devreden not | `docs/ACIK_KONULAR.md` |
| Karar dizini, proje geneli kararlar | `docs/KARARLAR.md` |
| Kodun güncel yapısı, komutlar, veri biçimleri, arayüzler | `docs/PROJE.md` |
| Aşama tasarımı, riskler, farklar | `docs/aktif-asama/TASARIM.md` |
| Alt adımlar ve durumları (durumun tek kaynağı) | `docs/aktif-asama/PLAN.md` |
| Yalnız bu aşamanın kararları | `docs/aktif-asama/KARARLAR.md` |
| Yapılan iş, kontrol, sonuç, hata → çözüm; commit, CI kimliği ve test sayısı | `docs/aktif-asama/GUNLUK.md` |
| Bilinen sınır | Bileşene ait: `docs/PROJE.md` veya bileşen dosyası; proje düzeyi: `docs/ACIK_KONULAR.md`; bu aşamada giderilecek: `PLAN.md` "Bilinen sınırlar" |

- Kayıt dosyasının başındaki açıklama bu dosyayla çelişirse bu dosya geçerlidir. Alt adım bitince `PLAN.md`, `GUNLUK.md` ve davranış/komut/yapı değiştiyse `docs/PROJE.md` güncellenir; "Doğrulandı" yazılan satır aynı anda kısaltılır (`PLANLAMA.md`). DURUM planı tekrar etmez, güncel adıma bağlantı verir; DURUM "Git" satırındaki son gözlenen commit dışında DURUM ve PLAN "Başlangıç" commit/CI kimliği ve test sayısı taşımaz.
- `GUNLUK.md`: alt adım başına hedef üç kısa kayıt, yeni hata/karar/kesinti için ek kayıt. Eski kayıt değiştirilmez, yanlışsa düzeltme kaydı eklenir; başarısız deneme sonradan başarılı gösterilmez.
- Kararlar `K-001` biçiminde proje boyunca artar, numara yeniden kullanılmaz; her kararın `docs/KARARLAR.md` dizininde satırı vardır. Tam metin, sonraki aşamaları etkiliyorsa `docs/KARARLAR.md`, etkilemiyorsa `docs/aktif-asama/KARARLAR.md` dosyasına yazılır; emin değilsen sor. Dizindeki kapsam yalnız "Proje geneli" veya "Aşama N" olur. Dizin geçerliliği ("Durum") ve yeri ("Tam metin") ayrı sütunlarda tutar; arşivleme yalnız yeri değiştirir. Anlamı değişen karar yeni numara alır; eski metin ve gerekçe korunur, dizinde eski kararın durumu yeni karara bağlanır ve arşivlemeyle silinmez.
- Kullanıcının seçimini karar olarak kaydet; henüz onaylamadığı ajan önerisini `docs/ACIK_KONULAR.md` içinde bekleyen konu olarak tut, kullanıcı kararı gibi sunma. Söylenmeyen gerekçe uydurulmaz. Aynı bilgi iki yere yazılmaz; ikinci yerde bağlantı verilir.
- `docs/PROJE.md` kodun şu anki hâlidir: ilgili bölüm yeniden yazılır, geçersiz bilgi silinir; yaklaşık 150 satırı geçerse bileşen dosyalarına bölmeyi öner, sonra yalnız ilgili bileşen okunur.
- Tarih ve saat kabuktan alınır. Proje durumu yalnız repo dosyalarına yazılır, aracın kendi hafızasına yazılmaz.

## 5. Akış, kapanış ve yeni kural

- Sıra: **genel araştırma → yol haritası → aşama araştırması → aşama planı → yetkili alt adımlar.** İsteğe bağlı: "1.2'yi planla" denirse yalnız 1.2'nin yaklaşımı ve doğrulaması sunulur, uygulama komutu beklenir; açık "1.2'yi uygula" için plan sunma zorunlu değildir. Ayrıntı: `docs/kurallar/PLANLAMA.md`.
- Aşama, alt adımları ve kapanış ölçütleri doğrulanınca kullanıcının "aşamayı kapat" demesiyle kapanır; `docs/kurallar/ARSIVLEME.md` uygulanır. Bu istek kapanışın mekanik işlerini kapsar; yeni karar, belirsiz bilgiyi silme ve sonraki aşamaya başlama ayrıca sorulur. Kapanmış aşamanın arşivi değiştirilmez; sonradan çıkan hata yeni alt adımla düzeltilir; kapanış commit'inin sonradan gelen sonucu yeni aktif `GUNLUK.md` dosyasına yazılır (`ARSIVLEME.md` "Kurallar").
- Kullanıcının kalıcı yeni kuralı bu dosyanın "Projeye özel kurallar" bölümüne, yalnız aktif aşamanınki `PLAN.md` "Aşama kuralları" bölümüne tek madde olarak eklenir. Mevcut kuralla çelişiyorsa önce sor; onaysız kural silinmez. Kırmızı çizgi için mekanik koruma (izin ayarı, test, kanca) öner; §1.6 kapsamındaki ayarı kullanıcı yapar.
- Kullanıcının projeye veya aşamaya özel kuralı ortak kuralla çelişirse özel kural geçerlidir; çelişkiyi uygulamadan önce bir kez bildir; §1'i gevşeten maddeyi bildirime onay gelmeden uygulama.
- Kritik yasaklar bu dosyada kalır; yalnız belirli işte gereken ayrıntı `docs/kurallar/proje-<konu>.md` dosyasına yazılır, burada tek satırlık işaretçi kalır. Kural eklerken bu dosyayı ölç; yaklaşık 20 bin karakteri geçiyorsa ayrıntıyı taşı veya düzenleme öner. Bütün projelerin ortak kuralı şablon deposundaki `genel/KURALLAR.md` dosyasında değişir.

## 6. Teknik kalite

- Önce mevcut kodu ve `docs/PROJE.md` dosyasını incele, yerleşik yapıya uy, dosyaları sorumluluklarına göre düzenle; etkiyi çağıranlar, veri biçimleri ve testler üzerinden kontrol et.
- Gereksiz karmaşıklık ekleme; sadelik uğruna gerekli doğrulama, hata yönetimi, güvenlik veya testi de çıkarma.
- Önemli bir karar isterken gerçek seçeneklerin kullanıcıya etkisini, proje amacına göre önerdiğin tercihi ve başlıca bedelini kısaca anlat; seçimi değiştirecek öncelik belirsizse günlük dille sor. Seçimi kullanıcı yapar.
- Kullanıcının iddiası kod, test veya güncel proje belgesiyle çelişiyorsa açıkça düzelt; kanıtın yerini ve kullanıcı için sonucunu kısaca belirt. Yalnız kod/belge okumayı çalıştırılmış testten ayır; eldeki kanıt yetmiyorsa belirsizliği açık bırak.
- Doğrulanmamış bilgiyi kesin gibi sunma, "doğrulanmadı" diye işaretle. Belirsizlikte: projede ara → resmî kaynakta doğrula → kullanıcıya sor; sorulması gereken konuda tahminle ilerleme. Dış kaynağı belirt, okunanı çıkarımdan ayır. Oturum açma, kapalı/ücretli kaynak veya canlı sistem gerektiren araştırmada neyin öğrenileceğini ve nereye bakılacağını söyle; ona bağlı adım sonucu bekler. Hata ayıklarken hipotezi test, log veya küçük denemeyle sına; neden doğrulanmadan "çözüldü" deme. Düşük riskli ayrıntıda (ad, biçim, yerleşim) mevcut düzene uy, özette belirt.
- Silmeden önce dosya, fonksiyon veya ayarın adını projede ara. Kodda eksik yer tutucu bırakma.

## 7. Test ve doğrulama

- Davranış değişince test yaz veya güncelle; test, uygulamanın kopyası değil beklenen sonuç üzerinden kurulur. Yeni test aracı veya bağımlılık için önce sor.
- Alt adımda ilgili testler, aşama kapanışında bütün testler çalıştırılır. Komutlar `docs/PROJE.md` içindedir; yoksa `docs/kurallar/PLANLAMA.md` "Test komutu" bölümüne göre bulunur. Komut uydurulmaz; ağa, canlı sisteme veya gerçek veriye dokunabilecek komut sorulur.
- Başarılı, başarısız, atlanan ve çalıştırılamayan kontroller ayrı yazılır; atlanan varsa "hepsi geçti" denmez.
- Hata düzeltmeden önce hata metnini `GUNLUK.md` ve gerekirse `docs/arsiv/` içinde ara. Kontrolü kapatıp hatayı gizlemek çözüm değildir.
- Gerçek veriyi veya canlı sistemi değiştiren komutu kullanıcı çalıştırır; ajan komutu ve çıktıda neye bakılacağını verir.
- Veri kaybı, güvenlik, gerçek para veya geri alınması zor işlemde `docs/kurallar/INCELEME.md` uygulanır.

## 8. Git ve kabuk

- Depo, uzak adres ve Git kimliği kullanıcıya aittir; ajan bunları ayarlamaz, eksikse bildirir. Otomatik commit/push kurulmaz.
- Komut çalıştırmadan önce hangi kabukta olduğunu bil; Windows PowerShell 5.1'de `&&` ve `||` yoktur.

## Projeye özel kurallar

Proje ilerledikçe kullanıcının verdiği kalıcı kurallar buraya tek tek eklenir.

- Henüz yok.
