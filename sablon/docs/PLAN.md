# Proje planı

## Proje özeti

- Amaç: Kullanıcıyla henüz netleştirilmedi.
- Teknoloji: Henüz seçilmedi.
- Güncel çalışma birimi: Henüz seçilmedi.
- Uygulama kapsamı: Kullanıcıdan açık uygulama yönlendirmesi bekleniyor.
- Son güncelleme: Henüz proje oturumu başlamadı.

## Genel yol haritası

Henüz hazırlanmadı. Önce proje ihtiyacı netleştirilir, ardından ana aşamalar yazılır. Yol haritası kod yazma izni değildir.

| Aşama | Amaç | Durum |
|---|---|---|

## Seçilen aşamanın ayrıntıları

Henüz aşama seçilmedi. Yalnız kullanıcının seçtiği aşama için kararlı alt adım numaraları oluşturulur.

| Alt adım | Beklenen davranış ve kapsam | Kabul ölçütü | Doğrulama | Durum |
|---|---|---|---|---|

Durumlar: Planlandı, Uygulanıyor, Uygulandı — doğrulama bekliyor, Doğrulandı, Kullanıcı kararı bekliyor. Durum değişikliği uygulama izni değildir.

Seçilen aşamanın amacı, kapsamı, gerekli kalite koşulları ve sonucu etkileyen bilinmeyenler açıklanır. Kapsam dışı işler, kısıtlar ve bağımlılıklar gerektiğinde bu tablonun altında kısa metinle tutulur. Her alt adım için inceleme katmanı ve kısa gerekçesi belirtilir; yeni sütun veya zorunlu form eklenmez. Ayrıntılar yalnız seçilen dal için hazırlanır; gerekli araştırma ve etki incelemesi devam eder.

Önemli kabul ölçütü ilgili test veya gözlem kanıtıyla ilişkilendirilir; gerçek sonuç [Günlük](GUNLUK.md) kaydına bağlanır. Testlerin geçmesi karşılanmayan gereksinimi kapatmaz. Üst aşama kendi kabul ölçütleri, gerekli alt sonuçlar ve bütünleşme kontrolleri tamamlanınca kapanır.

Başlangıçta kısa sorumluluk ve ilişki haritası hazırlanır; README varsa orada, yoksa bu belgenin Proje özeti altında tutulur. Seçilen aşamada somut girdinin başarı ve önemli hata yolları açıklanır; aynı harita ayrı belgelerde bağımsız çoğaltılmaz.

## Hazırlık ve aşama kapanışı

Genel yol haritası üzerinde anlaşılınca hazırlığın yalnız kapanmış yerel geçmişi; ana aşamanın kabul ölçütleri, gerekli alt sonuçları ve bütünleşme kontrolleri tamamlanınca o aşamanın yerel geçmişi arşive ayrılabilir. Yol haritası, yürürlükteki kararlar/sözleşmeler, açık işler ve sorunlar aktif kalır. Sabit aşama veya alt adım sayısı yoktur; son sıra numarası kapanış ölçütü değildir.

Bu Plan sıfırlanmaz. Kapanmış aşama için genel yol haritasında kısa sonuç/durum ve arşivdeki Plan'a bağlantı kalır. Yalnız yeni seçilen aşamanın ayrıntıları yukarıdaki aynı başlık ve beş sütunla hazırlanır; alt adım kimlikleri yeniden kullanılmaz. Açık veya karışık kapsamlı ayrıntı bütünüyle arşivlenmez.

Arşiv yerleri hazırlık için `docs/arsiv/00-hazirlik/`, aşama için `docs/arsiv/01-asama-adi/` gibi kararlı adlardır; bunlar proje köküne göre örnek yollardır, henüz oluşturulmuş kayıt değildir. Özgün kayıt biçimi ve kapanış kanıtı korunur. Aktarım, bağlantılar ve kesinti/yeniden deneme kontrolleri AGENTS.md içindeki ortak kurallara göre yapılır; yarım aktarım burada ve Devir'de açık tutulur. Yeniden açılan aşama yeni kayıtla izlenir, eski kapanış değiştirilmez. Arşiv veya bu plan sonraki çalışma biriminin izni değildir.

Arşivde bu bölüm veya `## Kapanış`, aynı dizindeki Günlük'ün alanları dolu tarihli kapanış kaydına başlık bağlantısı içerir; yalnız dosyaya bağlantı yeterli değildir. Hazırlığa yapay alt adım numarası eklenmez; arşivlenecek karar yoksa boş Kararlar gerekmez. Aktif Plan arşiv Plan'ına ulaşan kısa bağlantıyı korur. Yeniden açılma varsa `## Yeniden açılma` altında aynı işin önceki arşiv Plan'ına açık bağlantı tutulur; yeni kayıt kendi Günlük'üne dayanır. Bu yönerge gerçekleşmiş kapanış veya yeniden açılma kaydı değildir.

## Doğrulama düzeni

- Projeye özel test araçları ve komutları: Henüz belirlenmedi.
- Şablonun [elle kayıt denetimi](../.ai-sablon/kontrol.ps1): Proje kökünde `powershell.exe -NoProfile -File .\.ai-sablon\kontrol.ps1`. Kayıt yapısını kontrol eder; ürün testinin yerine geçmez. Çıkış 0: hata/uyarı yok, 1: hata, 2: uyarı.
- Alt adım: İlgili testler ve kod denetimleri.
- Ana aşama kapanışı: Mevcut testlerin tamamı ve gerekli bütünleşme kontrolleri.
- Yeni araç: Bağımlılık eklenmeden önce kullanıcı kararı.
- Test dosyaları özellik/modül sorumluluğuna göre düzenlenir; plan numarası başına dosya açılmaz.
- Çalıştırılan sonuçların asıl kaydı: [Günlük](GUNLUK.md).

## Bekleyen kararlar

Projenin amacı, sınırları ve teknolojisi netleştirilecek. Kullanıcının verdiği kararların asıl kaydı [Kararlar](KARARLAR.md) dosyasındadır.

## Bilinen sınırlar

- Ortak kurallar bir teknik yetki kilidi değildir.
- Şablon sürümü, model veya eklenti sürümünü sabitlemez.
- Araçlar arasındaki devam bilgisi repo belgelerinde tutulur; sohbetlerin otomatik aktarıldığı varsayılmaz.
- Elle denetim aktif/arşiv kayıtları ve bağlantıları yapısal olarak inceler; kapanışın anlamını, gerçek test yürütmesini veya her izi silinmiş geçmişin kayıpsızlığını kanıtlamaz. İzole tam aktarım akışı doğrulanmadan gerçek geçmiş taşınmaz; kayıt denetimi öncesi/sonrası eksiksizlik karşılaştırmasının yerine geçmez.

## İlgili kayıtlar

- [Kararlar](KARARLAR.md)
- [Günlük](GUNLUK.md)
- [Devir](DEVIR.md)
