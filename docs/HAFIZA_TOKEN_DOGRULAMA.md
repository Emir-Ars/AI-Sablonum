# Hafıza ve token iyileştirmesi — doğrulama raporu

- Son güncelleme: 2026-11-06 14:02:02 +03:00
- Yetkilendirilen kapsam: H0–H8 (kullanıcı mesajı, 2026-11-06). Kural değişiklikleri ve gerekli belge/test güncellemeleri onaylı; commit ve push ayrıca onay bekler.
- Kapsam kaynağı: kökteki `GOREV_HAFIZA_VE_TOKEN_IYILESTIRME.md` (`.gitignore` kapsamında, Git dışında). Kalıcı kapsam, kabul ölçütleri ve sonuçlar bu rapordadır.
- Güncel kısa özet: [DURUM.md](DURUM.md).

## Durum

| Adım | Kabul ölçütü (özet) | Durum |
|---|---|---|
| H0 | Başlangıç kayıtlı; kullanıcı değişiklikleri korunmuş; şablonlara geliştirme geçmişi yazılmamış | Tamamlandı |
| H1 | Son kayıt noktasındaki iş ve devam bilgisi dosyalardan anlaşılıyor; kesintide kayıpsızlık iddia edilmiyor | Uygulandı; yerel denemeler geçti |
| H2 | Yeni oturum, aynı sohbet ve bağlam kaybı ayrı tanımlı; güncel karar ve teknik bilgiye erişim korunmuş | Uygulandı; yerel denemeler geçti |
| H3 | Adımın kaynakları adımdan bulunuyor; uzun planın tamamı her başlangıçta okunmuyor | Uygulandı; yerel denemeler geçti |
| H4 | Dördüncü önemli olay kaydedilebiliyor; değişen kararın eski ve yeni gerekçesi bulunuyor; numaralar yeniden kullanılmıyor | Uygulandı; yerel denemeler geçti |
| H5 | Ana kurallar kısalmış veya kalan uzunluk gerekçeli; kritik kurallar korunmuş; taşınan ayrıntının okunma zamanı açık | Uygulandı; −%21, hedef %12,5 aşıldı, gerekçe aşağıda |
| H6 | Olağan kayıt ve arşivlemede gereksiz onay yok; yeni karar, silme, commit ve push sınırları korunmuş | Uygulandı |
| H7 | Yeni kurulum bütün rehberleri alıyor; eski projede özel kurallar ve hafıza korunuyor; geçiş yolu belgelenmiş | Uygulandı; U18 ve R1 geçti |
| H8 | Kontroller ayrı ayrı raporlanmış; ölçümler ve denemeler kayıtlı | Yerel kontroller ve inceleme tamam; CI ve gerçek yeni oturum çalıştırılamadı |

## H0 — Başlangıç

- Başlangıç commit'i: `32c889c` (main). `git status --short`: temiz. İzlenmeyen ve `.gitignore` kapsamındaki yerel dosyalar: üç `GOREV_*.md`, iki araştırma raporu; hiçbirine dokunulmadı.
- İncelenenler: kök `AGENTS.md`, `CLAUDE.md`, `docs/DURUM.md`, `genel/KURALLAR.md`, `sablon/docs/` altındaki bütün belgeler, `surum.json`, `README.md`, `kur.ps1`, `guncelle.ps1`, `tests/kur-smoke.ps1`, `tests/bilinen-hashler.ps1`, CI iş akışı, `docs/DOGRULAMA_v0.3.1.md`. Arşiv yalnız metin aramasıyla tarandı.
- Bu şablon kaynağında aktif `PLAN.md`/`GUNLUK.md` yok; şablonlar sırf bu iş için doldurulmadı, çalışma bu raporda izleniyor.
- İnceleme katmanı (`sablon/docs/kurallar/INCELEME.md`): **Hafif**. Gerekçe: ortak kurallar ve kurulum listesi bütün kurulu projelerin kullandığı ortak arayüzdür; kısaltmada kritik kural kaybı testlerle kolay yakalanmaz. Veri kaybı, güvenlik veya geri alınması zor işlem yok; kurucu/güncelleyici kodu değişmedi. Gereken: iş bitince bağımsız alt ajan incelemesi. Kendi kontrollerim bağımsız inceleme sayılmaz.

## Yapılan değişiklikler (H1–H7)

