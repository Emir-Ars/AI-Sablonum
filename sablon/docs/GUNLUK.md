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

Gerçek sorun olduysa `Sorun → çözüm` satırında hata mesajı birebir yazılır. Bir yoldan vazgeçildiyse `Vazgeçilen` satırı eklenir. Sorunsuz çalışmada bu satırlar oluşturulmaz.

Planlanan iş ve çalıştırılmayan test, yapılmış kayıt olarak yazılmaz. Geçmiş korunur; yeni iş eski kaydın üzerine yazılmaz.

Elle denetim tarihli kayıtları `## yyyy-MM-dd HH:mm — açıklama` başlığından tanır. Yukarıdaki alanlar gerçek kayıtta `- Alan adı: içerik` biçiminde yazılır; bu açıklama bölümü çalışma kaydı sayılmaz. Alanların bulunması testlerin gerçekten çalıştığını kanıtlamaz.
