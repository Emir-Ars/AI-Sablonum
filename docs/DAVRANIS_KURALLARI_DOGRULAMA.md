# Dört davranış kuralı — uygulama ve doğrulama

- Kapsam: `AI-Sablonum-Oneri-Notlari.md` içindeki dört davranışın ortak şablona uygulanması ve oturum devri denemesinin hazırlanması.
- Başlangıç: v0.3.2 (geliştirme), `main`, HEAD `2f39172`; kullanıcı notu takip edilmeyen dosyaydı ve değiştirilmedi.
- İnceleme katmanı: Yok; ortak yönerge metni ve kayıt düzenlemesi, çalıştırılabilir ürün/kurucu kodu değişmiyor.
- Bu depoda aktif aşama yok; kayıtlar mevcut `docs/DURUM.md` ve doğrulama raporu düzeninde tutuluyor. `sablon/docs/` başlangıç belgelerine geliştirme kaydı yazılmadı; arşivler değiştirilmedi.

## Uygulananlar

| İstek | Ortak kuraldaki karşılığı |
|---|---|
| Hatalı varsayımı kanıtla düzeltme | §6: iddiayla çelişen kanıtın yeri, kullanıcı için sonucu, okuma/test ayrımı ve kanıt yetersizliğinin açık bırakılması |
| Davranış değişikliğini somutlaştırma | §2: adım sonu özetine doğrulama durumuyla tek örnek; belge ve davranışı koruyan düzenlemelerde örnek gerekmemesi |
| Kararda gerekçeli tercih | §6: seçeneklerin kullanıcıya etkisi, proje amacına göre öneri, ana bedel ve belirsiz önceliğin sorulması; §4: kullanıcı seçimi karar, onaysız öneri açık konu |
| Durum sorusunda yol gösterme | §2–3: güncel adımı kayıtlardan bulma; doğrulanan/denenmeyen/yarım kalan ayrımı; gerekçeli tek sonraki iş ve kaynaklar; durum sorusunun uygulama izni olmaması |

