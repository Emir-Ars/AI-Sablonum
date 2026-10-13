# Çalışma günlüğü

Henüz bu projede tamamlanan çalışma veya çalıştırılan doğrulama yok.

## Kayıt biçimi

Her tamamlanan alt adımda bu dosyanın sonuna tarihli kayıt eklenir:

- Tarih/saat: Kabuktan alınır.
- Çalışma birimi: [Plan](PLAN.md) içindeki alt adım numarası.
- Yapılan iş ve nedeni: Tamamlanan davranış ve amacı.
- Değişen dosyalar: İlgili dosya listesi.
- Doğrulama: Çalıştırılan komut veya kontrol, gözlenen sonuç ve kapsam.
- Başarısız: Başarısız kontroller veya yok.
- Atlanan: Atlanan kontroller veya yok.
- Çalıştırılamayan: Çalıştırılamayan kontroller veya yok.
- Açık sınırlar ve takip gerektiren bulgular.

Doğrulama alanında önemli kabul ölçütünün hangi gerçek test veya gözlemle karşılandığı ve nelerin kanıtlanmadığı açıklanır. Kısa metin veya ilgili kayda bağlantı yeterlidir; yeni ölçüt kimliği ya da ayrı kanıt formu gerekmez. Karşılanmayan gereksinim açık kalır.

Gerçek hata veya önemli inceleme bulgusunda, gerektiğinde belirtinin tekrarı, olası nedenleri ayıran kontrol, doğrulanan neden ve düzeltmenin kanıtı aynı kayıtta anlatılır. Hipotez doğrulanmış neden gibi yazılmaz; çalıştırılmayan deney sonucu kaydedilmez.

Gerçek sorun olduysa `Sorun → çözüm` satırında hata mesajı birebir yazılır. Bir yoldan vazgeçildiyse `Vazgeçilen` satırı eklenir. Sorunsuz çalışmada bu satırlar oluşturulmaz.

Planlanan iş ve çalıştırılmayan test, yapılmış kayıt olarak yazılmaz. Geçmiş korunur; yeni iş eski kaydın üzerine yazılmaz.

## Kapanış ve geçmiş kayıtlar

Hazırlık veya ana aşama kapanışında yalnız ilgili kapanmış geçmiş arşive ayrılır. Özgün tarihli başlık, çalışma birimi, yapılan iş, doğrulama sonucu ve hata metni korunur; yalnız özet yeterli değildir. Açık sorun ve takip işi aktif Plan/Devir'de görünür kalır; karışık kapsamlı kayıt bütünüyle taşınmaz. Eski hata aranırken aktif Günlük ile varsa ilgili aşama arşivleri birlikte değerlendirilir.

Gerçek aktarımın kaydında seçilen kapsam, arşiv konumu, eksiksizlik/kimlik/bağlantı kontrolleri ve gözlenen sonuç belirtilir. Denetim uyumu ve izole akış doğrulanmadan aktarım yapılmaz; yarım iş tamamlandı sayılmaz. Ayrıntılı güvenli aktarım kuralları AGENTS.md içindedir. Bu bölüm gerçekleşmiş kapanış veya çalıştırılmış kontrol değildir.

Elle denetim tarihli kayıtları geçerli `## yyyy-MM-dd HH:mm — açıklama` başlığından tanır. Yukarıdaki alanlar gerçek kayıtta `- Alan adı: içerik` biçiminde yazılır; bu açıklama bölümü çalışma kaydı sayılmaz. Aktif/arşiv Plan yalnız aynı dizindeki Günlük ile eşleştirilir; arşiv Plan'ın kapanış bölümündeki başlık bağlantısı doğrudan ilgili dolu kaydı göstermelidir. Aynı tarihli başlık ve çalışma birimi birden çok yerdeyse yarım kopya veya meşru çakışma ayrıca incelenir; yalnız aynı iş için farklı tarihli kayıt tutulması tekrar değildir. Alanların bulunması gerçek test yürütmesini veya aktarımın kayıpsızlığını kanıtlamaz.
