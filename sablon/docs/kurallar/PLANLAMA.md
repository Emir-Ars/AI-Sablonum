# Planlama

Bu dosya yol haritası, aşama planı veya alt adım planı hazırlanırken, plan yapısı değiştirilirken (adım bölme, tasarım bölümünü ayırma), bir adım "Doğrulandı" yazılırken ve `docs/PROJE.md` içinde test komutu yokken okunur. İlgili bölüm yeterlidir. Yetki kuralları `AGENTS.md` içindedir.

## Araştırma belgelerini değerlendirme

`docs/arastirma/` ve `docs/aktif-asama/arastirma/` içindeki belgeler bağlayıcı karar değil, eleştirel değerlendirilecek bilgi girdisidir (`AGENTS.md` §1.8). Yol haritası ve aşama planı hazırlanırken bu belgeleri körü körüne plana aktarma; mevcut kod, `docs/PROJE.md`, yürürlükteki kararlar (`docs/KARARLAR.md`) ve proje amacı karşısında sına:

- Mevcut mimariyle veya geçerli kararlarla çelişen, gereksiz karmaşıklık yaratan, projeye uymayan varsayım taşıyan ya da yerine daha yalın ve sağlam bir alternatif bulunan noktaları açıkça belirt.
- Her eleştiride sorunu, dayandığı kanıtı (kod, sözleşme, karar), gerekçeli önerini ve başlıca bedelini kısaca sun (`AGENTS.md` §6); eşdeğer tercih farkları için gereksiz tartışma açma.
- Kullanıcı onayı olmadan yol haritasını, yürürlükteki kararları veya araştırmadaki yönelimi kendiliğinden değiştirme; çelişkili veya kritik noktaları planı kesinleştirmeden önce kullanıcıya sor.
- Kullanıcının araştırmadan farklı seçtiği yaklaşımı `docs/KARARLAR.md` (veya aşama içi ise `docs/aktif-asama/KARARLAR.md`) dosyasına kaydet; aşama planlamasında farkı `docs/aktif-asama/TASARIM.md` "Yol haritasından ve araştırmadan farklar" bölümüne işle.

## Yol haritası

Kullanıcı genel araştırma belgelerini `docs/arastirma/` altına koyar. Belgeler önce "Araştırma belgelerini değerlendirme" bölümüne göre sınanır. `docs/YOL_HARITASI.md` bunlardan hazırlanır: yalnız ana aşamalar ve her birinin 1–2 cümlelik amacı. Aşama ayrıntısı yol haritasına yazılmaz; değişiklik kuralı o dosyanın başındadır.

## Aşama planı

1. Kullanıcı aşamanın araştırma belgelerini `docs/aktif-asama/arastirma/` altına koyar.
2. `arastirma/` içinde `BENIOKU.md` dışında belge yoksa planı hemen yazma: koddan ve proje belgelerinden çıkardığın bilgiyi ve eksik kalanı birkaç satırla özetle, tek soru sor: "Araştırma belgesi eklenecek mi, yoksa bu bilgiyle plan yazayım mı?" Kullanıcı onaylarsa planı yaz ve `TASARIM.md` içinde "Araştırma belgesi yok; kaynak: kod ve proje belgeleri" diye belirt.
3. Plan şu kaynaklara göre yazılır: aşama araştırması, yol haritası, `docs/PROJE.md`, `docs/KARARLAR.md` ve `docs/ACIK_KONULAR.md`. Aşama araştırması "Araştırma belgelerini değerlendirme" bölümüne göre sınanır. Bu aşamada "en geç" olan bekleyen kararlar kullanıcıya sunulur.
4. Yol haritasının hâlâ geçerli olduğunu kontrol et; değişiklik gerekiyorsa öner, kendin değiştirme.
5. Tasarım (araştırmadan çıkan tasarım, riskler, yol haritasından ve araştırmadan farklar, alt adım sıralama gerekçesi) `docs/aktif-asama/TASARIM.md`, alt adım tablosu `docs/aktif-asama/PLAN.md` dosyasına yazılır. Alt adım tasarımları `### 1.1 — kısa ad` gibi ayrı Markdown başlığı alır; kalın yazı başlık yerine geçmez, çünkü bağlantı ve arama başlıkla çalışır. Bölünmeden uygulanacak satırın tasarımı "Alt adımı planlama" 2. maddesindeki ayrıntıyı taşır. Plan yazıldığında `docs/YOL_HARITASI.md` içindeki ilgili aşama durumu ve `PLAN.md` "Başlangıç" içindeki "Aşama durumu" `Planlanıyor` yapılır ("Aşama durumu" yol haritasındaki durum değerlerini izler).
6. Aşama büyüklüğünü kontrol et (aşağıdaki "Aşama büyüklüğü").

