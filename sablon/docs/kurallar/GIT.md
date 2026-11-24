# Git işlemleri

Bu dosya commit önerirken, commit, push, birleştirme veya dal silme yaparken ve push sonrası CI kontrolünde okunur. Yalnız `git status` veya `git log` bakmak için okunmaz. Kırmızı çizgiler (`git add .` yasağı, dosyaları tek tek ekleme ve `.gitignore`, ayrı commit, push, birleştirme ve dal silme onayı, `--force`/`reset --hard`/`clean`, yapay zekâ imzası yasağı) `AGENTS.md` içindedir.

## Commit

1. İlgili doğrulamaları çalıştır.
2. Değişen dosya listesini ve Türkçe commit mesajını öner. Liste, kodla birlikte değişen hafıza belgelerini (`DURUM.md`, `PLAN.md`, `GUNLUK.md`, kararlar, `PROJE.md`) de içerir.
3. Kullanıcı onayından sonra dosyaları tek tek ekle; `.gitignore` kapsamındaki dosya commit'e katılmaz.
4. Türkçe mesajı BOM'suz UTF-8 bir dosyaya yaz ve `git commit -F <dosya>` ile kullan.
5. Sonucu `git log --oneline -1` ve `git status --short` ile gözle; commit kimliğini bildir.

Kullanıcı commit kapsamını daraltırsa dışarıda kalan önemli kayıtları (ör. güncellenmiş `PLAN.md`) bildir; kendiliğinden ekleme.

Git "LF will be replaced by CRLF" uyarısı veriyorsa `docs/kurallar/WINDOWS.md` satır sonu maddesine bak.

## Git işleminden sonra durma

- Commit, push, birleştirme veya dal silmeden sonra dur (`AGENTS.md` §1.2). "Dur", sonraki plan adımına geçmemek demektir. Git işleminin kendi kontrolü (push doğrulaması, izin varsa CI okuma) ve kaydı tamamlanır.
- Kalan aralık yetkili kalır; kullanıcının devam mesajı kalan aralığı sürdürür. "Commit et ve 2.4'e geç" gibi tek mesaj, hem işlemi hem devamı kapsar.

## Birleştirme ve dal silme

- Dal birleştirme (yerel `git merge` veya uzak depodaki birleştirme isteğini birleştirme) açık onay ister; commit veya push onayı birleştirme onayı değildir.
- Uzak depodaki işlemler (birleştirme isteği açmak veya birleştirmek) ağ işlemidir ve sorulur; sonucu gözlenmeden "birleştirildi" denmez.
- Dal silme (yerel `git branch -d`, uzak `git push origin --delete <dal>`) ayrı onay ister; birleştirme onayı dal silme onayı değildir. Silmeden önce dalın hedefe birleştirildiği gözlenir; gözlenemiyorsa (ör. uzak depoda sıkıştırılarak birleştirilmiş dal) bunu kullanıcıya söyle ve onay bekle. Birleştirilmemiş yerel veya uzak dalı silmek (`git branch -D` dahil) ayrıca sorulur.

## Push

- Push ayrı onay ister; commit onayı push onayı değildir.
- Push çıktısını kontrol et; `git ls-remote origin <dal>` çıktısındaki kimlik yerel `git rev-parse HEAD` ile aynı olmalı (`git status -sb` yalnız yerel izleme dalını gösterir). Bunu görmeden "GitHub'a kaydedildi" deme.
- Push reddedilirse veya sonucu kontrol edilemezse bunu açıkça yaz; `--force` ile aşma.

## Push sonrası CI

Projede CI (push'ta çalışan otomatik denetim) varsa uygulanır; yoksa bu bölüm atlanır.

- **İzin:** CI sonucunu okumak ağa erişimdir. Projede kural yoksa ilk push'ta sor: ajan salt okunur komutla (ör. `gh run list`, `gh run view`) kendisi mi bakacak, sonucu kullanıcı mı iletecek? Cevabı `AGENTS.md` "Projeye özel kurallar" bölümüne tek madde olarak yaz. İzin yoksa veya CI okunamıyorsa sonucu kullanıcıdan iste.
- **Yalnız okuma:** İş akışını başlatma, yeniden çalıştırma ve CI ayarını değiştirme ayrıca onay ister.
- **Sonuç:** CI sonucu gözlenmeden "CI geçti" yazılmaz.
  - Adımın doğrulaması CI'ı içeriyorsa (`PLAN.md` "Doğrulama" sütunu), adım yeşil sonuç görülene kadar "Doğrulama bekliyor" kalır.
  - Kırmızı, iptal edilmiş veya okunamayan sonuçta durum değişmez. Gözlenen sonuç `GUNLUK.md`'ye yazılır ve kullanıcıya hemen bildirilir.
- **Kayıt:** Commit, push, CI, birleştirme ve dal silme sonucu alt adımın tek sonuç kaydında toplanır. Kayıt ilk Git işleminde açılır; sonradan gelen sonuç, kayıt hâlâ günlüğün son kaydıysa sonuna yeni satır olarak eklenir. Var olan satırlar değiştirilmez. Araya başka kayıt girdiyse sonuç kısa yeni kayıtla yazılır. Aşama kapanış commit'inin sonucu, arşiv değişmediği için yeni aktif `GUNLUK.md` dosyasına "Aşama N kapanış sonucu" kaydı olarak yazılır (`ARSIVLEME.md` "Kurallar").
- **Durum satırları:** `PLAN.md` durumu ve `DURUM.md` "Git" satırı aynı anda güncellenir. "Git" satırı son gözlenen commit'i ve CI durumunu (yeşil, kırmızı, bekliyor) taşır; CI çalıştırma kimliği yalnız `GUNLUK.md`'dedir.
- **Kendi kimliği:** Commit kendi kimliğini içeremez; kayıtlara yalnız gözlenen commit kimliği yazılır. Commit veya push sonrası yazılan kayıt satırları commit edilmemiş kalır. Bu kayıt sonraki adımın commit'iyle ya da kullanıcı isterse ayrı bir kayıt commit'iyle gider; durum `DURUM.md` "Git" satırında belirtilir.
- **Atlatma yok:** CI'ı atlatan commit mesajı ifadeleri (ör. `[skip ci]`, `[ci skip]`) kullanılmaz.

## Kaydın üç durumu

| Durum | Anlamı |
|---|---|
| Dosyaya yazıldı | Yalnız bu bilgisayarda; Git geçmişinde yok |
| Yerel commit oluşturuldu | Yerel Git geçmişinde; uzak depoda yok |
| Push edildi | Uzak depoda; ancak push sonucu gözlendiyse böyle bildirilir |

Otomatik commit, otomatik push veya gizli yedekleme kurulmaz.
