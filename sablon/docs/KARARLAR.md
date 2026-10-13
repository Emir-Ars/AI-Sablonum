# Kullanıcı kararları

Henüz bu projeye ait karar kaydı yok. Ortak şablon kuralları AGENTS.md içindedir; şablon deposunun geliştirme geçmişi bu belgeye taşınmaz.

## Kayıt biçimi

Yeni kararlar aşağıdaki alanlarla bu dosyanın sonuna eklenir:

- Kayıt başlığı: Kararlı karar numarası ve kabuktan alınan tarih/saat.
- Karar: Kullanıcının seçtiği yaklaşım.
- Gerekçe: Kullanıcının bildirdiği gerekçe; bildirilmediyse açıkça belirtilir.
- Etki: Etkilenen aşama, alt adım, davranış veya proje kuralı.

Anlamlı teknik kararda gerektiğinde aynı kayda şu bilgiler eklenebilir: gerçek seçenekler ve bedelleri, ajanın teknik değerlendirmesi, kararın sonuçları, ilgili kanıt bağlantıları ve somut bir yeniden değerlendirme koşulu. Bunlar her küçük karar için zorunlu alan değildir; ayrı karar dosyası açmak gerekmez.

Gerekçe alanı kullanıcının bildirdiği gerekçeyi taşır. Ajanın teknik değerlendirmesi ayrıca belirtilir; kullanıcı söylemediyse onun gerekçesi gibi yazılmaz.

Ajanın önerisi karar gibi kaydedilmez. Karar ilgiliyse [Plan](PLAN.md) ve [Devir](DEVIR.md) içindeki bekleyen madde de güncellenir.

## Aktif kararlar ve arşiv

Yürürlükteki proje geneli veya hâlâ gerekli kararların asıl kaydı aktif kalır; yalnız kapanmış yerel karar geçmişi ilgili hazırlık/aşama arşivine ayrılır. Kayıt tarihi tek başına kapsamı belirlemez; karışık veya belirsiz kapsam bütünüyle taşınmaz. Arşivlenen gerekçe, etki, özgün tarih ve karar numarası korunur; aktif belgede gerekli kısa bağlantı bulunur. Kimlikler sıfırlanmaz: yeni karar numarası vermeden aktif ve arşiv kayıtları kontrol edilir.

Aktarım ortak kurallardaki doğrulama ve denetim hazırlığı koşullarına tabidir. Daha sonra karar değişirse yeni karar kaydı önceki kayda bağlanır; tarihsel seçim geriye dönük değiştirilmez. Bu yönergeler gerçek karar veya yapılmış arşiv kaydı değildir.

Elle denetim gerçek kararları `## K-001 — açıklama` gibi numaralı başlıklardan tanır. Gerçek kayıtta `- Karar:`, `- Gerekçe:` ve `- Etki:` alanları kullanılır; bu açıklama bölümü karar kaydı sayılmaz.
