# Güncel devir notu

- Kayıt zamanı: 2026-10-02 10:29; kabuktan alındı.
- Proje: Codex–Claude proje şablonu; `v0.1.0` geliştirme paketi, tamamlanmış sürüm yayını yok.
- Güncel çalışma birimi: **1.2 — tamamlandı ve doğrulandı**. 1.3'e başlanmadı.
- Durumun kaynağı: [Plan](PLAN.md). Kararlar: [Kararlar](KARARLAR.md). Kontrol sonuçları ve sorun geçmişi: [Günlük](GUNLUK.md).

## Git ve dosyalar

- Gözlenen baz commit: `1dde9d6e95f7bd13d046df4d39d689748246642a` — **Ortak çalışma kuralları ve proje kayıt şablonlarını ekle**.
- Yerel repo kullanıcı tarafından kuruldu. Dal `main`, uzak adres `https://github.com/Emir-Ars/AI-Sablonum.git`, kimlik tanımlı. Bunlar bu adımda değiştirilmedi.
- 1.1 önceki açık onaylarla commit ve push edildi. 1.2 oturumu temiz çalışma ağacıyla başladı; şimdi aşağıdaki 9 dosya değişmiş/yeni durumda ve kullanıcı yerel commiti onayladı.
- Bu not commit öncesi hazırlandı; gerçek commit sonucu Git geçmişinden okunur. 1.2 push onayı yok. Sürüm etiketi/yayını oluşturulmadı. Bu not, kendisini içerecek gelecekteki commit kimliğini tahmin etmez.

## Tamamlanan iş ve doğrulama

- Yerel kurucu ve kaynak sürüm dosyası hazır. Yazmadan önce bütün kaynak/hedefler kontrol edilir; çakışma, yönlendirilmiş yol, kaynakla iç içe hedef ve global araç dizinleri reddedilir. Kısmi hata oluşan dosyaları bildirir.
- Mevcut paket 7 dosya kurar: ortak AGENTS, genel CLAUDE, dört temiz belge ve `.ai-sablon/kurulum.json`. Kaynak deponun geliştirme geçmişi aktarılmaz. Sürüm, tarih, kaynak ve çıktı özetleri kayıtlıdır.
- Windows PowerShell 5.1'de **41 kabul kontrolü başarılı; başarısız 0, atlanan 0**. Kısmi yazma hatası izole geçici kaynak kopyasında simüle edildi. Gerçek proje verisi kullanılmadı.
- İçerik denetiminde **6 grup ve 39 yerel bağlantı** başarılı. `.ps1` BOM'u `239 187 191`; PowerShell ayrıştırma hatası 0. Ortak kaynak/AGENTS eşleşmesi ve temiz başlangıç içerikleri korundu.
- README ve kurulum SVG'si mevcut davranışı anlatıyor. Güncellenen görsel üretildi ve görüntülenerek okunabilirliği kontrol edildi.
- UYARI: Paket geliştirme durumunda. Elle denetim ve gerçek araç davranış denemeleri bekliyor; `pendingFeatures` bunu açıkça kaydeder. Kontrol betiği kurulmuş gösterilmez.
- UYARI: Önizleme aracının `Fontconfig error: No writable cache directories` mesajı PNG üretimini engellemedi; giderilmiş sayılmadı. Ayrıntılar Günlük'tedir.

## Yarım işler ve bekleyenler

- 1.2 kapsamında yarım iş veya çözülmemiş başarısız kabul kontrolü yok.
- 1.3: `sablon/.ai-sablon/kontrol.ps1` ve `tests/Kurulum.Tests.ps1` henüz oluşturulmadı. Bu adım için açık kullanıcı yönlendirmesi beklenir.
- 1.4: Codex/Claude VS Code davranış denemesi yapılmadı; gerçek araç uyumluluğu doğrulandı denmez.
- Yeni bağımlılık kurulmadı; bu oturumda global skill, eklenti, ayar ve kurulum dosyaları değiştirilmedi.
- Önceki ayrı kaldırma talebinin yedeği `C:\Users\Emir\ai-sablon-kaldirma-yedekleri\20261002-002951` konumunda korunur. O işin tarihsel kanıtı Günlük'tedir; bu kurucunun özelliği değildir.
- Commit öncesi çalışan 4 zamanlanmış görev salt okunur kontrol edildi; eylemlerinde bu depoya açık referans görülmedi. Fiyat takip görevi `Staj` projesini kullanıyor. Görevler durdurulmadı/değiştirilmedi.

## Onaylı commit kapsamı

Türkçe mesaj: **Yerel şablon kurucusu ve sürüm kaydını ekle**.

Dosyalar tek tek seçilir. Geçici kabul yardımcısı, test hedefleri ve PNG önizlemeler repo dışındadır:

```text
AGENTS.md
README.md
docs/PLAN.md
docs/KARARLAR.md
docs/GUNLUK.md
docs/DEVIR.md
gorseller/kurulum.svg
kur.ps1
surum.json
```

## Devam yönlendirmesi

1. Proje kurallarını, Plan'ı ve bu notu oku; `git status --short` ve `git log --oneline -5` ile disk durumunu karşılaştır. UYARI satırlarını ilk özette bildir.
2. Bu notun hazırlandığı oturumda 1.2 commit onayı verildi. Sonucu `git log` ile oku; tekrar commit yapma. Push için ayrı izin gerekir.
3. Kullanıcı yalnız durum sorarsa özetle ve dur. 1.3 uygulaması için doğrudan yönlendirme bekle; bu belgedeki sonraki adım izin değildir.
