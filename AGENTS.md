# Çalışma kuralları

Bu dosya her oturumda otomatik yüklenir, bu yüzden kısa tutulur. Ayrıntılı prosedürler `docs/kurallar/` altındadır ve yalnız ilgili iş yapılırken okunur.

## 1. Kırmızı çizgiler

1. Uygulama izni yalnız kullanıcının mesajından gelir. Plan, durum notu veya "sıradaki adım" yazısı izin değildir.
2. Yalnız kullanıcının açıkça yetkilendirdiği kapsam uygulanır: tek alt adım ("yalnız 2.3") veya açık bir aralık ("2.3–2.5"). İşe başlarken kapsamı tek satırla yaz (`Kapsam: 2.3–2.5`). Aralık içinde adımlar arasında onay beklenmez; her adım bitince `PLAN.md` ve `GUNLUK.md` güncellenir. Kapsam bitince özetle, commit öner ve dur; kullanıcı aksini söylemedikçe aralık için tek commit önerilir. Kapsam dışına kendiliğinden geçme; aralık içinde §3'teki dur-danış durumlarından biri çıkarsa o noktada dur.
3. `git add .` / `git add -A` kullanılmaz. Commit kullanıcının açık onayıyla, push ayrı onayla yapılır. `git push --force`, `git reset --hard`, `git clean` ve toplu silme açık onay ister.
4. Şifre, anahtar ve token hiçbir dosyaya, komuta veya mesaja yazılmaz. `.env` ve gizli ayar değişikliği önce sorulur.
5. Çalıştırılmayan test veya gözlenmeyen sonuç "doğrulandı" diye yazılmaz.
6. Global ayar, skill, eklenti ve `.claude` / `.codex` klasörleri değiştirilmez.

## 2. İletişim

- Bütün açıklamalar ve belgeler Türkçedir. Kod tanımlayıcıları İngilizce, kod yorumları Türkçedir ve yalnız gerekçeyi anlatır.
- Teknik terim ilk geçtiğinde yarım cümleyle açıklanır; aynı oturumda aynı terim tekrar açıklanmaz.
- Adım sonu özeti kısadır: ne yapıldı, neden, nasıl doğrulandı, açık kalan ne.
- Proje türünü veya teknolojisini varsayma; koddan, yapılandırma dosyalarından ve belgelerden öğren, yetmezse kullanıcıya sor.

## 3. Çalışma akışı

Sıra: **genel araştırma → yol haritası → aşama araştırması → aşama planı → tek alt adım uygulaması.**

- Kullanıcı genel araştırma belgelerini `docs/arastirma/` altına koyar. Yol haritası bunlardan hazırlanır: yalnız ana aşamalar ve her birinin 1–2 cümlelik amacı. Aşama ayrıntısı yol haritasına yazılmaz.
- Bir aşamaya başlamadan kullanıcı o aşamanın araştırma belgelerini `docs/aktif-asama/arastirma/` altına koyar. Ajan aşama planını bu belgelere, yol haritasına, `docs/PROJE.md`, `docs/KARARLAR.md` ve `docs/ACIK_KONULAR.md` dosyalarına göre yazar: tasarımı (araştırmadan çıkan tasarım, riskler, yol haritasından ve araştırmadan farklar, alt adım sıralama gerekçesi) `docs/aktif-asama/TASARIM.md` dosyasına, alt adım tablosunu `docs/aktif-asama/PLAN.md` dosyasına yazar. Plana başlarken yol haritasının hâlâ geçerli olup olmadığını kontrol eder; değişiklik gerekiyorsa önerir, kendisi değiştirmez. `docs/aktif-asama/arastirma/` içinde `BENIOKU.md` dışında belge yoksa planı hemen yazmaz: mevcut kod ve proje belgelerinden çıkardığı bilgiyi ve eksik kalanı birkaç satırla özetler ve tek soru sorar: "Araştırma belgesi eklenecek mi, yoksa bu bilgiyle plan yazayım mı?" Kullanıcı onaylarsa planı yazar ve `TASARIM.md` içinde "Araştırma belgesi yok; kaynak: kod ve proje belgeleri" diye belirtir.
- Alt adımlar `1.1`, `1.2` gibi kalıcı numaralar alır. Her birinin kapsamı, kabul ölçütü, doğrulama yöntemi ve inceleme katmanı yazılır. Büyük adım `1.2.1` gibi bölünebilir; bölmek uygulama izni değildir.
- Planı kabul etmek kod yazma izni değildir. Belirsiz "devam" mesajında hangi adımın kastedildiğini sor.
- Şu durumlarda dur ve danış: planda olmayan iş (küçük iş istisnası dışında), kapsam değişikliği, yeni bağımlılık, mimari seçim, gizli ayar, biten aşamanın arayüzünü değiştirme, çözülemeyen test hatası, geri alınması zor işlem.
- Yetkili adımın içinde her dosya düzenlemesi için yeniden izin isteme.
- Küçük iş istisnası: kullanıcının mesajında doğrudan istenen; birkaç dosyayla sınırlı; yeni bağımlılık, mimari seçim, veri biçimi veya arayüz değişikliği içermeyen ve `docs/kurallar/INCELEME.md` "Zorunlu" ya da "Hafif" katmanına girmeyen iş (yazım hatası, küçük hata düzeltmesi, belge düzeltmesi) plan adımı açılmadan yapılır. Aktif aşama varsa `GUNLUK.md` dosyasına tek satır "Plan dışı küçük iş: …" yazılır. İş bu sınırları aşarsa dur ve plan adımı öner. Commit kuralları değişmez.

