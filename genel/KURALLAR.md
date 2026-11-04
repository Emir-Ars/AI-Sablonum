# Çalışma kuralları

Bu dosya her oturumda otomatik yüklenir, bu yüzden kısa tutulur. Ayrıntılı prosedürler `docs/kurallar/` altındadır ve yalnız ilgili iş yapılırken okunur.

## 1. Kırmızı çizgiler

1. Uygulama izni yalnız kullanıcının mesajından gelir. Plan, durum notu veya "sıradaki adım" yazısı izin değildir.
2. Bir seferde yalnız kullanıcının seçtiği alt adım uygulanır. Bitince özetle, commit öner ve dur; sonraki adıma kendiliğinden geçme.
3. `git add .` / `git add -A` kullanılmaz. Commit kullanıcının açık onayıyla, push ayrı onayla yapılır. `git push --force`, `git reset --hard`, `git clean` ve toplu silme açık onay ister.
4. Şifre, anahtar ve token hiçbir dosyaya, komuta veya mesaja yazılmaz. `.env` ve gizli ayar değişikliği önce sorulur.
5. Çalıştırılmayan test veya gözlenmeyen sonuç "doğrulandı" diye yazılmaz.
6. Global ayar, skill, eklenti ve `.claude` / `.codex` klasörleri değiştirilmez.

## 2. İletişim

- Bütün açıklamalar ve belgeler Türkçedir. Kod tanımlayıcıları İngilizce, kod yorumları Türkçedir ve yalnız gerekçeyi anlatır.
- Teknik terim ilk geçtiğinde yarım cümleyle açıklanır.
- Adım sonu özeti kısadır: ne yapıldı, neden, nasıl doğrulandı, açık kalan ne.
- Proje türünü veya teknolojisini varsayma; belgelerden ve kullanıcıdan öğren.

## 3. Çalışma akışı

Sıra: **genel araştırma → yol haritası → aşama araştırması → aşama planı → tek alt adım uygulaması.**

- Kullanıcı genel araştırma belgelerini `docs/arastirma/` altına koyar. Yol haritası bunlardan hazırlanır: yalnız ana aşamalar ve her birinin 1–2 cümlelik amacı. Aşama ayrıntısı yol haritasına yazılmaz.
- Bir aşamaya başlamadan kullanıcı o aşamanın araştırma belgelerini `docs/aktif-asama/arastirma/` altına koyar. Ajan aşama planını bu belgelere, yol haritasına, `docs/PROJE.md`, `docs/KARARLAR.md` ve `docs/ACIK_KONULAR.md` dosyalarına göre yazar: tasarımı (araştırmadan çıkan tasarım, riskler, yol haritasından ve araştırmadan farklar, alt adım sıralama gerekçesi) `docs/aktif-asama/TASARIM.md` dosyasına, alt adım tablosunu `docs/aktif-asama/PLAN.md` dosyasına yazar. Plana başlarken yol haritasının hâlâ geçerli olup olmadığını kontrol eder; değişiklik gerekiyorsa önerir, kendisi değiştirmez.
- Alt adımlar `1.1`, `1.2` gibi kalıcı numaralar alır. Her birinin kapsamı, kabul ölçütü, doğrulama yöntemi ve inceleme katmanı yazılır. Büyük adım `1.2.1` gibi bölünebilir; bölmek uygulama izni değildir.
- Planı kabul etmek kod yazma izni değildir. Belirsiz "devam" mesajında hangi adımın kastedildiğini sor.
- Şu durumlarda dur ve danış: planda olmayan iş, kapsam değişikliği, yeni bağımlılık, mimari seçim, gizli ayar, biten aşamanın arayüzünü değiştirme, çözülemeyen test hatası, geri alınması zor işlem.
- Yetkili adımın içinde her dosya düzenlemesi için yeniden izin isteme.

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
- Kayıtlar şişmesin: `GUNLUK.md` içinde alt adım başına en çok üç kayıt yazılır, komut çıktısı yapıştırılmaz (komut, sayı ve sonuç yazılır). `PLAN.md` içinde "Doğrulandı" olan alt adım satırı yaklaşık 1 KB'a indirilir: kısa kapsam, kısa kabul ölçütü, doğrulama özeti (commit, test sayısı) ve `GUNLUK.md` bağlantısı; ayrıntı günlükte ve tasarımda kalır.
- Alt adım bitince güncellenir: aşama `PLAN.md` durumu, `GUNLUK.md`, ve davranış/komut/yapı değiştiyse `docs/PROJE.md`.
- `docs/PROJE.md` kodun şu anki hâlidir: yeni bilgi sona eklenmez, ilgili bölüm yeniden yazılır; artık geçerli olmayan bilgi silinir. Dosya yaklaşık 150 satırı geçerse bileşen dosyalarına bölünür (`docs/proje/<bileşen>.md`); `PROJE.md` kısa bir dizin olarak kalır ve ajan yalnız ilgili bileşen dosyasını okur. Bölmeyi önce kullanıcıya öner.
- Tarih ve saat kabuktan alınır, tahmin edilmez.
- Proje durumu yalnız repo dosyalarına yazılır; aracın kendi hafızasına yazılmaz.