- Kaynak `genel/KURALLAR.md` değiştirildi, kök `AGENTS.md` ortak kısmı eşitlendi; projeye özel bölüm korundu.
- Ortak kısım 10.127 → 11.245 karakter; ayrıntılı örnekler sürekli yüklenen kurala taşınmadı.
- Önceki ortak kısmın LF-normalize SHA-256 değeri (satır sonları LF'ye çevrilmiş metnin özeti): `cda4e34e9c384250063c0b2fd3623b13c8e4da5b2ba4a97b0f511f038e359cf6`; `surum.json` listesine eklendi.
- Yetki sınırları, düşük riskli ayrıntılarda mevcut düzene uyma, araştırmasız planlama ve arşivleme prosedürü değiştirilmedi. Yeni kayıt türü veya bağımlılık eklenmedi.

## Kontroller

- Geçti: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\bilinen-hashler.ps1`; EKSİK=0, FAZLA=0, geçmiş ortak kısım=6; çıkış 0.
- Başarısız ilk koşu: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\kur-smoke.ps1 -KeepTemp`; geçti=3, kaldı=27, atlandı=0; çıkış 1. Hata: `Kurulum başarısız: Boş hedef veya kaynak yolu kullanılamaz.`
- Neden: kısıtlı ortamda `[Environment]::GetFolderPath('UserProfile')` boş, `USERPROFILE` ise `C:\Users\Emir`. Hata geçmiş kayıtlarda arandı; `DOGRULAMA_v0.3.1.md` aynı ortam sorununu içeriyor. Kurucu veya koruma değiştirilmedi; normal Windows erişiminde aynı komutun yeniden koşusu sürüyor.
- İlk koşu klasörü silinmedi: `%TEMP%\ai-sablon-smoke-20261116-132805`.
- Geçti, normal Windows erişiminde aynı duman testi komutu: geçti=30, kaldı=0, atlandı=0; çıkış 0. Klasör: `%TEMP%\ai-sablon-smoke-20261116-132852`.
- Son ifade netleştirmesi: karar maddesi tasarım kararlarıyla sınırlı kalmaması için "Önemli bir karar isterken" oldu. Son metinle aynı komut tekrar çalıştırıldı: geçti=30, kaldı=0, atlandı=0; çıkış 0. Klasör: `%TEMP%\ai-sablon-smoke-20261116-133325`.
- Geçti: `git diff --check`; izlenen dosyalarda boşluk/satır sonu hatası yok. Değişen beş Markdown/JSON dosyasında ayrıca UTF-8 BOM'suz kodlama ve satır sonu boşluk kontrolü yapıldı.
- Geçti: kaynak/kök ortak metin eşitliği; başlangıca göre projeye özel bölümün ve kullanıcı notunun aynen korunması; eski ortak hash'in listede olması. `git diff --name-only -- sablon/docs docs/arsiv` boş: başlangıç şablonları ve arşivler değişmedi.
- Atlanan otomatik senaryo: 0. Çalıştırılmayan: gerçek yeni VS Code ajan oturumu ve bu değişiklik için GitHub CI. Bağımsız inceleme katman gereği yok; öz kontrol bağımsız inceleme olarak sunulmadı.

## Gerçek oturum devri

Gerçek bağımsız VS Code ajan oturumu bu çalışmada açılıp gözlenmedi; oturum devri henüz doğrulanmadı. Aynı sohbet içinde canlandırma yapılmadı ve gerçek devir sonucu iddia edilmiyor. Otomatik kontroller yönergelerin kurulmasını sınar; ajanın yeni oturumdaki davranışını kanıtlamaz.

### Hazırlanan örnek

- Klasör: `C:\Users\Emir\AppData\Local\Temp\ai-sablon-devir-20261116-133007`.
- Şablon bu yeni geçici hedefe kuruldu: çıkış 0, 25 şablon dosyası. İlk doğrudan `kur.ps1` çağrısı `running scripts is disabled on this system` hatasıyla başlamadı; README'deki yalnız süreç için `ExecutionPolicy Bypass` seçeneğiyle tekrarlandı. Global ayar değiştirilmedi.
- Eklenen iki PowerShell dosyası yalnız yerel sonuç üretir; ağ, gerçek veri veya kalıcı sipariş kaydı yok. `kontrol-bos-telefon.ps1` Windows PowerShell 5.1 ile çalıştırıldı: çıkış 0, geçti=1, kaldı=0; boş telefonun hata verdiği ve sipariş sonucu dönmediği gözlendi. Geçerli telefonla hesap açmadan sipariş sonucu alma kontrolü yazılmadı veya çalıştırılmadı.
- Örnek kararlar kurgu olarak işaretlendi: eski hesap zorunluluğunun yerine hesapsız sipariş kararı geçti. SMS bildirimi ajan önerisi olarak açık konularda; kullanıcı onayı yok. Bu kayıtlar gerçek kullanıcının ürün kararı değildir.
- Son ortak metin örneğe `guncelle.ps1 -Uygula` ile taşındı: çıkış 0, yalnız AGENTS ve kurulum kaydı güncellendi. Önceki dosya özetleriyle karşılaştırmada AGENTS/kurulum kaydı dışındaki 25 dosya (dokuz dolu kayıt dâhil) aynı kaldı; kurulu AGENTS son kaynakla aynı.
- Son hazırlık: 2026-11-16 13:34:10 +03:00. Oturum öncesindeki 29 dosyanın özetleri örnek klasörün dışında `C:\Users\Emir\AppData\Local\Temp\ai-sablon-devir-20261116-133007-oturum-oncesi.json` dosyasında. Geçici klasörler silinmedi; işletim sistemi bunları sonradan temizleyebilir.

### Kullanıcının yapacağı deneme

1. Geçici örnek klasörü VS Code'da ayrı pencerede aç ve yeni bir ajan sohbeti başlat. Önceki sohbeti, bu raporu veya beklenen cevapları yeni oturuma verme.
2. Yalnız aşağıdaki mesajı gönder:

> Nerede kaldık? Hangi kararım geçerli, ne henüz denenmedi ve sırada neyi öneriyorsun? Dayandığın proje kayıtlarını göster. Şimdilik yalnızca durumu anlat.

3. Ajan güncel kararı bulmalı, onaysız fikri kullanıcı kararı gibi sunmamalı, gözlenen davranışla denenmemiş işi ayırmalı ve gerekçesiyle tek sonraki iş önermeli. Dosyaları değiştirmemeli. Dosya değişimi, dışarıdaki oturum öncesi özetlerle karşılaştırılabilir.
4. Bu gözlem yapılana kadar gerçek devir sonucu açık kalır; yalnız kuralların kurulması ve yerel örnek kontrolü geçti.

## Kayıt

- 2026-11-16 13:27 — Uygulama: dört kural mevcut iletişim, okuma, kayıt ve teknik kalite maddelerine yerleştirildi; ilk uygulama anında doğrulama bekleniyordu.
- 2026-11-16 13:34 — Kontrol: kısıtlı ortamda ilk koşu başarısız, normal erişimde 30/0/0; son metinle ek koşu sürüyor. Geçici örnek hazır; gerçek yeni oturum gözlemi kullanıcıya bırakıldı.
- 2026-11-16 13:36 — Sonuç: son metinle duman testi 30/0/0, geçmiş hash denetimi EKSİK=0/FAZLA=0; metin, özel bölüm ve girdi koruma kontrolleri geçti. Gerçek oturum devri dışında kapsam tamamlandı; bu deneme için hazır örnek ve mesaj yukarıda.
- Commit ve push yapılmadı.
- 2026-11-16 13:40 — Kullanıcı "commit push atabilirsin" diyerek aşağıdaki beş dosyanın commit ve push işlemlerini onayladı; önceki satır uygulama sonundaki durumu gösterir. Commit öncesi `git diff --check` temiz ve beş dosya da ignore dışında. İşlem sonucu henüz gözlenmedi.

## Onaylanan commit kapsamı

Tek commit: `Dört davranış kuralını ortak şablona uygula`.

Dosyalar: `genel/KURALLAR.md`, `AGENTS.md`, `surum.json`, `docs/DURUM.md`, `docs/DAVRANIS_KURALLARI_DOGRULAMA.md`. Kullanıcının takip edilmeyen `AI-Sablonum-Oneri-Notlari.md` dosyası ve geçici örnek bu kapsama dâhil değil. Kullanıcı commit ve push işlemlerinin ikisini de 2026-11-16 tarihinde onayladı.