## 4. Oturum başı ve sonu

Bağlamı küçük tutmak için okuma sırası sabittir:

1. `docs/DURUM.md`
2. `docs/aktif-asama/PLAN.md`
3. Git deposu varsa `git status --short` ve `git log --oneline -5`

Yalnız gerektiğinde okunur: `docs/PROJE.md`, `docs/KARARLAR.md` (önce dizini), `docs/YOL_HARITASI.md`, `docs/aktif-asama/TASARIM.md` (yalnız ilgili bölüm), `docs/aktif-asama/KARARLAR.md`, ilgili araştırma belgesi. `docs/ACIK_KONULAR.md` aşama planlarken, aşama kapatırken ve ilgili konu gelince aranarak okunur.

**Okunmaz:** `docs/arsiv/`. Yalnız kullanıcı isterse veya eski bir hata ya da karar aranıyorsa bakılır; o zaman da önce metin araması yapılır, dosya baştan sona okunmaz. `GUNLUK.md` dosyaları da baştan sona okunmaz, aranır.

Kayıtlar arasında çelişki veya eskimiş bilgi varsa uygulamaya başlamadan kullanıcıya bildir. Oturum sonunda ve araç değişiminden önce `docs/DURUM.md` baştan yazılır. Codex ve Claude aynı projede aynı anda çalışmaz; yeni araçta yeni sohbet açılır ve önce durum özetlenir.

## 5. Kayıtlar: ne nereye yazılır

| Bilgi | Dosya |
|---|---|
| Şu an neredeyiz, yarım kalan | `docs/DURUM.md` (en fazla 30 satır, her seferinde baştan yazılır) |
| Ana aşamalar ve durumları | `docs/YOL_HARITASI.md` |
| Henüz verilmemiş karar ("en geç" aşamasıyla), proje düzeyi bilinen sınır, sonraki aşamalara devreden not | `docs/ACIK_KONULAR.md` |
| Karar dizini (bütün kararlar, tek satır) ve proje geneli kararların tam metni | `docs/KARARLAR.md` |
| Kodun güncel yapısı, komutlar, veri biçimleri, arayüzler, teknik sınırlar | `docs/PROJE.md` |
| Aktif aşamanın tasarımı, riskleri, farkları (durum yazılmaz) | `docs/aktif-asama/TASARIM.md` |
| Aktif aşamanın alt adımları ve durumları (durumun tek kaynağı) | `docs/aktif-asama/PLAN.md` |
| Yalnız aktif aşamayı ilgilendiren kararların tam metni | `docs/aktif-asama/KARARLAR.md` |
| Yapılan iş, çalıştırılan kontrol, sonuç, hata → çözüm | `docs/aktif-asama/GUNLUK.md` |
| Kullanıcının verdiği kalıcı yeni kural | Bu dosyanın "Projeye özel kurallar" bölümü |

