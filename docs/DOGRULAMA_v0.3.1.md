# v0.3.1 doğrulama raporu

- Son güncelleme: 2026-11-05 13:40:10 +03:00
- Yetkilendirilen kapsam: Y0 ve D0–D5; ardından Z. Bütün kapsam tamamlandı.
- Paket ve README sürümü: 0.3.1. Commit ve push kullanıcı tarafından onaylandı; işlem sonuçları Git kayıtlarından izlenir.
- Bu şablon kaynağında aktif aşama PLAN/GUNLUK ve docs/PROJE.md bulunmadığından kapsam ve kabul ölçütleri kökteki görev dosyasından alındı; sonuçlar bu rapora yazıldı. Güncel özet [docs/DURUM.md](DURUM.md) içindedir.

## Y0 — Satır sonları

'git ls-files --eol': istenen uzantılarda 26 dosya w/crlf (24 .md, 1 .json, 0 .yml, 1 .svg); hepsinin Git kaydı i/lf. Satır sonlarını düzeltmek için toplu işlem yapılmadı. Düzenlenen mevcut dosyaların satır sonu biçimleri korundu; yeni PowerShell dosyası CRLF ve UTF-8 BOM'lu yazıldı.

Öneri: Şablon deposunu yeni bir klasöre yeniden klonla ve kurulumları o kopyadan yap; eski kopyayı kendin sil.

Liste:

~~~text
AGENTS.md
CLAUDE.md
README.md
docs/KURAL_ESLEME.md
docs/arsiv/v0.1-gelistirme/DEVIR.md
docs/arsiv/v0.1-gelistirme/GUNLUK.md
docs/arsiv/v0.1-gelistirme/KARARLAR.md
docs/arsiv/v0.1-gelistirme/PLAN.md
docs/arsiv/v0.1-gelistirme/VS_CODE_DENEMELERI.md
genel/KURALLAR.md
gorseller/akis.svg
sablon/docs/ACIK_KONULAR.md
sablon/docs/DURUM.md
sablon/docs/KARARLAR.md
sablon/docs/PROJE.md
sablon/docs/YOL_HARITASI.md
sablon/docs/aktif-asama/arastirma/BENIOKU.md
sablon/docs/arastirma/BENIOKU.md
sablon/docs/arsiv/BENIOKU.md
sablon/docs/kurallar/ARSIVLEME.md
sablon/docs/kurallar/INCELEME.md
sablon/docs/kurallar/sablonlar/GUNLUK.md
sablon/docs/kurallar/sablonlar/KARARLAR.md
sablon/docs/kurallar/sablonlar/PLAN.md
sablon/docs/kurallar/sablonlar/TASARIM.md
surum.json
~~~

Karakter sayıları CRLF → LF dönüşümünden sonra ölçüldü: AGENTS.md ortak kısmı 12.837, dosyanın tamamı bakım kuralı eklendikten sonra 13.862 karakter; 20 bin sınırının altında. Ortak kısım genel/KURALLAR.md ile aynı.

## D0–D5 sonuçları

| Adım | Durum ve doğrulama |
|---|---|
| D0 | Doğrulandı. v0.2.0 öncesi kayıt, kaynak içerikleri okunmadan reddediliyor; kuru çalıştırma ve uygulama U11 ile sınandı. |
| D1 | Doğrulandı. LF hash alanı, eski alan uyumluluğu, öncelik sırası ve satır sonu koruması uygulandı; U3–U5 ve U12–U17 ile sınandı. |
| D2 | Doğrulandı. Verilen dört hash aynen eklendi; iki betiğin liste doğrulaması K-liste ile sınandı. AGENTS.md özel bölümüne istenen bakım kuralı eklendi. |
| D3 | Doğrulandı. README'deki üç eski metin ve AGENTS.md bakım maddesi değişiklik öncesinde tam birer kez bulundu; görevdeki metinlerle değiştirildi. |
| D4 | Doğrulandı. Bayt akışıyla Git geçmişi denetimi eklendi; çıkış 0, EKSİK=0, FAZLA=0, eski ortak kısım=4. CI yapılandırmasına tam geçmiş ve denetim adımı eklendi; CI sonucu henüz kontrol edilmedi. |
| D5 | Doğrulandı. Windows PowerShell 5.1.26100.9711: geçti=27, kaldı=0, atlandı=0. |

Test yardımcılarındaki eski paket sürümü 0.0.1 → 0.2.0 yapıldı; böylece normal güncelleme testleri yeni alt sınırda kalıyor. Yerel kaynaklar CRLF olduğu için LF güncelleme paketi U12/U13/U17'de yalnız geçici kopyalarda hazırlandı.

Görevdeki örnek numaralar mevcut U6/U7 ile çakıştığından yeni senaryolar U8'den devam ediyor: salt okunur dosya U8, üst yol dosya U9, başlıksız AGENTS U10, v0.1 reddi U11, CRLF kurulum U12, yalnız satır sonu farkı U13, bilinen eski sürüm U14, v0.3.0 kaydı U15. K-liste hem kurucuda hem güncelleyicide yedi geçersiz liste biçimini sınar. Ek U16 iki kayıt alanının önceliğini ve kullanıcı değişikliğinin korunmasını; U17 aynı sürüm/içerikte kayıt geçişini ve ikinci çalıştırmada dosya değişmemesini sınar.

## Çalıştırılan kontroller

