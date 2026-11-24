# v0.3.4 — Bağımsız inceleme düzeltmeleri: doğrulama raporu

- Son güncelleme: 2026-11-22 12:45:47 +03:00
- Kapsam: kullanıcı mesajı (2026-11-21): görev dosyasının H, Y ve D bölümleri; seçimler S1a, S2a, S3a, S4a; sonunda commit önerip durmak. Görev dosyası (`GOREV_v0.3.4.md`) `.gitignore` kapsamında, Git dışında; kalıcı kapsam ve sonuçlar bu rapordadır.
- Kaynak: v0.3.3 sonrası, iki depoyu da yalnız okuyan ayrı bir ajanın incelemesi. Kanıtların bir kısmı kurulu gerçek bir projeden; o projenin adı, alan terimi ve örneği bu depoya yazılmaz (v0.3.3 kullanıcı kararı).
- İnceleme katmanı: Hafif (ortak kurallar bütün kurulu projelerin arayüzü; betik değişmedi, veri kaybı yok).
- Güncel kısa özet: [DURUM.md](DURUM.md).

## Kullanıcı seçimleri

| No | Seçim |
|---|---|
| S1a | Projeye veya aşamaya özel kural ortak kuralla çelişirse özel kural geçerlidir; ajan çelişkiyi fark edince bildirir. |
| S2a | Uzun aşamada dosya boyutuna bağlı ara temizlik bu sürümde yapılmaz. |
| S3a | Hedef projeye satır sonu önerisi eklenir (Y7). |
| S4a | Geçici bozma denemesine kesinti kaydı eklenir (Y8). |
| B1 kararı | İnceleme sonrası (2026-11-21, "Kırmızı çizgi istisnası"): özel kural geçerli kalır; ajan çelişkiyi uygulamadan önce bir kez bildirir ve §1'i gevşeten maddeyi bildirime onay gelmeden uygulamaz. Kullanıcı önerilen seçeneği seçti; ayrı gerekçe belirtmedi. |

## H — Hazırlık