- **H1 kayıt anları:** ortak kurallar §4 kayıt tetikleyicilerini (alt adım bitti, doğrulama değişti, karar/kapsam değişti, iş durdu, yanıt bekleniyor, pahalı ara sonuç, oturum sonu) ve "ani kesintide son kayıttan sonrası kaybolabilir" sınırını içeriyor. `sablon/docs/DURUM.md` yeni alanlar: son güncelleme, aktif aşama, güncel adım bağlantısı, son doğrulama kaydı, Git notu, son yapılan, yarım kalan, engel/beklenen yanıt, sonraki devam noktası, devreden işler (29 satır). Günlük şablonunda "Yarım kaldıysa" alanı.
- **H2 okuma tablosu:** ortak kurallar §3; yeniden okuma koşulları (dosya dışarıdan değişti, dal değişti, kayıt-kod çelişkisi, bilgi bağlamda yok); günlük/arşiv zorunlu okuma listesinde değil; plan yoksa normal başlangıç. `CLAUDE.md` ve kurucunun ürettiği metni değişmedi (`@AGENTS.md`).
- **H3 kaynaklar:** `PLAN.md` şablonunda "Başlangıç" bölümü (≤15 satır) ve "İlgili kaynaklar" sütunu; aralık yetkisinde bütün adımların kabul ölçütü ve kaynakları incelenir (§1.2); kısaltmada kabul ölçütünün korunması (`PLANLAMA.md`); arşivlemede kaynak bağlantılarının düzeltilmesi (`ARSIVLEME.md` adım 7).
- **H4 günlük ve karar:** "en çok üç kayıt" kesin sınırı hedefe çevrildi; ek kayıt, düzeltme kaydı biçimi, başarısız denemeyi başarılı göstermeme. Kararlarda anlam değişince yeni K-numarası, eski metin ve gerekçe korunur, "Önceki karar" alanı; arşivdeki karar için yeni kayıt ve dizinle ilişki; eski arşivi yeni biçime uydurmak için yeniden yazmama.
- **H5 kısaltma:** ayrıntılar `sablon/docs/kurallar/PLANLAMA.md` (yol haritası, aşama planı, PLAN yapısı, test komutu bulma), `GIT.md` (commit/push sırası, üç kayıt durumu), `WINDOWS.md` (kabuk, kodlama) dosyalarına taşındı. ARSIVLEME ve INCELEME ayrımı korundu. PROJE ve KARARLAR kuralları kendi şablon başlıklarına alındı.
- **H6 onaylar:** olağan kayıt güncellemesi için yeniden onay yok (§1); `ARSIVLEME.md` "Yetki" bölümü mekanik işleri kapsama alıyor, yeni karar/erteleme, dayanaksız kapsam değişikliği, aşama kuralını yayma, belirsiz silme, arşivin üzerine yazma, "öner" düzenlemeleri ve sonraki aşama için soruyor; arşivleme genel silme yetkisi değil. README'de üç kayıt durumu, hafızanın yeri ve `.ai-sablon/kurulum.json` açıklaması.
- **H7 paket:** `surum.json` 0.3.1 → 0.3.2; üç yeni `copyFiles` eşlemesi (`sablon/docs/kurallar/` → `docs/kurallar/`); değişiklik öncesi ortak kısmın LF SHA-256'sı `244f17c81385dae3b0c548b7607c3424d5f1e06adf12bef1aad50249f642b78f` listeye eklendi (eski 4 değer korundu). `kur.ps1` ve `guncelle.ps1` değişmedi: güncelleyici bildirimdeki yeni dosyaları "Eklenecek" olarak dağıtıyor (U18). ARSIVLEME'deki `AGENTS.md §9` atfı bölüm adına çevrildi; kurallarda `§` atfı kalmadı. README'ye "Dolu belgeleri yeni biçime geçirme" bölümü eklendi.
- **Ek tutarlılık düzeltmeleri:** `gorseller/akis.svg` içindeki "her biri ayrı onayla" (v0.3 aralık yetkisiyle çelişiyordu) → "adım/aralık onayıyla". `docs/KURAL_ESLEME.md` tarihî kayıt olarak bırakıldı; yalnız `§` numaralarının v0.2'ye ait olduğunu söyleyen bir cümle eklendi.

## Ölçümler

Yöntem: `## Projeye özel kurallar` başlığından önceki kısım, CRLF → LF sonrası; karakter = .NET UTF-16 kod birimi (Türkçe harfler 1), bayt = UTF-8. Ölçüm betiği Windows PowerShell 5.1 ile çalıştırıldı. Gerçek token ölçülmedi: bu oturumda kullanılabilir bir token sayma aracı yoktu; yeni bağımlılık kurulmadı. Kullanıcı kendi aracında ölçebilir (ör. Claude Code `/context`; bu oturumda çalıştırılmadı).

