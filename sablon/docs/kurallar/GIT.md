# Git işlemleri

Bu dosya commit önerirken, commit veya push yaparken okunur. Yalnız `git status` veya `git log` bakmak için okunmaz. Kırmızı çizgiler (`git add .` yasağı, dosyaları tek tek ekleme ve `.gitignore`, ayrı commit ve push onayı, `--force`/`reset --hard`/`clean`, yapay zekâ imzası yasağı) `AGENTS.md` içindedir.

## Commit

1. İlgili doğrulamaları çalıştır.
2. Değişen dosya listesini ve Türkçe commit mesajını öner. Liste, kodla birlikte değişen hafıza belgelerini (`DURUM.md`, `PLAN.md`, `GUNLUK.md`, kararlar, `PROJE.md`) de içerir.
3. Kullanıcı onayından sonra dosyaları tek tek ekle; `.gitignore` kapsamındaki dosya commit'e katılmaz.
4. Türkçe mesajı BOM'suz UTF-8 bir dosyaya yaz ve `git commit -F <dosya>` ile kullan.
5. Sonucu `git log --oneline -1` ve `git status --short` ile gözle; commit kimliğini bildir.

Kullanıcı commit kapsamını daraltırsa dışarıda kalan önemli kayıtları (ör. güncellenmiş `PLAN.md`) bildir; kendiliğinden ekleme.

## Push

- Push ayrı onay ister; commit onayı push onayı değildir.
- Push çıktısını kontrol et; `git ls-remote origin <dal>` çıktısındaki kimlik yerel `git rev-parse HEAD` ile aynı olmalı (`git status -sb` yalnız yerel izleme dalını gösterir). Bunu görmeden "GitHub'a kaydedildi" deme.
- Push reddedilirse veya sonucu kontrol edilemezse bunu açıkça yaz; `--force` ile aşma.

## Kaydın üç durumu

| Durum | Anlamı |
|---|---|
| Dosyaya yazıldı | Yalnız bu bilgisayarda; Git geçmişinde yok |
| Yerel commit oluşturuldu | Yerel Git geçmişinde; uzak depoda yok |
| Push edildi | Uzak depoda; ancak push sonucu gözlendiyse böyle bildirilir |

Otomatik commit, otomatik push veya gizli yedekleme kurulmaz.
