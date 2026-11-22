# v0.3.3 — Genel iyileştirmeler: plan ve doğrulama raporu

- Son güncelleme: 2026-11-21 20:55:25 +03:00
- Durum: Plan kabul edildi; kullanıcı "G0–G9'u uygula" kapsamını verdi (2026-11-21). G0–G9 tamamlandı; commit, push ve CI aşağıda.
- Kaynak: şablonu uzun süre kullanan gerçek bir projenin salt okunur incelemesi (2026-11-21). Ayrıntılı inceleme notu yerelde tutulur, kullanıcı kararıyla commit edilmez. Yalnız her projede tekrar edebilecek bulgular alınır; o projeye özgü kural, alan terimi veya örnek şablona girmez (kullanıcı, 2026-11-21).
- Güncel kısa özet: [DURUM.md](DURUM.md).

## Kullanıcı seçimleri (2026-11-21)

- Aralık onayı: **Git işleminde dur.** Aralık yetkisi kalır. Adımlar arasında commit, push veya birleştirme olursa ajan o işlemden sonra durur; Git onayı sonraki adımı başlatmaz.
- Aşama büyüklüğü: **yumuşak eşik.** Aşama yaklaşık 10 alt adımı veya 3 numara düzeyini (1.2.1) aşarsa ajan bölmeyi önerir; kararı kullanıcı verir.
- CI: **ajan izinle okur.** İlk push'ta salt okunur CI kontrolü için izin ister ve cevabı projeye özel kural olarak yazar. İzin yoksa veya okuyamazsa sonucu kullanıcıdan ister.
- Gerekçe: Kullanıcı önerilen seçenekleri seçti; ayrı gerekçe belirtmedi.

## Kapsam dışı

- Yalnız o projeyi ilgilendiren iki bulgu: kendi kural dosyasının boyutu ve v0.1'den elle geçiş.
- O projenin alana özgü kuralları, dal düzeni, README biçimi, dosya adı stili ve dile özgü maddeler.
- Gerçek proje klasörünün güncellenmesi (ayrı ve kullanıcı onaylı iş).

## İlkeler

- Ortak kısım bütçesi: `genel/KURALLAR.md` ortak kısmı (şu an 11.245 karakter) en fazla yaklaşık %10 büyür (≈12.400). Aşılırsa ayrıntı `sablon/docs/kurallar/` altına taşınır. G0 ve G8'de ölçülür.
- Kural değişikliği tercihen ortak kısma ve `sablon/docs/kurallar/*.md` dosyalarına yazılır; `guncelle.ps1` bunları kurulu projelerde yeniler. Dolu belgelerin başlıkları yalnız gerekirse değişir; değişirse README'deki elle geçiş listesine girer.
- Kök `AGENTS.md` ortak kısmı her değişiklikte aynı adımda eşitlenir; "Projeye özel kurallar" korunur.
- İnceleme katmanı: Hafif (ortak kurallar bütün kurulu projelerin arayüzü; veri kaybı veya geri alınması zor işlem yok).

## Adımlar