| Ölçüm | Önce (`32c889c`) | Sonra |
|---|---|---|
| Ortak kısım karakter / bayt | 12.837 / 13.970 | 10.127 / 10.971 (−%21,1 / −%21,5) |
| `genel/KURALLAR.md` tamamı karakter / bayt | 12.956 / 14.098 | 10.246 / 11.099 |
| Kök `AGENTS.md` tamamı karakter / bayt | 13.862 / 15.066 | 11.152 / 12.067 |
| Boş kurulumda oturum başı okuması (AGENTS + DURUM + PLAN) karakter | 14.714 (12.956 + 689 + 1.069 tam plan) | 12.251 (10.246 + 1.186 + 819 başlangıç ve aşama kuralları) |
| Ortak kısım LF SHA-256 | `244f17c8…b78f` | `cda4e34e…59cf6` |

Yeni rehberler (yalnız ilgili işte okunur): PLANLAMA 3.277, GIT 1.563, WINDOWS 1.005 karakter.

Hedef aşımı gerekçesi: 9.000 hedefi 1.127 karakter (%12,5) aşıldı. (1) Görevin çekirdekte istediği iki yeni içerik eklendi: §3 okuma bölümü 1.769 karakter, §4 kayıt tetikleyici paragrafı 503 karakter (ölçüldü). (2) İlk sürüm 9.486 karakterdi; bağımsız inceleme, karar yeri ve `PROJE.md` kurallarının yalnız kayıt dosyası başlıklarına taşınınca güncellenen eski projelere hiç ulaşmadığını gösterdi (güncelleyici dolu belgeye dokunmaz). Bu kurallar, başlık çelişkisinde ana dosyanın geçerli olduğu maddesi ve `.gitignore` kuralı ana dosyaya geri alındı (9.486 → 10.127, 641 karakter). Daha fazla kısaltma yetki, güvenlik, test dürüstlüğü veya kayıt yeri maddelerinden kesmek demekti; yapılmadı.

## Kritik kural eşlemesi (önce → sonra)

