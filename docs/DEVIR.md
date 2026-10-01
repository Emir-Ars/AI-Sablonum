# Güncel devir notu

- Kayıt zamanı: 2026-10-02 00:30; kabuktan alındı.
- Proje: Codex–Claude proje şablonu, hedef `v0.1.0`.
- Güncel çalışma birimi: **1.1 — tamamlandı ve doğrulandı**. Kullanıcı 1.1 commitini onayladı; bu not ilk committen önce hazırlanmıştır.
- Durumun kaynağı: [Plan](PLAN.md). Kararlar: [Kararlar](KARARLAR.md). İş geçmişi: [Günlük](GUNLUK.md).

## Git ve dosyalar

- Gözlenen baz commit: Not hazırlanırken henüz commit yoktu; ilk 1.1 commitinin kimliği sonraki oturumda `git log` ile okunur.
- Yerel repo kullanıcı tarafından kuruldu. Dal `main`, uzak adres `https://github.com/Emir-Ars/AI-Sablonum.git`, kullanıcı kimliği tanımlı.
- Gözlenen çalışma ağacı: Commit hazırlığında yalnız 14 adet yeni 1.1 dosyası. Kullanıcının başka değişikliği görülmedi.
- 1.1 commit onayı var. Push onayı yok; GitHub sürüm etiketi/yayın yapılmadı.

## Tamamlanan iş ve doğrulama

- Ortak kurallar, AGENTS/Claude girişleri, dört belge rolü ve yeni proje için temiz başlangıç içerikleri hazır.
- README, kitap takip örneğini ve test seçimini açıklıyor; iki SVG kurulum hedefiyle çalışma akışını gösteriyor.
- Belge denetiminde 6 grup ve 37 yerel bağlantı kontrol edildi; UTF-8, kaynak eşleşmesi ve temiz başlangıç kontrolleri başarılı. İki SVG dönüştürüldü ve görüntülendi.
- Önizleme aracının `Fontconfig error: No writable cache directories` uyarısı PNG üretimini engellemedi; giderilmiş sayılmadı. Komut ve sınırların asıl kaydı Günlük'tedir.

## Eski kurulumun kaldırılması

- Kullanıcının ayrı talebiyle eski `Emir-Ars/ai-sablon` kurulumunun iki global talimat dosyası ve sekiz özel skill klasörü aktif konumlardan yedeğe taşındı; silme yapılmadı.
- Yedek: `C:\Users\Emir\ai-sablon-kaldirma-yedekleri\20261002-002951`. 14 dosyanın içerik özetleri doğrulandı; kaldırma kaydı ve önceki Claude ayarı burada saklanıyor.
- Claude ayarındaki eski kurucunun eklediği `attribution` alanı kaldırıldı. Diğer ayar değerleri karşılaştırılarak korundu; yerleşik skill/plugin dizinleri yerinde.
- Eski kaynak repo ve önceki yedekler korundu. İlk kurulumdaki tüm global içerikler bilinmediği için tam fabrika durumuna dönüldüğü söylenmez.
- Diskten kaldırma, açık sohbetin önceden yüklediği talimatların silindiğini kanıtlamaz. Sonraki kullanım yeni sohbetle başlamalı.

## Yarım işler ve bekleyenler

- 1.1 kapsamında yarım iş yok. 1.2, 1.3 ve 1.4 yalnız planlandı; uygulanmadı. Sonraki adıma kendi başına geçilmez.
- `kur.ps1`, `surum.json`, kontrol ve test betikleri henüz yok; gerçek Codex/Claude VS Code denemesi yapılmadı.
- Kullanıcı mevcut belge düzenini yeterli gördüğünü belirtti. Henüz sonraki adımları iptal etme veya uygulama yönlendirmesi vermedi.
- Yeni bağımlılık kurulmadı. Yeni şablon için global kurulum yapılmadı; eski eklemelerin kaldırılması ayrı kullanıcı talebidir.

## Onaylı commit kapsamı

Türkçe mesaj: **Ortak çalışma kuralları ve proje kayıt şablonlarını ekle**.

Dosyalar tek tek seçilir. Geçici yardımcı betikler, görsel önizlemeler ve kaldırma yedeği repo dışında olup commit kapsamına girmez:

```text
README.md
AGENTS.md
CLAUDE.md
genel/KURALLAR.md
docs/PLAN.md
docs/KARARLAR.md
docs/GUNLUK.md
docs/DEVIR.md
sablon/docs/PLAN.md
sablon/docs/KARARLAR.md
sablon/docs/GUNLUK.md
sablon/docs/DEVIR.md
gorseller/kurulum.svg
gorseller/is-akisi.svg
```

## Devam yönlendirmesi

1. Proje kurallarını, Plan'ı ve bu notu oku; `git status --short` ve `git log --oneline -5` ile disk durumunu karşılaştır.
2. 1.1'in gerçek commit sonucunu Git geçmişinden oku; bu notta gelecekteki commit kimliği önceden yazılmadı.
3. Kullanıcı yalnız durum sorarsa özetle ve dur. Yeni alt adım veya push için yönlendirme bekle.