| No | İş | Kabul ölçütü | Durum |
|---|---|---|---|
| G0 | Başlangıç ölçümü: `git status`, ortak kısmın karakter sayısı ve değişiklik öncesi LF SHA-256'sı | Ölçümler bu raporda; izlenmeyen kullanıcı dosyalarına dokunulmamış | Tamamlandı; yerel kontroller geçti |
| G1 | Onay ve alt ajan: §1.2 Git işleminde dur; §1 alt ajana kapsam ve kırmızı çizgiler; §5 kırmızı çizgi için mekanik koruma önerisi; README aralık notu | Kısa ve çelişkisiz; §1.6 korunmuş | Tamamlandı; yerel kontroller geçti |
| G2 | Okuma ve kayıt: kod öncesi kararlar "İlgili kaynaklar"dan; "Doğrulandı" anında kısaltma; commit/CI kimliğinin tek yeri; "Bilinen sınır" için tek kural (`INCELEME.md`, `PLANLAMA.md`, `sablonlar/PLAN.md` bağlanır) | Aynı bilginin ikinci yeri kalmamış | Tamamlandı; yerel kontroller geçti |
| G3 | Push sonrası CI: `GIT.md` bölümü (izin, salt okunur kontrol, gözlemeden yazmama, kırmızıda bildirim, tek sonuç kaydı, commit kendi kimliğini önceden yazmaz, CI'ı atlatan ifade yasağı); §3 GIT satırı; `sablonlar/GUNLUK.md` hedefi | CI'sız projede etkisiz; izinsiz ağ erişimi yok | Tamamlandı; yerel kontroller geçti |
| G4 | İnceleme ölçütleri: katman hatanın sonucuna göre; "sessiz hata" sorusu; katmanı düşürmek kullanıcı kararı; bulgu teste dönüşür; zorunlu katmanda kritik testin hatayı yakaladığı gösterilir | Üç katman tablosu korunmuş; maddeler alandan bağımsız | Tamamlandı; yerel kontroller geçti |
| G5 | Araştırma disiplini: kaynak yazma, okunan/çıkarım ayrımı, kullanıcıya düşen araştırma | §6 sırası bozulmamış | Tamamlandı; yerel kontroller geçti |
| G6 | Planlama ölçeği: yumuşak aşama eşiği; TASARIM'da gerçek alt adım başlığı; ~30 bin karakteri aşan bölüm onayla `aktif-asama/tasarim/` altına | Eşik öneri olarak yazılmış | Tamamlandı; yerel kontroller geçti |
| G7 | Windows kodlaması: kodda dosya okuma/yazmada kodlama açık verilir | Dile bağlı olmayan tek madde | Tamamlandı; yerel kontroller geçti |
| G8 | Paket ve belgeler: `surum.json` 0.3.3, eski LF hash listeye, README geçiş notu ve dosya tablosu, `akis.svg` kontrolü, bütçe ölçümü | Bütçe içinde; README ile kurallar çelişmiyor | Tamamlandı; yerel kontroller geçti |
| G9 | Doğrulama, bağımsız inceleme, kayıt ve tek commit önerisi | Geçen, kalan, atlanan, çalıştırılamayan ayrı | Tamamlandı; commit, push, CI yeşil |

## Doğrulama planı

1. `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\kur-smoke.ps1`: bütün senaryolar geçmeli (R1 bağlantılar ve rehber yolları, R2 ortak kısım eşitliği dahil).
2. `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\bilinen-hashler.ps1`: EKSİK=0, FAZLA=0.
3. Değişen `.md` dosyaları UTF-8 BOM'suz olmalı; `git diff --check` temiz çıkmalı.
4. Güncelleme denemesi gerçek klasörde yapılmaz:
   - Gerçek kurulu projeden yalnız `AGENTS.md`, `CLAUDE.md`, `.ai-sablon/` ve `docs/` geçici klasöre kopyalanır.
   - `guncelle.ps1` önce kuru, sonra `-Uygula` ile çalıştırılır.
   - Beklenen: ortak kısım yenilenir, özel bölüm bayt bayt aynı kalır. Kural dosyaları güncellenir, dolu belgeler korunur, yedek oluşur.
5. Bağımsız inceleme (Hafif) salt okunur ve ağsız bir alt ajanla yapılır. Ajan çelişki, projeye özgü madde, bütçe aşımı ve bozulan eski kural arar.
6. Kullanıcının yapacağı isteğe bağlı deneme: yeni bir oturumda örnek projede "2.1–2.2'yi uygula" denir ve ilk commit onayından sonra ajanın durup durmadığı gözlenir.

## G0 — Başlangıç ölçümü

- Başlangıç: `main` `4a298b1`. Commit edilmemiş: `docs/DURUM.md`; izlenmeyen: yerel inceleme notu, `docs/DOGRULAMA_v0.3.3.md`, `AI-Sablonum-Oneri-Notlari.md` (kullanıcı notu, dokunulmadı).
- Ortak kısım: 11.245 karakter, 98 satır. Değişiklik öncesi LF SHA-256: `1b12f56de124b6d6ce5ba77e0bca7cd39aa4f5f7f230971a5fdede19d61fec6e`. Denemede kullanılan kurulu projenin `.ai-sablon/kurulum.json` "agentsCommonLfSha256" alanıyla aynı.

## Yapılan değişiklikler (G1–G8)

- **G1:** `genel/KURALLAR.md` §1.2'ye Git işleminde durma cümlesi; §1'e madde 7 (alt ajana kapsam ve sınırlar); §5 yeni kural maddesine mekanik koruma önerisi. README "Kullanım" tablosunda aralık satırı. `GIT.md` "Commit" sonuna durma hatırlatması.
- **G2:**
  - §3 "Kod değiştirmeden önce" satırı artık adımın kaynaklarındaki kararları okutur; tam dizin yalnız ilgili karar bulunamazsa okunur.
  - §4 tablosunda GUNLUK satırı "commit, CI kimliği ve test sayısı"nı taşır. Yeni "Bilinen sınır" satırı eklendi; ACIK_KONULAR satırından "proje sınırı" çıktı, çünkü yeni satıra taşındı.
  - §4'e iki kural: "Doğrulandı" anında kısaltma; DURUM ve PLAN "Başlangıç" commit/CI kimliği taşımaz.
  - `PLANLAMA.md` "Başlangıç" ve kısaltma anı; `sablonlar/PLAN.md` Başlangıç notu, kısaltma anı ve "Bilinen sınırlar" açıklaması.
  - `INCELEME.md` çözülemeyen bulgunun yeri; `ARSIVLEME.md` adım 2 tablosunda bilinen sınırın yeri.
- **G3:** `GIT.md` başlık satırı ve yeni "Push sonrası CI" bölümü (izin, yalnız okuma, sonuç, kayıt, kendi kimliği, atlatma yok). §3 tablosunda GIT satırı. `sablonlar/GUNLUK.md` hedef kayıtları.
- **G4:** `INCELEME.md` "Katmanlar" altına üç madde (sonuca göre katman, sessiz hata sorusu, katman düşürme). "Nasıl yapılır" altına inceleyen sınırları, bulgunun teste dönüşmesi ve zorunlu katmanda bozma denemesi.
- **G5:** §6 belirsizlik maddesine kaynak yazma, okunan/çıkarım ayrımı ve kullanıcıya düşen araştırma.
- **G6:** `PLANLAMA.md` aşama planı adım 5–6, yeni "Aşama büyüklüğü" ve "Tasarım bölümünü ayırma" bölümleri, başlık satırı; `sablonlar/TASARIM.md` başlık açıklaması. `ARSIVLEME.md` bütün klasörü taşıdığı için `tasarim/` alt klasörü ek adım gerektirmiyor; adım 7 bağlantı taraması onu da kapsıyor.
- **G7:** `WINDOWS.md` başlık satırı ve kodlama maddesi; §3 tablosunda WINDOWS satırı.
- **G8:** `surum.json` 0.3.3, eski LF hash listeye eklendi (7 değer). README v0.3.3 geçiş notu, dosya tablosu ve sürüm satırı. `gorseller/akis.svg` metni ("adım/aralık onayıyla") yeni kuralla çelişmiyor, değiştirilmedi.
- **Bütçe:** ortak kısım 11.245 → 12.393 karakter (+1.148, %10,2; inceleme düzeltmeleri dahil, sınır ≈12.400). Kök `AGENTS.md` ortak kısmı eşit, özel bölümü korundu.

## G9 — Doğrulama

- Geçti: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\kur-smoke.ps1` sonucu geçti=30, kaldı=0, atlandı=0, çıkış 0. R1 bağlantıları ve R2 ortak kısım eşitliği dahil.
- Geçti: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\bilinen-hashler.ps1` sonucu EKSİK=0, FAZLA=0, geçmiş ortak kısım 7, çıkış 0.
- Geçti: değişen `.md` ve `surum.json` dosyalarında BOM ve CRLF yok; `git diff --check` temiz.
- **Güncelleme denemesi geçti.** v0.3.2 kurulu gerçek projeden yalnız `AGENTS.md`, `CLAUDE.md`, `.ai-sablon/` ve `docs/` (66 dosya) oturumun geçici klasörüne kopyalandı.
  - Kuru çalıştırma: 8 güncellenecek, ortak kısım yenilenecek, 6 aynı, 9 "kullanıcı değiştirmiş"; çıkış 0.
  - `-Uygula` sonrası doğrulananlar:
    - Ortak kısım şablonla aynı; özel bölüm bayt bayt aynı, LF korundu.
    - 5 rehber ve 4 boş şablon yeni hâlde.
    - 9 dolu belge ve 3 `proje-*.md` bayt bayt aynı.
    - Kayıt v0.3.3'e geçti ve ortak hash yeni kısımla aynı; yedek klasörü oluştu.
  - İkinci kuru çalıştırma güncellenecek dosya göstermedi.
  - Gerçek proje klasörünün `git status` çıktısı denemeden önceki iki kullanıcı değişikliğiyle aynı.
- **Bağımsız inceleme (Hafif), ilk tur:** salt okunur ve ağsız alt ajan; 1 önemli, 5 orta, 8 küçük bulgu. Hepsi metinle karşılaştırılarak doğrulandı ve düzeltildi:
  - Önemli: §5'teki mekanik koruma cümlesi `.claude`/`.codex` ayarını ajana bırakıyor gibi okunuyordu (§1.6 ile çelişki). Düzeltme: "§1.6 kapsamındaki ayarı kullanıcı yapar".
  - Orta:
    - Karar okuma kuralı, planlamadan sonra eklenen kararı kaçırabiliyordu.
    - "Tek sonuç kaydı" kuralı "eski kayıt değiştirilmez" ile çelişiyordu; artık son kayda satır eklenir.
    - "Doğrulandı" satırı commit kimliği istiyordu; artık kimlik yalnız günlükte durur.
    - "Sessiz hata" sorusu "Yok" katmanını ortadan kaldırabiliyordu; soru kod değişikliğiyle sınırlandı.
    - Bozma denemesinden sonra `git checkout` ile geri alma, commit edilmemiş düzeltmeyi silebiliyordu; artık elle geri alınır ve hash karşılaştırılır.
  - Küçük:
    - §1.7'nin gösterdiği sınırların yeri düzeltildi.
    - Birleştirme onayı §1.3'e ve `GIT.md`'ye eklendi.
    - "Dur"un anlamı tanımlandı.
    - Yanlışlıkla kayan iki inceleme cümlesi yerine döndü.
    - Taşınan tasarım bölümünde bağlantılar düzeltilir.
    - Kodlama kuralı metin dosyasıyla sınırlandı.
    - "Hesap" sözcüğü "oturum açma" oldu.
    - §3'e "adım bölme" tetiği eklendi.
- **Dar yeniden inceleme** (yalnız düzeltilen bölümler): 14 bulgunun hepsi giderilmiş; 5 yeni küçük bulgu çıktı ve düzeltildi:
  - Planlama anındaki son karar belirlenemiyordu; `PLAN.md` "Başlangıç"a "Plan anındaki son karar" alanı eklendi.
  - §3 Git satırına "Commit önerisi" geri eklendi.
  - `GIT.md` giriş cümlesine ve kırmızı çizgi listesine birleştirme eklendi.
  - `git stash` gerekçesi düzeltildi.
  - Uzak depoda birleştirme isteği ifadesi netleşti.
  - Küçük düzeltmeler için kural gereği yeniden inceleme yapılmadı.
- **Düzeltmelerden sonra yeniden koşuldu:**
  - Duman testi: geçti=30, kaldı=0, atlandı=0.
  - Hash denetimi: EKSİK=0, FAZLA=0.
  - BOM/CRLF yok; `git diff --check` temiz.
  - Güncelleme denemesi yeni ve temiz bir proje kopyasında aynı sonuçla tekrarlandı. Gerçek proje klasörünün `git status` çıktısı değişmedi.
- Çalıştırılamayan: gerçek yeni VS Code oturumu denemesi (aşağıda). CI sonucu "Commit, push ve CI" bölümünde.

## Kullanıcının yapacağı deneme (isteğe bağlı)

Ajan bağımsız yeni bir oturum açamaz; bu deneme yapılmadı.
1. v0.3.3'ü boş bir geçici klasöre kur.
2. `PLAN.md`'ye iki basit alt adım (2.1, 2.2) yaz.
3. Yeni bir oturumda "2.1–2.2'yi uygula; her adımdan sonra commit öner" de. Varsayılanda aralık tek commit'le bittiği için bu ek gerekir.
4. Ajan 2.1'den sonra commit önerince onayla.

Başarı ölçütü: Ajan commit'ten sonra durur ve 2.2 için yeni mesaj bekler.

## Commit, push ve CI

- Commit: `e16e9a4`, kullanıcı onayıyla (inceleme notunu dışarıda bırakarak commit). 14 dosya tek tek eklendi. Yerel inceleme notu ve kullanıcı notu dışarıda kaldı; hazırlanan içerikte o projenin adı ve alan terimi taraması 0 eşleşme verdi. Commit sonrası `tests/bilinen-hashler.ps1`: EKSİK=0, FAZLA=0.
- Push: kullanıcı onayıyla ("push et ve CI sonucuna da bak"), `main` `4a298b1..e16e9a4`. `git ls-remote origin refs/heads/main` sonucu yerel `HEAD` ile aynı: `e16e9a4632501966c2062ab9a20661c6c90cb732`.
- CI: `kurucu-smoke` çalışması `44932425506`, `e16e9a4` üzerinde başarılı. "Kurucu duman testi" adımı geçti=30, kaldı=0, atlandı=0; "Bilinen ortak kısım hash'leri" adımı EKSİK=0, FAZLA=0. Salt okunur `gh run list`, `gh run watch`, `gh run view` kullanıldı.
- Bu bölüm ve `DURUM.md` güncellemesi push'tan sonra yazıldı, commit edilmedi.

## Git

- Kapsam sonunda tek commit önerilir; dosyalar tek tek eklenir. Commit ve push ayrı onay ister.
- Yerel inceleme notu kullanıcı kararıyla commit'e alınmadı (2026-11-21); o projenin ayrıntıları bu depoya yazılmaz.
- `AI-Sablonum-Oneri-Notlari.md` ve `GOREV_*` dosyalarına dokunulmaz.