## Alt adımı planlama

Aşama planında kısa bir `3.1` satırı varsa "3.1'i planla" komutu o satırı `3.1.1`, `3.1.2` … biçiminde ayrıntılandırıp aynı `docs/aktif-asama/PLAN.md` dosyasına kaydetme yetkisidir. Numaralandırma diğer aşamalarda da aynı biçimde işler.

1. Ana satırın kapsamını, kabul ölçütünü ve "İlgili kaynaklar" hücresini, mevcut alt satırları, `TASARIM.md` dosyasındaki ilgili bölümü, `PROJE.md` sözleşmelerini, ilgili kararları, kodu ve testleri incele. Karar dizinini `AGENTS.md` §3'e göre tara. Ana kapsam, kabul ölçütü veya geçerli karar değişecekse önce kullanıcıya sor.
2. Alt adım sayısını işin sınırları belirler. Her satır tek başına yetkilendirilebilir, uygulanabilir ve doğrulanabilir bir sonuç içersin. Önkoşul varsa hangi satırın önce tamamlanması gerektiğini belirt. Tabloya kapsam, kabul ölçütü, doğrulama yöntemi (uygunsa komut ve beklenen sonuç), inceleme katmanı ve gerekçesi, ilgili kaynaklar ve yeni satır için "Planlandı" durumu yaz. Plan, onu yazmayan ve sohbet bağlamını görmeyen bir ajanın tahmin yürütmeden uygulayabileceği ayrıntıda olur: `TASARIM.md` içindeki adım başlığına değişecek dosya ve fonksiyonlar, arayüz, imza veya veri biçimi değişiklikleri, ele alınacak uç durumlar ve hata yolları, yazılacak test senaryoları yazılır. Bunlardan biri belirlenemiyorsa satır "Karar bekliyor" kalır ve eksik bilgi kullanıcıya sorulur.
3. Ana satırı ve numarasını koru. Ana satırın kapsam hücresine alt satır numaralarını yaz ve alt satırları hemen altında aynı tabloda tut. Ana satır toplam kapsamı ve kapanış ölçütünü gösterir. Alt satırların kaydedilmesi ana satırın durumunu değiştirmez. Ana satır ancak tüm alt satırlar doğrulandıktan ve kendi kabul ölçütü karşılandıktan sonra "Doğrulandı" olur.
4. Yeniden planlamada önce mevcut satırları ve kayıtların onlara yaptığı göndermeleri incele. Açık satırları gerektiği kadar güncelle, yeni iş için kullanılmamış numara ekle. Aynı işi ikinci kez yazma, tamamlanmış satırları yeniden açma ve mevcut numaraları değiştirme. Gerekli teknik ayrıntıyı mevcut `docs/aktif-asama/TASARIM.md` içinde ilgili numaranın başlığı altında tut. Her alt adım için ayrı dosya açma.
5. Dosya yazılabilen modda `PLAN.md` ve gerekliyse `TASARIM.md` değişikliğini ayrı onay beklemeden kaydet, özeti ver ve dur. Planlama sırasında ürün kodu veya test kodu yazma. Kullanıcı "sohbette değerlendir, dosyaya yazma" derse yalnız sohbet içinde değerlendir ve bu tercihi koru.
6. Araç o anda yalnız sohbet içinde plan sunabiliyorsa önerilen satırları ve teslimatı açıkça belirt. Örnek: “Bu plan onaylandığında 3.1.1, 3.1.2 … aktif plana kaydedilecek. Kod uygulaması ayrı komutla başlayacak.” Hemen ardından gelen "uygula" veya "Implement this plan" yalnız sunulan `PLAN.md` ve gerekiyorsa `TASARIM.md` düzenlemesini yetkilendirir. Sohbette sunulan plan kaydedilirken alt adım satırları `PLAN.md` tablosuna, teknik ayrıntı ise `TASARIM.md` içindeki ilgili numaranın başlığına yazılır. Teknik ayrıntı bu sırada özetlenmez veya kısaltılmaz; aynı bilgi iki dosyaya yazılmaz, `PLAN.md` "İlgili kaynaklar" sütunu başlığa bağlantı verir. Bu komut ana satırın veya alt satırların kod uygulamasını başlatmaz.
7. Açık "3.1.1'i uygula" komutuyla yeniden plan sunmadan o satırın uygulamasına ve doğrulamasına geç. Sonraki satıra kendiliğinden başlama. Kullanıcı açık bir aralık verirse `AGENTS.md` §1.2'deki aralık yetkisini kullan. Bölünmüş bir işi bir bütün olarak uygulamak isteyen kullanıcıdan hangi alt satırları yetkilendirdiğini belirtmesini iste.

