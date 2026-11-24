# v0.3.5 — Sohbet planlama, kapsam, okuma rehberi, karar durumu, kapanış sonucu: doğrulama raporu

- Son güncelleme: 2026-11-24 13:30:00 +03:00
- Kapsam: kullanıcı mesajı (2026-11-24): altı değişiklik (1–6), yalnız bu şablon deposu; mevcut kurulumlara dokunulmadı, güncelleme denemesi geçici klasörde yapıldı. Commit ve push henüz onaylanmadı.
- İnceleme katmanı: Hafif (ortak kurallar bütün kurulu projelerin arayüzü; betik değişmedi, veri kaybı yok). Bağımsız alt ajan incelemesi yapılmadı.
- Güncel kısa özet: [DURUM.md](DURUM.md).

## Değişiklikler

| No | Değişiklik | Dosyalar |
|---|---|---|
| 1 | İsteğe bağlı "N'yi planla": yalnız N için yaklaşım ve doğrulama sohbette sunulur, uygulama beklenir; açık "N'yi uygula" için plan zorunlu değil. Kod, karar (`plan: K-xxx`) ve kabul ölçütü incelenir. | `genel/KURALLAR.md` §3, §5; `PLANLAMA.md` "Alt adımı sohbette planlama" |
| 2 | "Uygula" yalnız hemen önce planı sunulan adımı yetkilendirir; çok adımlı veya bağlamı kayıp durumda tek kapsam sorusu; kendi çıkarılan kapsam "kullanıcı istedi" diye yazılmaz. "Planın kabulü" ile açık "uygula" ayrıldı. | `genel/KURALLAR.md` §1.1, §1.2 |
| 3 | Sohbet planı için yeni dosya veya zorunlu `1.2.1` yok; aynı sohbette biten iş olağan sonuç kaydıyla, kalıcı karar K-numarasıyla, yarım iş `DURUM.md` "Yarım kalan" ile (seçilen yaklaşım, tamamlanan kısım, devam noktası). Plan sunumu "yanıt bekleniyor" kaydı tetiklemez. | `genel/KURALLAR.md` §4; `PLANLAMA.md`; `sablon/docs/DURUM.md` |
| 4 | Okuma tablosu başlangıç noktası: kaynak eksik, yönlendirici veya kodla çelişkiliyse kod/test/karar/arşiv bölümü izin istenmeden izlenir; arşive güncel belgeden verilen bağlantı dahil. `plan: K-xxx` işareti korundu; daraltma güvenilir değilse bütün dizin. | `genel/KURALLAR.md` §3; `sablon/docs/arsiv/BENIOKU.md`; README |
| 5 | Karar dizinine "Tam metin" sütunu: "Durum" yalnız geçerliliği (Geçerli / Kısmen değişti / Yerine geçildi: K-xxx), "Tam metin" yeri (bu dosya, aşama, arşiv bağlantısı) taşır. "Arşivde" durumu kalktı; arşivleme yeri değiştirir, ilişkiyi silmez. Örnek satırlar ve bitiriş kontrolü eklendi. | `sablon/docs/KARARLAR.md`, `ARSIVLEME.md`, `sablonlar/KARARLAR.md`; `genel/KURALLAR.md` §4 |
| 6 | Kapanış commit'inin sonradan gelen sonucu (commit, CI sonucu, koşu bağlantısı) yeni aktif `GUNLUK.md` dosyasına "Aşama N kapanış sonucu" kaydı; arşiv ve `OZET.md` değişmez, `DURUM.md` yalnız durum ve kayda bağlantı taşır. Neden bu yer: kapanış commit'i kendi sonucunu içeremez, arşiv değişmez, `DURUM.md` baştan yazılır; günlük commit/CI kimliğinin zaten tutulduğu yerdir ve sonraki kapanışta arşive gidip aranabilir kalır. | `ARSIVLEME.md` "Kurallar"; `GIT.md` "Kayıt"; `sablonlar/GUNLUK.md`; `genel/KURALLAR.md` §5; `sablon/docs/DURUM.md` |