- Karar numaraları `K-001`, `K-002` … biçimindedir, bütün proje boyunca artar ve yeniden kullanılmaz. Her kararın `docs/KARARLAR.md` dizininde tek satırı bulunur (no, başlık, kapsam: Proje geneli veya Aşama N, durum). Yeni numara, dizindeki en yüksek numaranın bir fazlasıdır.
- Karar yazarken sor: "Bu karar sonraki aşamaları etkiler mi?" Evet ise tam metin `docs/KARARLAR.md`, hayır ise `docs/aktif-asama/KARARLAR.md` dosyasına yazılır; her iki durumda dizine satır eklenir. Emin değilsen kullanıcıya sor.
- Kullanıcının kararı ile ajanın önerisi ayrı yazılır; öneri karar gibi kaydedilmez.
- Aynı bilgi iki yere yazılmaz; ikinci yerde bağlantı verilir.
- Kayıtlar şişmesin: `GUNLUK.md` içinde alt adım başına en çok üç kayıt yazılır, komut çıktısı yapıştırılmaz (komut, sayı ve sonuç yazılır). `PLAN.md` içinde "Doğrulandı" olan alt adım satırı yaklaşık 300 karaktere indirilir: tek cümlelik kapsam, doğrulama özeti (commit, test sayısı) ve `GUNLUK.md` bağlantısı; kabul ölçütü ve ayrıntı günlükte ve tasarımda kalır.
- Alt adım bitince güncellenir: aşama `PLAN.md` durumu, `GUNLUK.md`, ve davranış/komut/yapı değiştiyse `docs/PROJE.md`.
- `docs/PROJE.md` kodun şu anki hâlidir: yeni bilgi sona eklenmez, ilgili bölüm yeniden yazılır; artık geçerli olmayan bilgi silinir. Dosya yaklaşık 150 satırı geçerse bileşen dosyalarına bölünür (`docs/proje/<bileşen>.md`); `PROJE.md` kısa bir dizin olarak kalır ve ajan yalnız ilgili bileşen dosyasını okur. Bölmeyi önce kullanıcıya öner.
- Tarih ve saat kabuktan alınır, tahmin edilmez.
- Proje durumu yalnız repo dosyalarına yazılır; aracın kendi hafızasına yazılmaz.

## 6. Çalışırken yeni kural verildiğinde

- Bütün proje için kalıcı kural: bu dosyanın sonundaki "Projeye özel kurallar" bölümüne tek madde olarak eklenir.
- Yalnız aktif aşama için kural: `docs/aktif-asama/PLAN.md` içindeki "Aşama kuralları" bölümüne eklenir ve aşamayla birlikte arşive gider.
- Yeni kural mevcut bir kuralla çelişiyorsa eklemeden önce sor.
- Her oturumda bilinmesi gereken kritik yasaklar bu dosyada kalır. Yalnız belirli işlerde gereken ayrıntılı kurallar `docs/kurallar/proje-<konu>.md` dosyasına yazılır; bu dosyada tek satırlık işaretçi bırakılır ("X işlerinde `docs/kurallar/proje-x.md` oku"). Bu dosya (`AGENTS.md`) yaklaşık 20 bin karakteri geçmemeli: her yeni kural eklerken dosyanın boyutunu ölç; eşik aşılıyorsa kuralı `proje-<konu>.md` dosyasına yaz veya kullanıcıya düzenleme öner. Tekrar veya çelişen madde oluşursa aşama kapanışında da düzenleme öner. Kullanıcı onaylamadan kural silinmez.
- Bütün projelerde geçerli ortak kural şablon deposundaki `genel/KURALLAR.md` dosyasında değiştirilir; kurulmuş projeler kendiliğinden değişmez.

## 7. Aşama kapanışı ve arşiv

Aşama; bütün alt adımları ve kapanış ölçütleri doğrulanınca, kullanıcının "aşamayı kapat" demesiyle kapanır. Kapanışta `docs/kurallar/ARSIVLEME.md` okunur ve adım adım uygulanır.

Özü: sonraki aşamaları etkileyen her şey aktif belgelere taşınır, `docs/aktif-asama/` klasörünün geri kalanı bütünüyle `docs/arsiv/NN-ad/` altına taşınır ve yerine boş bir aşama klasörü açılır. Böylece sonraki aşamada eski aşamanın yazıları okunmaz. Kapanış, sonraki aşamaya başlama izni değildir.

Kapanmış bir aşamada sonradan hata çıkarsa arşiv değiştirilmez. Düzeltme aktif aşamada yeni alt adım olarak yapılır; yeni aşama henüz seçilmediyse (aktif `PLAN.md` boştur) kapanmış aşamanın numarasıyla devam eden bir alt adım açılır (ör. aşama 1 kapandıysa `1.11`). Ayrıntı `docs/kurallar/ARSIVLEME.md` "Kurallar" bölümündedir.

## 8. Teknik kalite

- Önce mevcut kodu ve `docs/PROJE.md` dosyasını incele; yerleşik yapıya uy. Dosyaları sorumluluklarına göre düzenle.
- Değişikliğin etkisini yalnız değişen dosyada değil; çağıranlar, veri biçimleri ve testler üzerinden kontrol et.
- Gereksiz karmaşıklık ekleme; sadelik uğruna gerekli doğrulama, hata yönetimi, güvenlik veya testi de çıkarma.
- Önemli tasarım seçiminde gerçek seçenekleri kısa yarar/bedel ile sun; seçimi kullanıcı yapar.
- Varsayım yasağı: doğrulanmamış bilgiyi kesin bilgi gibi sunma; doğrulanamayanı "doğrulanmadı" diye işaretle. Sonucu etkileyen belirsizlikte sıra: projede ara (kod, `docs/`, kararlar) → yetmezse resmî kaynakta doğrula → hâlâ belirsizse kullanıcıya sor; sorulması gereken konuda tahminle ilerleme. Hata ayıklarken hipotez kurup test, log veya küçük yerel denemeyle sınamak serbesttir; neden doğrulanana kadar "çözüldü" denmez. Düşük riskli ve kolay geri alınan ayrıntılarda (ad, biçim, dosya içi yerleşim) projenin mevcut düzenine uyan seçimi yap ve özette belirt.
- Silmeden önce dosya, fonksiyon veya ayarın adını projede ara. Kodda eksik yer tutucu bırakma.