## Aşama büyüklüğü

Plan yazılırken ve uygulamada yeni alt bölme gerektiğinde ölçülür. Aşama yaklaşık 10 alt adımı aşıyorsa veya numaralar üç düzeyi (`1.2.1`) geçecekse aşamayı bölmeyi öner. Bu, kalan adımları yol haritasında yeni bir aşamaya ayırmak olabilir. Öneriyi gerekçesi ve bedeliyle sun; kararı kullanıcı verir, yol haritası değişikliği o dosyanın kuralına uyar. Eşik kesin sınır değildir: bölmenin bedeli daha yüksekse kullanıcı aşamayı sürdürebilir.

## Tasarım bölümünü ayırma

`TASARIM.md` içinde bir alt adımın bölümü yaklaşık 30 bin karakteri geçerse, kullanıcı onayıyla `docs/aktif-asama/tasarim/<numara>-<kisa-ad>.md` dosyasına taşınır (ör. `tasarim/1.4-kisa-ad.md`). `TASARIM.md` içinde başlık ve bu dosyaya bağlantı kalır. Metin değiştirilmez, yalnız taşınır; göreli bağlantılar yeni konuma göre düzeltilir; dosya aşama klasörüyle birlikte arşive gider.

## PLAN.md yapısı

- **Başlangıç** (en fazla 15 satır): aşama, aşama durumu, güncel adım işaretçisi, önemli kapsam sınırları ve bağlantılar. Durum tablosu ve tasarım burada tekrar edilmez; commit/CI kimliği, test sayısı ve tarihli ayrıntı da yazılmaz (bunlar `GUNLUK.md`'dedir). Yeni oturumda planın yalnız bu bölümü, "Aşama kuralları" ve ilgili adım satırları okunur. Güncel adım değişince işaretçi de güncellenir.
- **Alt adımlar:** `1.1`, `1.2`, `1.2.1` gibi kalıcı numaralar kullanılır. Numaralar yeniden kullanılmaz. Bölünen adımlar "Alt adımı planlama" bölümündeki düzeni izler. Her satırda kapsam, kabul ölçütü, doğrulama yöntemi, inceleme katmanı (`INCELEME.md`), ilgili kaynaklar ve durum bulunur.
- **İlgili kaynaklar:** yalnız o adım için gereken belge veya bölüm, K-numarası, kod ya da test yolu; kısa göreli bağlantı olarak (ör. `[PROJE.md — Test komutları](../PROJE.md#test-komutları)`, `K-004`, `[TASARIM.md — 1.2](TASARIM.md#12--kısa-ad)`, `src/x.py`). Bütün repo veya bütün belge klasörü listelenmez. Adım planlanırken `docs/KARARLAR.md` dizinindeki son K-numarası hücrenin sonuna `plan: K-xxx` olarak yazılır; kod değiştirmeden önce bundan sonraki dizin satırları taranır. Yeni veya yeniden planlanan satıra planlama anındaki işaret yazılır. Tamamlanmış satırların işareti korunur. Dizin boşsa işaret yazılmaz; işaret kaynak sayılmaz.

## Tamamlanan adımı kısaltma

Satır, "Doğrulandı" durumunun yazıldığı düzenlemede kısaltılır; sonraki adıma bırakılmaz. "Doğrulandı" olan satır yaklaşık 300 karaktere indirilir: tek cümlelik kapsam, tek cümlelik doğrulama özeti ve `GUNLUK.md` doğrulama kaydına bağlantı; commit/CI kimliği ve test sayısı satıra yazılmaz, günlükte kalır. Böylece satır commit'ten önce de kısaltılabilir; "İlgili kaynaklar" ve varsa ana satırdaki alt adım numaraları korunur. Kısaltmadan önce kabul ölçütünün `GUNLUK.md` doğrulama kaydında veya `TASARIM.md` içinde bulunduğunu kontrol et; yoksa önce günlüğe yaz. Kabul ölçütü kısaltma sırasında kaybolmaz.

## Test komutu

`docs/PROJE.md` "Test komutları" bölümü boşsa projede tanımlı komut aranır: `package.json` script'leri, `pyproject.toml`, `Makefile`, CI dosyaları, test klasörleri. Açıkça tanımlı ve yalnız yerel test çalıştıran tek bir komut bulunursa çalıştırılır ve `docs/PROJE.md` içine yazılır. Komut bulunamazsa, birden fazla aday varsa veya komut ağa, canlı sisteme ya da gerçek veriye dokunabiliyorsa uydurulmaz, kullanıcıya sorulur.