| Eski yer (v0.3.1) | Yeni yer |
|---|---|
| §1 Kırmızı çizgiler 1–6 | §1 maddeleri 1–6 (aynı içerik; "planı kabul etmek izin değildir" ve "belirsiz devam" §1.1'e alındı) |
| §3 dur-danış, yetkili adımda tekrar izin istememe, küçük iş istisnası | §1 alt maddeleri |
| §3 yol haritası, aşama planı yazımı, araştırma yoksa tek soru, alt adım numaraları | `docs/kurallar/PLANLAMA.md` |
| §4 okuma sırası, gerektiğinde okunanlar, arşiv okunmaz | §3 okuma tablosu ve maddeleri; TASARIM "yalnız ilgili bölüm" kuralı şablon başlığında |
| §5 kayıt yeri tablosu, karar numaraları ve yeri, öneri/karar ayrımı, tekrar yazmama, PROJE kuralları, tarih kabuktan | §4 (kısa); karar kayıt biçimi `docs/KARARLAR.md` şablon başlığında; başlık ana kuralla çelişirse ana kural geçerli |
| §6 yeni kural yerleri, 20 bin sınırı, onaysız kural silmeme | §5 |
| §7 aşama kapanışı, kapanmış aşama hatası | §5 özet + `ARSIVLEME.md` |
| §8 teknik kalite, varsayım yasağı | §6 |
| §9 test ve doğrulama | §7; test komutu bulma sırası `PLANLAMA.md` "Test komutu", güvenlik sınırı §7'de kaldı |
| §10 Git | Yasaklar, tek tek ekleme, `.gitignore` ve AI imzası §1.3; kimlik/otomatik commit yok §8; commit/push sırası `GIT.md` |
| §11 Windows | Kabuğu bilme ve `&&` §8; kodlama ayrıntısı `WINDOWS.md`, Türkçe commit mesajı `GIT.md` |

## Kontroller

### Başarılı

- `powershell.exe -NoProfile -File .\tests\kur-smoke.ps1` (Windows PowerShell 5.1.26100.9711): çıkış 0, geçti=30, kaldı=0, atlandı=0. Yeni senaryolar: R1 (kurulu belgelerdeki yerel bağlantılar ve kurallarda adı geçen `docs/kurallar/*.md` rehberleri hedefte var), R2 (kök `AGENTS.md` ortak kısmı `genel/KURALLAR.md` ile aynı), U18 (rehbersiz v0.3.1 benzeri kurulum: kuru çalıştırma dosya değiştirmez ve üç rehberi "Eklenecek" gösterir; uygulama rehberleri ekler; dolu DURUM/PLAN/GUNLUK/KARARLAR/PROJE belgeleri bayt bayt korunur ve raporlanır; özel kurallar korunur; ortak kısım yenilenir; kayıt yeni rehberleri içerir). Son değişikliklerden sonra ikinci kez çalıştırıldı, aynı sonuç.
- `powershell.exe -NoProfile -File .\tests\bilinen-hashler.ps1`: çıkış 0, EKSİK=0, FAZLA=0, geçmiş ortak kısım=5 (depo sığ değil). İki kez çalıştırıldı.
- `git diff --check`: çıkış 0.
- Kodlama: izlenen ve yeni 31 `.md`, 1 `.json`, 1 `.yml` UTF-8 BOM'suz; 4 `.ps1` UTF-8 BOM'lu; `tests/kur-smoke.ps1` CRLF korunmuş, yalın LF yok.
- Paket: 23 `copyFiles` eşlemesi, tekrarlı hedef yok, eksik kaynak yok; temiz kurulum 25 dosya yazdı.
- Ortak kısım eşitliği: kök `AGENTS.md` ve `genel/KURALLAR.md` ortak LF SHA-256 aynı; kök özel bölüm baytları HEAD ile aynı (SHA-256 `ea915e51…4ac3`, 1.096 bayt).
- Bağlantı denetleyicisinin olumsuz denemesi: kurulumdan `docs/kurallar/GIT.md` silinip `DURUM.md` içine kırık bağlantı eklenince 3 kırık buldu (temiz kurulumda 0). R1 aynı mantığı kullanır.
- Eski atıflar: `genel/`, `sablon/` ve kök `AGENTS.md` içinde `§` atfı yok. Şablonlarda geliştirme izi yok (`v0.3.2`, `H0–H8`, tarih araması boş).
- `docs/DURUM.md` 28 satır, `sablon/docs/DURUM.md` 29 satır.

- GitHub CI `kurucu-smoke` (çalıştırma 42206788113, commit `2f51cd5`): başarılı, 2 dk 32 sn (yerel testlerden ayrı).

### Başarısız

- İlk ölçüm denemesi Git Bash'ten `powershell.exe -File` ile çağrılınca betik çalıştırma ilkesine takıldı (`running scripts is disabled`). Neden: Git Bash ortamında süreç düzeyi `Bypass` yok. PowerShell aracından aynı komut çalıştı; kalıcı ayar değiştirilmedi.

### Atlanan

- Yok.

### Çalıştırılamayan

- Gerçek yeni Codex/Claude oturumu: bu makinede `claude` ve `codex` komutları PATH'te bulunamadı; VS Code içinden yeni oturum bu ajan tarafından açılamıyor. Deneme adımları aşağıda.

Not: Bu oturumdaki PowerShell aracı süreç düzeyinde `PSExecutionPolicyPreference=Bypass` ile çalışıyor; yukarıdaki `powershell.exe -NoProfile -File` komutları bu ortamda çalıştı. Normal bir terminalde betik ilkesi engellerse README'deki `-ExecutionPolicy Bypass` örneği kullanılır.

## Hafıza davranışı denemeleri

Bu bölümdeki sonuçlar **aynı ajanın canlandırmasıdır**: kayıtları ben yazdım, okuma listesini kurallara göre ben uyguladım. Bağımsız doğrulama değildir. Geçici örnek proje `kur.ps1` ile scratchpad altında kuruldu; gerçek proje klasörü kullanılmadı.

| Senaryo | Sonuç (canlandırma) |
|---|---|
| Alt adım tamamlandı | 1.1 `PLAN.md` içinde kısa "Doğrulandı" satırı ve günlük bağlantısıyla; `GUNLUK.md` sonuç kaydı; `DURUM.md` "Son yapılan" aynı bilgiyi kısa gösteriyor |
| İş yarım kaldı | `DURUM.md` yarım kalan, engel (kullanıcı yanıtı) ve devam noktası (`parse_line`); günlükte "Yarım kaldıysa" alanı; PLAN "Güncel alt adım: 1.2" DURUM ile aynı |
| Dördüncü önemli olay | 1.1 için 6 günlük kaydı (planlama, uygulama, yeni hata, karar, commit, düzeltme) şablon kuralına aykırı değil; düzeltme kaydı eski kaydı değiştirmeden ona işaret ediyor |
| Karar değişti | K-001 metni ve gerekçesi korunuyor; K-002 "Önceki karar: K-001; değişen kısım" alanıyla; dizinde K-001 "Yerine geçildi: K-002" |
| Aynı sohbetten devam | Okuma tablosu değişmeyen belgeyi yeniden okumamayı söylüyor; dosya tabanlı ölçülebilir bir kanıt yok, yalnız kural metni |
| Yeni sohbet açıldı | Kurallara göre okunan: DURUM + PLAN başlangıç/aşama kuralları + 1.2 satırı = 1.930 karakter (docs toplamı 32.970). 1.2 "İlgili kaynaklar"ından K-002 tam metni, TASARIM çapası ve PROJE çapası bulundu; 14 bağlantı ve çapa sağlam |
| Aşama arşivlendi | ARSIVLEME adım 2 ve 4–8 mekanik uygulandı: K-002 proje dosyasına taşındı, K-001 arşivde gerekçesiyle; taşıma sonrası 2 kırık `../` bağlantı adım 7 kuralıyla düzeltildi, sonra 17 bağlantıda 0 kırık; yol haritası ve DURUM arşiv özetine bağlı |

50 tamamlanmış + 1 güncel adımlı plan (şablondan üretildi): plan 96 satır / 12.776 karakter; yeni oturum okuması başlangıç ve aşama kuralları 20 satır / 801 karakter + güncel adım satırı 143 karakter. "Başlangıç" bölümü 10 satır; güncel adım satırı numarayla tek eşleşmeyle bulundu.

### Gerçek yeni oturum: Çalıştırılamadı — deneme adımları

1. Geçici bir klasöre kur: `powershell.exe -NoProfile -File .\kur.ps1 -TargetDirectory "C:\Temp\hafiza-deneme"`.
2. `docs/DURUM.md` ve `docs/aktif-asama/PLAN.md` içine yarım kalmış bir adım yaz (ör. bu rapordaki örnek: 1.2, engel, devam noktası, "İlgili kaynaklar").
3. VS Code'da klasörü aç, yeni bir Claude Code sohbeti başlat, önceki sohbeti vermeden şunu yaz: "Bu projenin durumunu ve yarım kalan işi dosyalardan bul. İlgili kaynakları belirt, henüz uygulama yapma."
4. Beklenen: 1.2'yi, engeli ve devam noktasını bulur; K-002 ve TASARIM bölümünü kaynak gösterir; dosya değiştirmez; GUNLUK/arşivi baştan okumaz.
5. Aynı adımları ayrı bir zamanda Codex ile tekrarla (iki araç aynı anda çalışmasın).

## Bağımsız inceleme

Katman Hafif; salt okunur ayrı bir alt ajan çalışma ağacındaki farkı inceledi (dosya değiştirmedi; kendi denemesi için `%TEMP%\inceleme-h-20261106-123607` klasörünü bıraktı, silinmedi). İnceleyici testleri kendisi de çalıştırdı: 30/0/0 ve EKSİK=0 FAZLA=0; eklenen hash'i ve ölçümleri ayrıca hesaplayıp doğruladı.

| Bulgu | Kanıt | Sonuç |
|---|---|---|
| Önemli 1: karar yeri ve `PROJE.md` kuralları yalnız şablon başlıklarına taşınmıştı; güncellenen eski projede dolu `KARARLAR.md`/`GUNLUK.md` eski başlıklarla ("en çok üç kayıt", "eski kayıtta cümle düzeltilir") kalıyor ve kurallar hiçbir dosyada yok | v0.3.1 `git archive` kurulumu + yeni güncelleyiciyle tekrar edildi | Düzeltildi: iki kural ana dosyaya geri alındı; "başlık bu dosyayla çelişirse bu dosya geçerlidir" maddesi eklendi; README geçiş adımına bu üç başlığı değiştirme eklendi. Aynı tekrar adımıyla yeniden denendi (aşağıda) |
| Küçük 2: dosyaları tek tek ekleme ve `.gitignore` kuralı yalnız `GIT.md` içindeydi | Eski §10 ile karşılaştırma | Düzeltildi: §1.3'e eklendi |
| Küçük 3: kapanmış aşamadaki hata ve `ACIK_KONULAR.md` için okuma yolu yoktu | Okuma tablosu ve `ARSIVLEME.md` başlığı | Düzeltildi: tablo satırı, §5 yönlendirmesi, ARSIVLEME başlığı ve ACIK_KONULAR maddesi |
| Küçük 4: "yeniden okunmaz" mutlak | §3 yeniden okuma koşuluyla çelişki | Düzeltildi: "gereksiz yere yeniden okunmaz" |
| Küçük 5: DURUM şablonu 29 satır, dolu içerik için yer yok | Satır sayımı | Düzeltildi: başlık sonrası boş satırlar kaldırıldı (24 satır); açıklama satırının korunacağı yazıldı |
| Küçük 6: R1 çapayı denetlemiyor, Windows'ta büyük/küçük harfe duyarsız, başlıklı/boşluklu bağlantıyı atlıyor | Test kodu | Bilinen sınır olarak bırakıldı; şu anki içerikte yanlış geçme bulunmadı. Örnek projede çapalar ayrı betikle denetlendi |
| Öneriler: aynı adlı kullanıcı rehberi; `git ls-remote`; INCELEME'nin katman belirlerken okunması | `guncelle.ps1` "Kullanici" yolu; `GIT.md` | Uygulandı: README 5. madde, `GIT.md` push kontrolü ve README tablo satırı, okuma tablosu ve `INCELEME.md` başlığı. U18'in U2/U3 ile kısmi örtüşmesi kabul edildi; yeni kısmı rehber ekleme ve dolu belge setidir |

Düzeltme sonrası denemeler (yazar):

- Gerçek v0.3.1 paketi (`git archive HEAD`) ile kurulum; dolu `DURUM/KARARLAR/GUNLUK/PROJE` satırları; yeni `guncelle.ps1` kuru çalıştırma 3 rehberi "Eklenecek", 4 belgeyi "Kullanıcı değiştirmiş" gösterdi; `-Uygula` 14 işlem, çıkış 0, kayıt 0.3.2. Dört belgedeki kullanıcı satırı duruyor; güncellenmiş `AGENTS.md` çelişki önceliğini, karar yerini ve `PROJE.md` kuralını içeriyor; 7 bağlantı ve 20 rehber yolunda 0 kırık.
- Bu denemede ilk `-Uygula` komutunun çıktısını `Select-Object -First 3` ile kestiğim için PowerShell alt süreci erken sonlandırdı (çıkış −1). Neden doğrulandı: hiçbir dosya yazılmamıştı (yedek klasörü yok, kayıt 0.3.1). Komut kesilmeden yeniden çalıştırıldı.
- Duman testi yeniden: geçti=30, kaldı=0, atlandı=0; geçmiş hash denetimi EKSİK=0, FAZLA=0; `git diff --check` temiz.

Düzeltme incelemesi (aynı inceleyici, yalnız düzeltilen bölümler): Önemli 1 kapandı. İnceleyici v0.3.1 tekrar adımını altı dolu belgeyle yeniden çalıştırdı (çıkış 0); eski başlık çelişkileri yeni "ana kural geçerli" maddesiyle çözümlü, karar yeri, `PROJE.md` ve `.gitignore` kuralları güncellenmiş `AGENTS.md` içinde. Düzeltmelerde kanıtlı yeni bulgu yok. Not (bulgu değil): elle birleştirilene kadar dolu PLAN/DURUM yeni başlıkları içermez; README geçiş adımında yazılı. İnceleyici bu turda testleri yeniden çalıştırmadı; testler yazar tarafından düzeltmelerden sonra çalıştırıldı (30/0/0, EKSİK=0 FAZLA=0). İkinci deneme klasörü `%TEMP%\inceleme-h2-20261106-124725` de silinmedi.

## Açık kalanlar

- Gerçek yeni Codex/Claude oturumu: çalıştırılamadı; adımlar yukarıda.
- Gerçek token ölçümü yapılmadı; yalnız karakter ve bayt.
- Ortak kısım 9.000 hedefini %12,5 aşıyor (gerekçe Ölçümler bölümünde).
- Önceden bilinen sınırlar sürüyor: yazma atomik değil; ayrı sığ klonda ret denemesi yok.

## Teslim

- Commit `2f51cd5dc05ba9b889b689a2917dd93639074d3e` (main), kullanıcı onayıyla oluşturuldu ve push edildi; `git ls-remote origin main` aynı kimliği gösterdi.
- GitHub CI `kurucu-smoke` (çalıştırma 42206788113, commit `2f51cd5`): başarılı, 2 dk 32 sn.