- 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\kur-smoke.ps1': normal kullanıcı erişimiyle çıkış 0; geçti=27, kaldı=0, atlandı=0. Bütün kurulum/güncelleme yazmaları testin kendi geçici klasörlerindeydi.
- 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\bilinen-hashler.ps1': çıkış 0; EKSİK=0, FAZLA=0. D4 sonunda ve D5 sonrasında aynı sonuç alındı.
- kur.ps1, guncelle.ps1, tests/kur-smoke.ps1, tests/bilinen-hashler.ps1: Parser.ParseFile ile ayrıştırıcı hatası 0; her dosyanın ilk üç baytı 239 187 191.
- Aynı tutulması gereken sekiz fonksiyonun Body.Extent.Text değerleri PowerShell sözdizim ağacından çıkarıldı, CRLF → LF dönüşümü sonrası büyük/küçük harfe duyarlı karşılaştırıldı: 8/8 aynı. Get-LfHash gövdesi geçmiş denetim betiğiyle de aynı.
- surum.json ConvertFrom-Json ile okunuyor; surum.json ve README.md UTF-8 BOM'suz. AGENTS.md ortak kısmı LF karşılaştırmasında genel/KURALLAR.md ile aynı.
- 'git diff --check': hata yok.

## Başarısız ilk denemeler ve çözüm

- İlk geçmiş denetimi Windows betik çalıştırma ilkesi nedeniyle başlayamadı. Yalnız süreç için -ExecutionPolicy Bypass kullanıldı; kalıcı ayar değiştirilmedi.
- Duman testinin izinleri kısıtlı ilk çalıştırması: geçti=2, kaldı=25, atlandı=0. [Environment]::GetFolderPath('UserProfile') boş, USERPROFILE ortam değeri doluydu; normal kullanıcı erişiminde özel klasör sorgusu C:\Users\Emir döndü. Kod veya koruma kapatılmadan normal kullanıcı erişimiyle yeniden çalıştırıldı; sonuç 27/0/0 oldu.

## Bağımsız inceleme

İnceleme katmanı Zorunlu; şablondaki sablon/docs/kurallar/INCELEME.md uygulandı. Tasarımı ve kodu inceleyen alt ajanlar dosya değiştirmedi.

- Tasarım incelemesi: P2, eski bayt hash'i ile yeni LF hash'i aynıysa yalnız değer farkına bakan kayıt yazma koşulu alan geçişini atlayabilir. Ayrı kayıt değişkenleri ve kayıt biçimi değişikliğini de izleyen commonChanged koşulu kullanıldı; U17 ile sınandı.
- Kod incelemesi: D0–D5 değişikliklerinde kanıtlı hata bulunmadı. LF alanı önceliği, özel bölüm baytlarının korunması, CRLF/LF seçimi, yazma öncesi liste doğrulaması ve geçmişin bayt olarak okunması incelendi. [null] ve [[]] liste girdilerinin reddi inceleyenin bellek denemesinde gözlendi.
- Kod incelemesinden sonra işlevsel kod değişikliği yapılmadı; yeniden inceleme gerektiren açık bulgu yok.

## Açık kalanlar

- Bu sürümün CI sonucu henüz kontrol edilmedi.
- Sığ klon reddi kod incelemesinde kontrol edildi; ayrı bir sığ klon üzerinde çalıştırılmadı.
- Yazma işlemlerinin atomik olmaması mevcut sınır olarak sürüyor.
- GOREV_v0.3.md ve GOREV_v0.3.1.md dosyalarının silinmesi kullanıcının isteğiyle bekletildi; dosyalar silinmedi.

## Z — Kapanış

- 2026-11-05 13:37:17 +03:00: surum.json version ve README sonundaki sürüm 0.3.1 yapıldı; iki eski metin değişiklik öncesinde tam birer kez bulundu. Dosyaların mevcut satır sonu biçimleri korundu.
- Sürüm değişikliğinden sonra 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\kur-smoke.ps1' normal kullanıcı erişimiyle yeniden çalıştırıldı: çıkış 0, geçti=27, kaldı=0, atlandı=0. 'powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\bilinen-hashler.ps1': çıkış 0, EKSİK=0, FAZLA=0.
- DURUM.md baştan yazıldı, 28 satır; karakter ölçümleri LF üzerinden. Görevdeki üç düzeltme gerçek test adları U8–U10 ile geçtiği için eski doğrulanmama notu kaldırıldı. Önceki bağımsız incelemenin özeti ve devam eden sınırlar kayda alındı. Bu sürümün CI sonucu henüz kontrol edilmedi.

## Değişen dosyalar ve commit önerisi

v0.3.1 değişiklik dosyaları:

| Dosya | Değişiklik |
|---|---|
| .github/workflows/kurucu-smoke.yml | Tam geçmiş ve bilinen hash denetimi |
| AGENTS.md | Eski ortak hash'lerin bakım kuralı |
| README.md | Güncelleme davranışı ve 0.3.1 sürümü |
| guncelle.ps1 | Sürüm sınırı, LF karşılaştırması ve kayıt geçişi |
| kur.ps1 | LF hash kaydı ve bilinen liste doğrulaması |
| surum.json | Bilinen eski hash'ler ve 0.3.1 sürümü |
| tests/kur-smoke.ps1 | Güncellenen ve yeni senaryolar |
| tests/bilinen-hashler.ps1 (yeni) | Git geçmişinden hash listesi denetimi |
| docs/DURUM.md | Güncel sürüm ve kapanış özeti |
| docs/DOGRULAMA_v0.3.1.md (yeni) | Y0, D ve Z doğrulama kayıtları |

Kullanıcının onayladığı commit mesajı: 'v0.3.1: güncelleme uyumluluğunu ve satır sonu güvenliğini düzelt'.

GOREV_v0.3.1.md dosyasının silinmesi kullanıcının isteğiyle bekletildi. Commit ve push kullanıcı tarafından onaylandı; işlem sonuçları Git kayıtlarından izlenir.