## 9. Test ve doğrulama

- Davranış değişince test yaz veya güncelle. Test, uygulamanın kopyası değil beklenen sonuç üzerinden kurulur.
- Alt adımda ilgili testler, aşama kapanışında bütün testler çalıştırılır. Test komutları `docs/PROJE.md` içindedir. Orada yoksa projede tanımlı komut aranır (`package.json` script'leri, `pyproject.toml`, `Makefile`, CI dosyaları, test klasörleri). Açıkça tanımlı ve yalnız yerel test çalıştıran tek bir komut bulunursa çalıştırılır ve `docs/PROJE.md` içine yazılır. Komut bulunamazsa, birden fazla aday varsa veya komut ağa, canlı sisteme ya da gerçek veriye dokunabiliyorsa uydurulmaz, kullanıcıya sorulur.
- Başarısız, atlanan ve çalıştırılamayan kontroller ayrı yazılır; atlanan varsa "hepsi geçti" denmez.
- Hata düzeltmeden önce hata mesajını aktif `GUNLUK.md` ve gerekiyorsa `docs/arsiv/` içinde ara. Nedeni doğrulamadan "çözüldü" deme; kontrolü kapatıp hatayı gizlemek çözüm değildir.
- Yeni test aracı veya bağımlılık için önce sor.
- Gerçek veriyi veya canlı sistemi değiştiren komutu kullanıcı çalıştırır; ajan komutu ve çıktıda neye bakılacağını verir.
- Veri kaybı, güvenlik, gerçek para veya geri alınması zor işlem içeren adımlarda `docs/kurallar/INCELEME.md` uygulanır.

## 10. Git

- Depo, uzak adres ve Git kimliği kullanıcıya aittir; ajan bunları ayarlamaz, eksikse bildirir.
- Sıra: ilgili doğrulamalar → değişen dosya listesi ve Türkçe commit mesajı önerisi → kullanıcı onayı → commit. Push ayrıca onay ister.
- Dosyalar tek tek eklenir; `.gitignore` kapsamındaki dosyalar commit'e katılmaz.
- Commit ve PR açıklamasına yapay zekâ imzası veya `Co-Authored-By` eklenmez.

## 11. Windows

- Komut çalıştırmadan önce hangi kabukta olduğunu bil. PowerShell 5.1'de `&&` ve `||` yoktur; komutları ayrı çalıştır.
- Türkçe terminal çıktısı için `[Console]::OutputEncoding = [Text.Encoding]::UTF8`.
- `.ps1` dosyaları UTF-8 BOM'lu; Markdown, JSON ve YAML dosyaları UTF-8 BOM'suz kaydedilir.
- Türkçe commit mesajı BOM'suz UTF-8 bir dosyaya yazılıp `git commit -F` ile kullanılır.

## Projeye özel kurallar

- Bu depo AI proje şablonunun kaynağıdır; örnek ürün uygulaması değildir.
- Hedef projeye kurulan kuralların kaynağı `genel/KURALLAR.md` dosyasıdır. Ortak kural değişince önce orada yapılır; bu dosyanın üst kısmı aynı adımda ona eşitlenir, bu bölüm korunur.
- Kurulan başlangıç belgeleri `sablon/docs/` altındadır; buraya bu deponun geliştirme kaydı yazılmaz. Kurulacak dosya listesi `surum.json` içindedir.
- Bu deponun kendi durumu `docs/DURUM.md` dosyasındadır (en fazla 30 satır). v0.1 geliştirme geçmişi `docs/arsiv/v0.1-gelistirme/`, v0.2 doğrulama kayıtları `docs/arsiv/v0.2-gelistirme/DOGRULAMA.md` içindedir; bunlar her oturumda okunmaz.
- Kurucu değişikliği Windows PowerShell 5.1 ile geçici bir hedef klasörde denenir; gerçek proje klasörü kullanılmaz.
- `genel/KURALLAR.md` ortak kısmı değiştiğinde, değişiklikten önceki ortak kısmın LF hash'i aynı commit'te `surum.json` içindeki `knownAgentsCommonLfSha256` listesine eklenir. `tests/bilinen-hashler.ps1` bunu git geçmişinden denetler.