- `main` `e16e9a4`. Commit edilmemiş: `docs/DURUM.md` ve `docs/DOGRULAMA_v0.3.3.md` (v0.3.3'ün push sonrası CI kaydı). İzlenmeyen: yerel inceleme notu ve kullanıcı notu; dokunulmadı.
- Ortak kısım: 12.393 karakter. Değişiklik öncesi LF SHA-256 `4e084bef1ec87b8101099f91790dd8600198b4d06d1ccd6a198fadb19b623237`; ikisi de görev dosyasındaki beklenen değerle aynı.
- H1'de sorulacak "v0.3.3 kayıtları bu commit'le mi, ayrı mı?" sorusu yalnız commit önerisini etkilediği için commit önerisiyle birlikte soruldu.

## Y — Değişiklikler

Görevdeki her "eski" metin hedef dosyada tam bir kez bulundu (20 düzenleme, 8 dosya); bulunmayan olmadı.

| No | Değişiklik | Dosyalar |
|---|---|---|
| Y1 | §5: özel kural ortak kuralla çelişirse özel kural geçerli, çelişki bildirilir. README: güncellemeden sonra tekrar/çelişki listesi isteme paragrafı. | `genel/KURALLAR.md`, `README.md` |
| Y2 | §1.3: dal silme (yerel veya uzak) açık onay ister. `GIT.md`: giriş listesi, "Birleştirme ve dal silme" başlığı, dal silme maddesi. | `genel/KURALLAR.md`, `sablon/docs/kurallar/GIT.md` |
| Y3 | §4: dizin kapsamı yalnız "Proje geneli" veya "Aşama N", tam metnin yeriyle uyuşur. `KARARLAR.md` "Durumlar" satırı. | `genel/KURALLAR.md`, `sablon/docs/KARARLAR.md` |
| Y4 | Karar tabanı adım satırında (`plan: K-xxx`). §3 "Kod değiştirmeden önce" satırı, `PLANLAMA.md` "İlgili kaynaklar" maddesi; v0.3.3'ün plan düzeyindeki "Plan anındaki son karar" alanı kaldırıldı. | `genel/KURALLAR.md`, `PLANLAMA.md`, `sablonlar/PLAN.md` |
| Y5 | README izin ayarı sınırı: `Read`/`Edit` yasaklarının uygulanmadığı komutlar ve sandbox. | `README.md` |
| Y6 | README: yedeklerin Git'te görünmesi ve `.gitignore` önerisi; v0.3.4 geçiş notu; dosya tablosu; sürüm satırı. | `README.md` |
| Y7 | `WINDOWS.md`: `.gitattributes` satır sonu önerisi (S3a). | `sablon/docs/kurallar/WINDOWS.md` |
| Y8 | `INCELEME.md`: geçici bozmanın "Geçici bozma başladı" kesinti kaydı (S4a). | `sablon/docs/kurallar/INCELEME.md` |

- **Y5 kaynak kontrolü** ([izin belgesi](https://code.claude.com/docs/en/permissions), [sandbox belgesi](https://code.claude.com/docs/en/sandboxing); 2026-11-21 okundu):
  - Belge görevdeki ifadeyi doğruluyor: yasaklar tanınan dosya komutlarına (`cat`, `head`, `tail`, `sed`, `tee`) uygulanır.
  - `grep -r pattern .` gibi dosya adı vermeyen komutlara ve dosyayı kendisi açan Python/Node betiklerine uygulanmaz.
  - İşletim sistemi düzeyinde koruma için sandbox önerilir.
  - **Görevden fark:** sandbox belgesine göre Claude Code yerel Windows'ta komutları sandbox'sız çalıştırır. Bu cümle eklendi.
- **Biçim farkları (düşük risk, README düzenine uyuldu):**
  - Y1 paragrafının son cümlesinde yol ve dosya adları satır içi kod yapıldı.
  - Y6.1'de "`.gitignore`'a" yerine "`.gitignore` dosyasına" yazıldı.
  - Y6.2 "v0.3.4 değişiklikleri de" diye başlar.
- `surum.json` 0.3.3 → 0.3.4; H'deki eski LF hash listeye eklendi (8 değer).
- **Bütçe:** ortak kısım 12.393 → 12.798 karakter (+405, inceleme düzeltmeleri dahil). Görev sınırı "yaklaşık +400, ≈12.800"; sonuç 12.800'ün altında, +400'ü 5 karakter aşıyor. Kök `AGENTS.md` ortak kısmı eşit, özel bölümü korundu.

## D — Doğrulama

- Geçti (son hâlde yeniden koşuldu): `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\kur-smoke.ps1` sonucu geçti=30, kaldı=0, atlandı=0.
- Geçti (son hâlde yeniden koşuldu): `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\bilinen-hashler.ps1` sonucu EKSİK=0, FAZLA=0, geçmiş ortak kısım 8.
- Geçti: değişen `.md` ve `surum.json` dosyalarında BOM ve CRLF yok; `git diff --check` temiz.
- **Güncelleme denemesi geçti** (ilk hâlde ve son hâlde, iki ayrı temiz kopyada aynı sonuç). v0.3.2 kurulu gerçek projeden yalnız `AGENTS.md`, `CLAUDE.md`, `.ai-sablon/`, `docs/` oturumun geçici klasörüne kopyalandı.
  - Kuru çalıştırma: 8 güncellenecek, ortak kısım yenilenecek, 6 aynı, 9 "kullanıcı değiştirmiş".
  - `-Uygula` sonrası doğrulananlar:
    - Ortak kısım şablonla aynı; özel bölüm bayt bayt aynı, LF korundu.
    - Rehberler ve boş şablonlar yeni hâlde.
    - Dolu belgeler ve 3 `proje-*.md` bayt bayt aynı.
    - Kayıt v0.3.4'e geçti, ortak hash eşleşiyor, yedek oluştu.
  - İkinci kuru çalıştırma güncellenecek dosya göstermedi.
  - Kopyadaki `AGENTS.md` son hâlde 20.908 karakter (önce 19.355; ortak 12.798 + özel 8.110). 20 bin eşiğini aşıyor; Y1'deki güncelleme sonrası listenin gerekçesi budur.
  - Gerçek proje klasörünün `git status` çıktısı denemeden önceki hâliyle aynı.
- **Bağımsız inceleme (Hafif), ilk tur:** salt okunur ve ağsız alt ajan; 1 önemli, 5 orta, 5 küçük bulgu. Hepsi metinle karşılaştırılarak doğrulandı.
  - Önemli (B1): özel kural önceliği §1 kırmızı çizgilerini de gevşetebiliyordu ve çelişki uygulandıktan sonra bildiriliyordu. S1a'nın anlamını daralttığı için kullanıcıya soruldu; "Kırmızı çizgi istisnası" seçildi ve uygulandı.
  - Orta, düzeltildi:
    - B2: "Proje geneli" kararın tam metni kapanışta arşive taşınabildiği için "(arşivdeki hariç)" eklendi ve `KARARLAR.md` "Durumlar" satırı netleşti.
    - B3: README'deki v0.3.3 notu v0.3.4'e yönlendirildi. v0.3.4 notu "o anki son K-numarasını yaz" yerine eski plan değerini taşımayı söylüyor; aksi hâlde aradaki kararlar taranmazdı.
    - B4, B5: geçici bozma kaydı ayrı günlük kaydı oldu, `DURUM.md` "Yarım kalan" notuyla yeni oturumda görünüyor. Sonucu "son kayıtsa satır ekle, değilse yeni kayıt" kuralına bağlandı.
    - B6: dal silme §1.2 durma listesine, §3 Git satırına, `GIT.md` girişine ve README'ye eklendi.
  - Küçük, düzeltildi:
    - B7: §3 karar okuma satırı tek anlamlı ve 40 karakter kısa oldu; işaret kaynak sayılmıyor, dizin boşsa işaret yazılmıyor.
    - B9: satır sonu uyarısının koşulu düzeltildi; `GIT.md` "Commit" bölümüne işaret eklendi.
    - B10: gözlenemeyen birleştirme ve birleştirilmemiş uzak dal soruluyor.
    - B8'in "bir kez bildir" kısmı B1 cümlesine girdi.
  - Kapsam dışı: B11 (aşağıda açık konu).
- **Dar yeniden inceleme** (yalnız düzeltilen bölümler): sekiz düzeltmenin hepsi bulgusunu gideriyor; önemli veya orta yeni bulgu yok. Beş küçük not uygulandı:
  - B1'deki "onay" plan kabulü sanılmasın diye "bildirime onay gelmeden" yazıldı; bütçe için "(arşive taşınan hariç)" ifadesi "(arşivdeki hariç)" olarak kısaltıldı.
  - "Durumlar" satırına taşımanın kapanışta olduğu eklendi.
  - Hash farklıysa DURUM notu kalıyor.
  - Gözlenemeyen birleştirmede onay bekleniyor.
  - Kayıt listelerine dal silme eklendi; README'ye GUNLUK başlığını yenileme maddesi eklendi.
  - Küçük notlar için kural gereği yeniden inceleme yapılmadı.
- Geçti: değişen dosyalarda projeye özgü terim taraması 0 eşleşme.
- Çalıştırılamayan: CI (push yok).

## Commit ve push

- Commit `6674fd4`, kullanıcı onayıyla ("commit push atabilirsin", 2026-11-22). 14 dosya tek tek eklendi; v0.3.3'ün push sonrası CI kaydı (`docs/DOGRULAMA_v0.3.3.md`) önerildiği gibi dahil. Yerel inceleme notu, kullanıcı notu ve görev dosyası dışarıda kaldı.
- Commit öncesi hazırlanan içerikte projeye özgü terim taraması 0 eşleşme, `git diff --cached --check` temiz; commit mesajında yapay zekâ imzası yok. Commit sonrası `tests/bilinen-hashler.ps1`: EKSİK=0, FAZLA=0.
- Push: `main` `e16e9a4..6674fd4`; `git ls-remote origin refs/heads/main` yerel `HEAD` ile aynı: `6674fd4d0905dd19e5b3d0d1844ae43fb5700753`.
- CI: bu depoda CI okuma kuralı yok; kural gereği kullanıcıya soruldu, sonuç okunmadı.
- Bu bölüm ve `DURUM.md` güncellemesi push'tan sonra yazıldı, commit edilmedi.

## Açık konular

- B8'in iki kısmı bütçe yüzünden eklenmedi:
  - "Ortak kural" ifadesinin `docs/kurallar/` rehberlerini de kapsayıp kapsamadığı yazılı değil.
  - Aşama kuralı ile projeye özel kural çelişirse hangisinin geçerli olduğu yazılı değil.
  - İkisi de kullanıcı kararı gerektirir.
- B11 (bu sürümden önce de vardı): kararlar dizinindeki "Arşivde" durumu hem geçerliliği hem konumu taşıyor. Aşama içinde yerine geçilmiş bir karar kapanışta "Arşivde" yapılınca yerine geçme ilişkisi kaybolabilir.
- İsteğe bağlı (B10): README'deki örnek izin listesine dal silme yasakları (`Bash(git branch -D *)`, `Bash(git push origin --delete *)`) eklenebilir.
- Ortak kısım 12.798 karakterle bütçeye dayandı. Sonraki ortak kural eklerinde önce ayrıntıyı rehbere taşımak gerekecek.
- Gerçek projenin v0.3.4'e güncellenmesi bu görevin dışında; görev dosyasına göre push ve yeşil CI'dan sonra, o projenin kendi oturumunda yapılır.
