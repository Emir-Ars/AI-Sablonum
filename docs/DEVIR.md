# Güncel devir notu

- Kayıt zamanı: 2026-10-02 11:39; kabuktan alındı.
- Proje: Codex–Claude proje şablonu; `v0.1.0` geliştirme paketi, tamamlanmış sürüm yayını yok.
- Güncel çalışma birimi: **1.3 — tamamlandı ve doğrulandı**. 1.4'e başlanmadı.
- Durumun kaynağı: [Plan](PLAN.md). Kararlar: [Kararlar](KARARLAR.md). Kontrol sonuçları ve sorun geçmişi: [Günlük](GUNLUK.md).

## Git ve dosyalar

- Gözlenen baz commit: `1e2fdfcd662a6e17e372ab50f054d903764ebffd` — **Yerel şablon kurucusu ve sürüm kaydını ekle**.
- Dal `main`, uzak adres `https://github.com/Emir-Ars/AI-Sablonum.git`; kullanıcı kurdu. Git kimliği/uzak adresi değiştirilmedi. 1.2 ayrı onaylarla commit ve push edildi; bu oturum temiz çalışma ağacıyla başladı.
- Aşağıdaki 14 dosya değişmiş/yeni durumda. Kullanıcı bu 1.3 commitini ve push işlemini açıkça onayladı; kayıt hazırlanırken henüz işlem sonucu yok. Bu not kendisini içerecek gelecekteki commit kimliğini tahmin etmez.

## Tamamlanan iş ve doğrulama

- Hedefe kurulan salt okunur denetim betiği dosyaları, basit yerel belge bağlantılarını, sürüm kaydını ve eksik çalışma kayıtlarını kontrol eder. Kaynak/çıktı özetleri kurulum anını kaydeder; belgelerin normal değişmesi hata sayılmaz.
- Yeni kurulum 8 dosya içerir; kontrol betiği gerçek kaynak dosyasından aktarılır. Temiz başlangıç belgeleri geliştirme geçmişini taşımaz.
- Windows PowerShell **5.1.26100.9444** üzerinde **60/60 başarılı; başarısız 0, atlanan 0**, test çıkışı 0. Üç betikte ayrıştırma hatası 0; BOM baytları `239 187 191`. Komut, kapsam ve ara hatalar Günlük'tedir.
- Son test kaydı: `C:\Users\Emir\AppData\Local\Temp\ai-sablon-tests-90ff16eaaada438bbbedc392d64c5c51\SONUCLAR.json`. İzole test verileri geçici klasörde korunur; otomatik toplu silme yok.
- README, kurulum SVG'si, kayıt modelleri ve bu deponun kayıtları güncellendi. Ortak kaynak, root CLAUDE ve kurucu değişmedi.
- Son içerik denetiminde 18 dosya ve 42 yerel bağlantı başarılı; ortak kaynak/AGENTS eşleşti, temiz başlangıçlar korundu. Son testten sonra 8 kaynak özeti değişmedi. İki SVG geçerli XML; iki PNG önizleme üretildi ve görüntülenerek okunabilirlik kontrol edildi.
- UYARI: Paket `development` durumunda; gerçek VS Code davranış denemeleri bekliyor. Temiz kurulumda denetimin çıkış 2 vermesi beklenen uyarıdır. Çıkış 0: hata/uyarı yok; 1: hata; 2: yalnız uyarı.
- Denetim kullanıcı onayının gerçekliğini, testlerin gerçekten çalıştığını veya kodun doğruluğunu kanıtlamaz. Dış URL/başlık parçaları ve tam Markdown sözdizimi denetlenmez.
- UYARI: Önizlemede `Fontconfig error: No writable cache directories` tekrar görüldü; PNG üretimi ve görsel inceleme başarılı. Global önbellek değiştirilmedi; uyarı giderilmiş sayılmadı. Ayrıntı Günlük'tedir.

## Yarım işler ve bekleyenler

- 1.3 kapsamında yarım iş veya çözülmemiş başarısız kabul kontrolü yok. Son belge/görsel denetimi de tamamlandı; gerçek sonuçlar Günlük'tedir.
- 1.4: Codex/Claude VS Code davranış denemesi yapılmadı; gerçek araç uyumluluğu doğrulandı denmez. Kullanıcı bu adımın uygulamasını açıkça istedi; 1.3 gönderildikten sonra ilerlenir.
- Yeni paket kurulmadı; global skill, eklenti, ayar/kurulum dosyaları ve Windows görevleri değiştirilmedi. Gerçek projeye kurulum yapılmadı.
- Önceki ayrı kaldırma talebinin yedeği `C:\Users\Emir\ai-sablon-kaldirma-yedekleri\20261002-002951` konumunda korunur. Bu eski işlem yeni şablon kurucusunun özelliği değildir; tarihsel kanıt Günlük'tedir.

## Onaylı 1.3 commit kapsamı

Türkçe mesaj: **Elle kayıt denetimi ve bağımlılıksız kurulum testlerini ekle**.

Dosyalar tek tek seçilir; geçici test verileri/raporlar ve PNG önizlemeler commit kapsamına alınmaz:

```text
AGENTS.md
README.md
docs/PLAN.md
docs/KARARLAR.md
docs/GUNLUK.md
docs/DEVIR.md
gorseller/kurulum.svg
sablon/docs/PLAN.md
sablon/docs/KARARLAR.md
sablon/docs/GUNLUK.md
sablon/docs/DEVIR.md
surum.json
sablon/.ai-sablon/kontrol.ps1
tests/Kurulum.Tests.ps1
```

## Devam yönlendirmesi

1. Proje kurallarını, Plan'ı ve bu notu oku; `git status --short` ve `git log --oneline -5` ile disk durumunu karşılaştır. UYARI satırlarını ilk özette bildir.
2. Kullanıcı 1.3 commit ve push işlemini açıkça onayladı. Yalnız yukarıdaki 14 dosyayı seç; gerçek sonucu Git geçmişinden okuyup kaydet.
3. Kullanıcı aynı mesajda 1.4 uygulamasını istedi. 1.3 gönderildikten sonra gerçek VS Code davranış denemelerine ilerle; gözlenmeyen sonucu başarılı sayma.