## 6. Çalışırken yeni kural verildiğinde

- Bütün proje için kalıcı kural: bu dosyanın sonundaki "Projeye özel kurallar" bölümüne tek madde olarak eklenir.
- Yalnız aktif aşama için kural: `docs/aktif-asama/PLAN.md` içindeki "Aşama kuralları" bölümüne eklenir ve aşamayla birlikte arşive gider.
- Yeni kural mevcut bir kuralla çelişiyorsa eklemeden önce sor.
- Her oturumda bilinmesi gereken kritik yasaklar bu dosyada kalır. Yalnız belirli işlerde gereken ayrıntılı kurallar `docs/kurallar/proje-<konu>.md` dosyasına yazılır; bu dosyada tek satırlık işaretçi bırakılır ("X işlerinde `docs/kurallar/proje-x.md` oku"). Bu dosya yaklaşık 15 bin karakteri geçerse veya tekrar/çelişen madde oluşursa aşama kapanışında düzenleme öner; kullanıcı onaylamadan kural silinmez.
- Bütün projelerde geçerli ortak kural şablon deposundaki `genel/KURALLAR.md` dosyasında değiştirilir; kurulmuş projeler kendiliğinden değişmez.

## 7. Aşama kapanışı ve arşiv

Aşama; bütün alt adımları ve kapanış ölçütleri doğrulanınca, kullanıcının "aşamayı kapat" demesiyle kapanır. Kapanışta `docs/kurallar/ARSIVLEME.md` okunur ve adım adım uygulanır.

Özü: sonraki aşamaları etkileyen her şey aktif belgelere taşınır, `docs/aktif-asama/` klasörünün geri kalanı bütünüyle `docs/arsiv/NN-ad/` altına taşınır ve yerine boş bir aşama klasörü açılır. Böylece sonraki aşamada eski aşamanın yazıları okunmaz. Kapanış, sonraki aşamaya başlama izni değildir.

## 8. Teknik kalite

- Önce mevcut kodu ve `docs/PROJE.md` dosyasını incele; yerleşik yapıya uy. Dosyaları sorumluluklarına göre düzenle.
- Değişikliğin etkisini yalnız değişen dosyada değil; çağıranlar, veri biçimleri ve testler üzerinden kontrol et.
- Gereksiz karmaşıklık ekleme; sadelik uğruna gerekli doğrulama, hata yönetimi, güvenlik veya testi de çıkarma.
- Önemli tasarım seçiminde gerçek seçenekleri kısa yarar/bedel ile sun; seçimi kullanıcı yapar.
- Belirsizlik bir kararı etkiliyorsa önce projede, yetmezse resmî kaynakta doğrula. Doğrulanamayanı "doğrulanmadı" diye işaretle.
- Silmeden önce dosya, fonksiyon veya ayarın adını projede ara. Kodda eksik yer tutucu bırakma.

## 9. Test ve doğrulama

- Davranış değişince test yaz veya güncelle. Test, uygulamanın kopyası değil beklenen sonuç üzerinden kurulur.
- Alt adımda ilgili testler, aşama kapanışında bütün testler çalıştırılır. Test komutları `docs/PROJE.md` içindedir.
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

Proje ilerledikçe kullanıcının verdiği kalıcı kurallar buraya tek tek eklenir.

- Henüz yok.
