# Güncel devir notu

- Kayıt zamanı: 2026-10-13 10:47; kabuktan alındı. Ana şablon commit/push sonucunun ardından hazırlanmıştır.
- Proje: Codex–Claude şablon kaynağı; v0.1.0 geliştirme paketi, yayın/etiket yok.
- Güncel çalışma birimi: **1.6.3 — İzole arşivleme akışı; doğrulandı**.
- Belge haritası: [Plan](PLAN.md), [Kararlar](KARARLAR.md), [Günlük](GUNLUK.md), [Deneme kılavuzu](VS_CODE_DENEMELERI.md).

## Durum

- K-033 ile son 1.6.3 tamamlandı; seçilen davranış şablonu yerel kurulumla kullanılmaya hazır. 1.6'nın kural/denetim/izole akış kabulü kapandı. Genel yol haritası, tek adım uygulaması, mühendislik anlatımı, araştırma ve risk temelli inceleme davranışlarına yeni sınır/ayar eklenmedi.
- Mevcut test dosyasına sekiz sentetik arşiv akışı eklendi: hazırlık/aşama ayrımı, aynı Plan ile ikinci aşama, kesinti/tekrar, kaynak veya arşiv farkı, kısmi aktarım ve yeniden açılma. Özgün tarih/kimlik/içerik, yaşayan genel karar/açık işler, bağlantılar ve eski kapanışın korunması sınandı. Yeni yardımcılar yalnız test örnekleri içindir; hedefe kurulan taşıma betiği değildir.
- Zorunlu bağımsız tasarım/kod incelemesi ve önemli düzeltmenin yeniden incelemesi tamamlandı. Ortak bağlantı dönüşümündeki hata içerik karşılaştırmasına rağmen geçebiliyordu; aktif geçmiş çıkarılmadan önce bağımsız denetim eklendi. Karşı örnek önce başarısız, düzeltmeden sonra başarılı oldu; son incelemede açık önemli bulgu yok.
- Yeni sekiz akış odaklı ve son tam turda **8/8** geçti. Son normal Windows PowerShell 5.1 turu **116 toplam, 115 geçen, 0 başarısız, 1 atlanan, çıkış 2**; dosya sembolik bağlantısı kontrolü yetki nedeniyle atlandı. RunAs isteği kullanıcı tarafından iptal edildi, tekrar istenmedi. Değişmemiş eski 108 test/üretim girdilerinin ayrı K-032 turunda **108/108, başarısız/atlanan 0, çıkış 0** kanıtı korunur; eski test dosyasının birebir SHA-256 eşitliği bellekten doğrulandı. Son atlama geçti diye gösterilmez; tek 116/116 koşu yoktur.
- Kaynak depoda gerçek arşiv/geçmiş aktarımı yapılmadı. Karmaşık Markdown/HTML sınırları ve denetimin test yürütmesini/kapanışın anlamını kanıtlamaması korunur. İzole akış gerçek ajan davranışı garantisi değildir. Ana aşama 1'in tarihsel yayın/tam uyumluluk kapsamı bütünüyle doğrulandı sayılmaz.
- K-027'nin üç görev/altı gerçek oturum değerlendirmesi kapandı. S-1 kurallı sayfa sınırı ve S-3 kontrol görünmez durum karakteri eksik düzeltmeleri, S-2 kontrol plan belirsizliği ve kayıt/biçim kusurları özgün haliyle korunur; ayrıntı ve kanıtlar kılavuz/Günlük'tedir. Genel zekâ/nedensel kalite/öğrenme veya tam Claude/kurulum uyumluluğu kanıtlanmış sayılmaz.
- 1.8 seçilmiş kapanışı, tarihsel 1.4 (2/8) ve 1.9 değerlendirme kapanışı korunur. Araştırmalar, 111 hızlı/211 eski deney dosyası ve başlangıç fotoğrafları değiştirilmedi; mevcut projeler otomatik güncellenmez.

## Sonraki Adım

- Seçilen şablon geliştirmesinde kalan uygulama adımı yok; burada duruldu. Kullanıcı özellikle süreci bitirmeyi istedi; yeni kural, uzun değerlendirme veya ek deney turu açılmaz.
- Şablon yeni projeye mevcut yerel kurucuyla uygulanabilir. Yeni gerçek ajan denemesi, kaynak geçmişini taşıma, yayın, otomasyon/bağımlılık veya eski projeye aktarım seçilmedi; bu not uygulama izni değildir.

## Sınırlar Ve Git

- UYARI: Geliştirme/IDE, Git ignore/satır sonu ve tarihsel SVG uyarıları sürüyor; giderilmiş sayılmaz. kur.ps1, kontrol.ps1, surum.json, genel/KURALLAR.md, AGENTS.md, dört başlangıç belgesi, global/model/araç ayarı, araştırmalar ve özgün deneyler bu alt adımda korunur. Ortak kaynak SHA-256 `ade3d16041d8adda8c5d26c2f6f9ba8c0253608eed379d56ef9c3fa3bbdc1007` değişmez.
- K-034'ün 15 onaylı dosyası `9236246` ile commit edildi ve `git push origin main` çıkış 0 ile `792d570..9236246 main -> main` verdi. İki araştırma belgesi indekse alınmadı ve yayımlanmadı; yalnız yerelde kaldı. Kontrolde izlenen dosyalar temizdi, yalnız bu iki belge izlenmiyordu. Desktop/Downloads'taki proje anlatımları ve yeni projeye kurulum kapsam dışıdır. Yayın/etiket oluşturulmadı; mevcut CI yapılandırması bulunmadığından CI başarısı iddia edilmez.
- Gözlenen baz commit `9236246`; sonuç notunun kendisini içerecek sonraki kayıt commit'i önceden yazılmaz. Kullanıcının yerel araştırma belgeleri korunur.
- 1.6.3'ün altı dosyası önceki Günlük'tedir. K-034 Git kapsamı: AGENTS.md, README.md, genel/KURALLAR.md; docs/PLAN.md, docs/KARARLAR.md, docs/GUNLUK.md, docs/DEVIR.md, docs/VS_CODE_DENEMELERI.md; sablon/docs/PLAN.md, sablon/docs/KARARLAR.md, sablon/docs/GUNLUK.md, sablon/docs/DEVIR.md; sablon/.ai-sablon/kontrol.ps1, tests/Kurulum.Tests.ps1, tests/ornekler/1.7-kurallar.txt. Seçilen commit mesajı: **Proje davranış şablonunu ve güvenli aşama arşivini tamamla**. İki özgün araştırma belgesi yalnız yerelde korunur; otomatik eski proje güncellemesi yapılmaz.