- Sürüm 0.3.4 → 0.3.5; v0.3.4 ortak kısmının LF hash'i (`0d043c3a…b824`) `knownAgentsCommonLfSha256` listesine eklendi. README: kullanım tablosu, okuma rehberi, kapanış açıklaması, v0.3.5 geçiş notu, dosya tablosu.
- Kök `AGENTS.md` ortak kısmı `genel/KURALLAR.md` ile eşitlendi; "Projeye özel kurallar" bölümü değişmedi.
- **Bütçe:** ortak kısım 12.798 → 14.044 karakter (+1.246); kök `AGENTS.md` toplam 15.069 (20 bin eşiğinin altında). Altı işlev için eklenen metin kısa tutuldu; bazı mevcut cümleler sadeleştirildi (başlık altı giriş, §3 arşiv maddesi, §4 açıklama parantezi). Daha fazla kısaltma yapılmadı: kapsam sorusu ve karar-yer ayrımı gibi kurallar kısaltılınca belirsizleşiyordu.

## Doğrulama

- Geçti: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\kur-smoke.ps1` geçti=30, kaldı=0, atlandı=0 (R1 bağlantılar, R2 kök `AGENTS.md` = `genel/KURALLAR.md` dahil).
- Geçti: `powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\tests\bilinen-hashler.ps1` EKSİK=0, FAZLA=0, geçmiş ortak kısım 9.
- Geçti: değişen `.md` ve `surum.json` dosyalarında BOM ve CRLF yok; `git diff --check` temiz.
- **Güncelleme denemesi geçti** (geçici klasörde, iki kez): v0.3.4 `HEAD` paketiyle temiz kurulum, ardından çalışma ağacındaki paketle `guncelle.ps1` kuru çalıştırma ve `-Uygula`. Ortak kısım hedefte `genel/KURALLAR.md` ile aynı; özel bölüm korundu; `PLANLAMA.md` yeni bölümü geldi; `kurulum.json` 0.3.5. Geçici klasör silindi; mevcut kurulu projelere dokunulmadı.
- Çalıştırılamayan: CI (push yok). Bağımsız alt ajan incelemesi yapılmadı.

## Yalnız metin üzerinden kontrol edilen davranışlar

Gerçek bir ajan oturumunda denenmedi; son kural metni (`genel/KURALLAR.md`, rehberler) okunarak değerlendirildi. Model davranışı bu denetimle garanti edilmez.

1. **"1.2'yi planla" → yalnız 1.2 planı → "uygula".** §1.2: yalnız 1.2'nin planı sunulduysa hemen ardından "uygula" yalnız 1.2'yi yetkilendirir; yeniden onay sorulmaz, 1.3'e geçilmez. `PLANLAMA.md` 4. madde planı yalnız 1.2 için sunar ve uygulama komutunu bekler. Beklenen kapsam yalnız 1.2: metinle uyumlu. Kayıt: "'uygula', sunulan 1.2 planına bağlandı" (kullanıcı istedi denmez).
2. **Birden fazla olası adım varken "planı uygula".** §1.2: birden fazla adım veya plan makul biçimde kastedilebiliyorsa ya da bağlam kaybolduysa uygulamadan önce tek kapsam sorusu; "planı uygula" örneği §1.2'de anılır. Beklenen davranış tek kapsam sorusu: metinle uyumlu.
3. **Yerini yeni karara bırakmış eski karar arşivleniyor.** `ARSIVLEME.md` adım 2 tablosu: "Durum" sütunu aynen kalır (Yerine geçildi: K-xxx), "Tam metin" arşiv bağlantısı olur; adım 3: "Önceki karar" alanı aynen taşınır ve bitirmeden önce dizinde `Yerine geçildi` satırının gösterdiği K-xxx'in bulunduğu kontrol edilir; `KARARLAR.md` örnek satırları ilişkiyi iki yönde gösterir. Beklenen sonuç, yeni karara giden ilişkinin korunması: metinle uyumlu.

## Açık konular

- Alt ajan incelemesi ve gerçek ajan oturumunda davranış denemesi yapılmadı; gerçek projede ilk kullanımda gözlenmelidir.
- "Arşivde" durumuyla yazılmış eski kurulu projelerdeki dizin satırları otomatik dönüştürülmez; README v0.3.5 geçiş notu elle düzeltmeyi anlatır.
- v0.3.4'ün CI sonucu hâlâ okunmadı ([DOGRULAMA_v0.3.4.md](DOGRULAMA_v0.3.4.md)).
