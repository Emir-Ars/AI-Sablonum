# AI proje şablonu (Codex + Claude)

Codex ve Claude ile VS Code'da proje geliştirirken aynı çalışma düzenini kullanmak için kurulan küçük bir kural ve belge paketi.

Hedefler:
- **Bağlamı küçük tutma:** her oturumda kısa kurallar, durum notu ve planın yalnız başlangıç bölümü ile ilgili adımları okunur; ayrıntılı rehberler yalnız ilgili işte okunur.
- **Düzenli ilerleme:** genel plan → aşama planı → alt adım; ajan yalnız senin yetkilendirdiğin adımı veya adım aralığını uygular.
- **Unutmama:** kayıtlar iş sırasında (adım bitince, karar değişince, iş durunca) repo dosyalarına yazılır; sohbet veya araç değişse de son kayıt noktasından devam edilir.
- **Eski aşamaları okumama:** biten aşama arşive taşınır, kalıcı bilgisi ana belgelere aktarılır.

![Proje akışı](gorseller/akis.svg)

## Kurulum

Şablon paketinin kökünde Windows PowerShell ile:

```powershell
powershell.exe -NoProfile -File .\kur.ps1 -TargetDirectory "C:\Projeler\ProjeAdi"
```

Betik çalıştırma engellenirse yalnız bu işlem için:

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\kur.ps1 -TargetDirectory "C:\Projeler\ProjeAdi"
```

Kurucu yalnız yeni dosya ekler. Kurulacak dosyalardan biri hedefte varsa hiçbir şey yazmadan durur. Ağ veya Git işlemi yapmaz; `.claude`, `.codex` ve diğer global klasörlere dokunmaz. Projendeki diğer dosyalar olduğu gibi kalır.

Ajana repo bağlantısını verip kurdurmak istersen şunu söyleyebilirsin:

> Bu şablon reposunu geçici bir klasöre indir, kur.ps1 ile şu anki projeme kur, kurulum sonucunu göster ve geçici klasörü yalnız benim onayımla sil.

## Var olan projeye kurulum

Hedefte `AGENTS.md`, `CLAUDE.md` veya `docs/` altında kurulacak dosyalardan aynı adlı biri varsa kurucu hiçbir şey yazmadan durur. Elle birleştirmek için:

1. Şablonu boş bir geçici klasöre kur.
2. Projendeki mevcut `AGENTS.md` / `CLAUDE.md` içeriğini kurulan `AGENTS.md` dosyasının "Projeye özel kurallar" bölümüne taşı.
3. Projendeki `CLAUDE.md` dosyasının ilk satırına `@AGENTS.md` ekle.
4. Çakışmayan `docs/` dosyalarını projene kopyala.

Uyarı: projen `docs/` klasörünü MkDocs, Docusaurus veya GitHub Pages gibi bir belge sitesi için kullanıyorsa şablon belgeleri o sitede yayımlanabilir; site ayarında bu dosyaları dışarıda bırak.

## Önerilen araç izin ayarları

`AGENTS.md` içindeki kurallar düz metindir; ajanın bunlara uyması model davranışına bağlıdır. Asıl teknik koruma ve gereksiz izin pencerelerinin azaltılması aracın kendi izin ayarlarıyla yapılır. Aşağıdakiler yalnız öneridir; kurucu ve ajan bu dosyalara yazmaz, onları sen oluşturursun.

**Claude Code.** Proje düzeyinde `.claude/settings.json` (söz dizimi [Claude Code ayar belgesinden](https://code.claude.com/docs/en/settings) ve [izin belgesinden](https://code.claude.com/docs/en/permissions) doğrulandı):

```json
{
  "permissions": {
    "allow": [
      "Bash(git status *)",
      "Bash(git log *)",
      "Bash(git diff *)"
    ],
    "deny": [
      "Bash(git push --force *)",
      "Bash(git reset --hard *)",
      "Bash(git clean *)",
      "Read(./.env)",
      "Read(./.env.*)"
    ]
  }
}
```

- `allow` listesine projenin yerel test komutunu da ekleyebilirsin (ör. `Bash(npm run test *)`); komutu projene göre sen yaz.
- Bash kuralları komut metnini eşler: belgeye göre `git -C . push` gibi farklı yazılmış bir komut `Bash(git push *)` kuralına uymaz. Bu liste ek bir güvenlik katmanıdır, tek başına kesin engel değildir. `git push --force` yerine `-f` kısaltmasını ayrıca yasaklamak istersen `Bash(git push -f *)` ekle.

**Codex.** Onay ve sandbox ayarları `config.toml` dosyasında yapılır: kullanıcı düzeyinde `~/.codex/config.toml`, proje düzeyinde `.codex/config.toml` (yalnız güvenilen projelerde yüklenir). İlgili anahtarlar `approval_policy` (ör. `"on-request"`) ve `sandbox_mode` (ör. `"workspace-write"`) anahtarlarıdır. Geçerli değerlerin tam listesini [Codex belgesinden](https://developers.openai.com/codex/config-basic) kontrol et; bu README'de yalnız belgede örnek olarak geçenler anılmıştır.

## Kurulu projeyi güncelleme

Daha önce `kur.ps1` ile kurduğun bir projeyi yeni şablon sürümüne getirmek için paketin kökünde:

```powershell
# Önce kuru çalıştırma: yalnız rapor verir, hiçbir dosya yazmaz
powershell.exe -NoProfile -File .\guncelle.ps1 -TargetDirectory "C:\Projeler\ProjeAdi"

# Raporu beğendiysen uygula
powershell.exe -NoProfile -File .\guncelle.ps1 -TargetDirectory "C:\Projeler\ProjeAdi" -Uygula
```

| Durum | Ne olur |
|---|---|
| Yeni şablonda olan, projede ve kurulum kaydında olmayan dosya | Eklenir |
| Dosya kurulumdan beri değişmemiş, şablondaki hâli farklı | Güncellenir |
| Dosya şablonla zaten aynı | İşlem yok |
| Dosyayı kurulumdan sonra sen değiştirmişsin | Dokunulmaz, raporlanır |
| Kurulum kaydında olup projede olmayan dosya | Sildiğin sayılır, geri yazılmaz |
| Kurulum kaydında olup yeni şablonda olmayan dosya | Silinmez, raporlanır |
| `AGENTS.md` | "Projeye özel kurallar" başlığından önceki ortak kısım, kurulumdan beri değişmemişse veya bilinen bir eski şablon sürümüyle birebir aynıysa yenilenir; başlık ve sonrası aynen korunur, dosyanın satır sonu biçimi (CRLF/LF) korunur |

- **Eski kurulumlar:** v0.2.0 ve sonrası desteklenir. v0.3.0'dan önce kurulmuş projelerde `AGENTS.md` ortak kısmı, paketteki bilinen eski sürümlerden biriyle birebir aynıysa otomatik yenilenir. Ortak kısmı sen değiştirdiysen veya tanınmayan bir sürümse dokunulmaz; `-Uygula` ile yeni ortak kısım `.ai-sablon/yeni-AGENTS-ortak.md` dosyasına yazılır, elle birleştirirsin. v0.1 kurulumları reddedilir; "Var olan projeye kurulum" bölümündeki elle birleştirme yolunu kullan.
- **Güvenlik:** üzerine yazılan her dosyanın eski hâli önce `.ai-sablon/yedek/<tarih-saat>/` altına kopyalanır. Hiçbir dosya silinmez. Yedek alınamazsa hiçbir dosya değiştirilmez. Kurulu sürüm paketten yeniyse güncelleme reddedilir.
- **Sınırlar:** yalnız satır sonu (CRLF/LF) farkı olan dosya "aynı" sayılır ve yeniden yazılmaz. Bunun dışındaki karşılaştırma bayt düzeyindedir: BOM eklenmiş veya içeriği değişmiş dosya "sen değiştirmişsin" diye raporlanır ve güvenli tarafta kalınır. Hedefte `.ai-sablon/kurulum.json` yoksa betik çıkış kodu 1 ile durur.
- Betik yalnız `kur.ps1` ile kurulmuş projeler içindir ve yedekten geri yükleme yapmaz; geri almak için yedek klasöründeki dosyayı kendin kopyalarsın.

### Dolu belgeleri yeni biçime geçirme

Güncelleyici doldurduğun belgeleri korur ve yeni biçime çevirmez. v0.3.2 ile gelen değişiklikler için:

1. Güncelleyiciyi önce kuru çalıştır ve raporu incele.
2. Onayladığın güncellemeyi `-Uygula` ile uygula. Yeni rehberler (`docs/kurallar/PLANLAMA.md`, `GIT.md`, `WINDOWS.md`) eklenir; değiştirmediğin şablon dosyaları yenilenir.
3. "Kullanıcı değiştirmiş" diye korunan dolu belgelerdeki yeni alanları elle birleştir: `DURUM.md` yeni başlıkları, `PLAN.md` başındaki "Başlangıç" bölümü ve "İlgili kaynaklar" sütunu, karar kayıtlarındaki "Önceki karar" alanı. `docs/KARARLAR.md`, `aktif-asama/GUNLUK.md` ve `PROJE.md` başındaki açıklama satırlarını yeni şablondakiyle değiştir (eski başlıklar "en çok üç kayıt" ve "eski kararda cümle düzeltilir" der; çelişkide `AGENTS.md` geçerlidir). Var olan bilgiyi, adım ve K-numaralarını koru; eski kayıtları yeniden yazma. Boş yeni biçimler `docs/kurallar/sablonlar/` altındadır; `DURUM.md`, `KARARLAR.md` ve `PROJE.md` için paketteki `sablon/docs/` dosyalarına bak.
4. Yalnız `AGENTS.md` ortak kısmının güncellenmesi dolu proje belgelerini otomatik olarak yeni biçime dönüştürmez.
5. Projende şablondan gelmeyen aynı adlı bir dosya varsa (ör. kendi `docs/kurallar/GIT.md` dosyan) güncelleyici onu korur ve raporlar; rehber kurulmaz. Bu durumda dosyanı yeniden adlandırıp güncellemeyi tekrar çalıştır veya içerikleri elle birleştir.

Ajana örnek mesaj: "docs/kurallar/sablonlar altındaki yeni PLAN ve DURUM biçimini mevcut belgelerime uygula; bilgileri ve numaraları koru, önce farkları göster, onayımdan sonra yaz."

## Kurulan dosyalar

```text
ProjeAdi/
├── AGENTS.md                 Kurallar (Codex okur; her oturumda yüklenir)
├── CLAUDE.md                 @AGENTS.md (Claude aynı kuralları okur)
├── .ai-sablon/kurulum.json   Kurulan sürüm ve dosya özetleri
└── docs/
    ├── DURUM.md              Şu an neredeyiz (oturum başında ilk okunan)
    ├── YOL_HARITASI.md       Ana aşamalar ve durumları
    ├── KARARLAR.md           Karar dizini (hepsi, tek satır) + proje geneli kararların tam metni
    ├── ACIK_KONULAR.md       Bekleyen kararlar, proje düzeyi sınırlar, devreden notlar
    ├── PROJE.md              Kodun güncel yapısı, komutlar, veri biçimleri
    ├── arastirma/            Genel araştırma belgelerin
    ├── aktif-asama/          Yalnız şu anki aşama
    │   ├── TASARIM.md        Aşama tasarımı, riskler, farklar (durum yazılmaz)
    │   ├── PLAN.md           Alt adımlar (1.1, 1.2 …) ve durumları
    │   ├── KARARLAR.md       Yalnız bu aşamayı ilgilendiren kararların tam metni
    │   ├── GUNLUK.md         Yapılan iş ve test sonuçları
    │   └── arastirma/        Bu aşamanın araştırma belgeleri
    ├── arsiv/                Biten aşamalar (her oturumda okunmaz)
    └── kurallar/             Yalnız gerektiğinde okunan ayrıntılar
        ├── PLANLAMA.md       Yol haritası, aşama planı, test komutu bulma
        ├── ARSIVLEME.md      Aşama kapanış adımları
        ├── INCELEME.md       Riskli işlerde bağımsız inceleme
        ├── GIT.md            Commit ve push ayrıntıları
        ├── WINDOWS.md        PowerShell ve dosya kodlaması
        └── sablonlar/        Yeni aşama için boş PLAN/TASARIM/KARARLAR/GUNLUK
```

## Kullanım

| Ne zaman | Ne yaparsın | Ajana örnek mesaj |
|---|---|---|
| Başlangıç | Genel araştırma belgelerini `docs/arastirma/` altına koy | "Araştırma belgelerini oku, yalnız yol haritasını hazırla." |
| Aşamaya başlarken | O aşamanın araştırma belgelerini `docs/aktif-asama/arastirma/` altına koy | "2. aşamayı başlat: araştırmayı oku, alt adımları planla, uygulama yapma." |
| Uygulama | Tek adım seç | "Yalnız 2.3'ü uygula." |
| Uygulama (aralık) | Birden fazla adımı birlikte yetkilendir | "2.3–2.5'i uygula." |
| Küçük düzeltme | Plan açmadan küçük iş iste | "README'deki yazım hatasını düzelt." |
| Yeni kural | Çalışırken söyle | "Bundan sonra bütün tarihler UTC olsun, kurallara ekle." |
| Oturum sonu / araç değişimi | Son kontrolü yaptır | "Kayıtları son kez kontrol et, DURUM.md'yi güncelle." |
| Yeni oturum | Durumu okut | "Bu projenin durumunu ve yarım kalan işi dosyalardan bul. İlgili kaynakları belirt, henüz uygulama yapma." |
| Aşama bitince | Kapat | "2. aşamayı kapat ve arşivle." |

## Hafıza ve kayıt

- **Ne zaman yazılır:** ajan kayıtları oturum sonunu beklemeden günceller: alt adım bitince, doğrulama sonucu değişince, önemli karar veya kapsam değişince, iş durunca, senden yanıt beklemeye başlayınca ve uzun işte pahalı bir ara sonuç çıkınca. Her komut için ayrı kayıt açılmaz. Ani kesintide son kayıt noktasından sonraki iş kaybolabilir.
- **Ne okunur:** yeni oturumda `DURUM.md`, `PLAN.md` başlangıç bölümü, aşama kuralları ve güncel adım; aynı sohbette yalnız değişen bilgi. Günlük ve arşiv aranır, baştan sona okunmaz.
- **Bağlam ve token:** bir dosyayı bir kez okumak, sonraki isteklerde sıfır bağlam veya token maliyeti anlamına gelmez; okunan metin sohbet bağlamında kalır ve `AGENTS.md` her oturumda yeniden yüklenir. Bu yüzden sürekli yüklenen kurallar kısa tutulur. Gerçek tasarruf ölçülmedi; ölçmek için aracın kendi bağlam göstergesini kullanabilirsin (ör. Claude Code'da `/context`).
- **Hafıza nerede:** bu şablon reposu yalnız boş başlangıç belgelerini tutar. Her proje kendi hafızasını (`docs/` altındaki durum, plan, günlük ve kararlar) kendi reposunda saklar. `.ai-sablon/kurulum.json` ilerleme günlüğü değildir; yalnız kurulan şablon sürümünü ve dosya özetlerini güncelleyici için tutar.

### Kayıt nerede durur?

| Durum | Anlamı | Nasıl anlaşılır |
|---|---|---|
| 1. Dosyaya yazıldı | Yalnız bu bilgisayarda; Git geçmişinde yok | `git status` dosyayı değişmiş gösterir |
| 2. Yerel commit oluşturuldu | Yerel Git geçmişinde; GitHub'da henüz yok | `git log` commit'i gösterir; `git status -sb` "ahead" der |
| 3. GitHub'a push edildi | Uzak depoda | Push çıktısı başarılıdır ve `git ls-remote origin <dal>` yerel commit kimliğini gösterir |

Commit ve push ayrı onay ister; otomatik commit, push veya gizli yedekleme yoktur. Ajan push sonucunu kontrol etmeden "GitHub'a kaydedildi" demez.

## Biten aşama nasıl ayrılır?

Aşama kapanırken ajan `docs/kurallar/ARSIVLEME.md` adımlarını uygular. "Aşamayı kapat" demen kapanışın mekanik işlerini (kararlaştırılmış bilgiyi aktarma, özet, taşıma, bağlantı düzeltme, boş aşama açma) kapsar; bunlar için tek tek onay istenmez. Yeni karar, emin olunmayan bilgiyi silme, arşivin üzerine yazma ve sonraki aşamaya başlama sana sorulur; commit ve push ayrı onaydır.

1. Bütün testleri çalıştırır, kapanış ölçütlerini kontrol eder.
2. Sonraki aşamaları etkileyen her şeyi ana belgelere taşır: kararların tam metnini `docs/KARARLAR.md`, kod/komut/veri biçimi bilgisini `docs/PROJE.md`, açık işleri `docs/ACIK_KONULAR.md` ve `docs/DURUM.md`. Emin olmadığını sana sorar.
3. Ana belgelerde birikmeyi temizler: yerine geçilmiş kararların tam metni arşive gider, dizinde tek satırı kalır (K-numarasına verilen bağlantılar kırılmaz).
4. Aşamaya kısa bir `OZET.md` yazar.
5. `docs/aktif-asama/` klasörünü bütünüyle `docs/arsiv/02-ad/` gibi bir klasöre taşır, bağlantıları yeni konuma göre düzeltir ve yerine boş bir aşama klasörü açar.
6. Yol haritasında aşamayı "Tamamlandı" yapar, arşiv bağlantısını ekler.

Sonuç: 3. aşamada çalışırken ajan 2. aşamanın günlüğünü ve kararlarını okumaz. Yalnız 2. aşamadan geriye kalan ve hâlâ geçerli olan bilgiyi (ana `KARARLAR.md` ve `PROJE.md`) görür.

## Kuralları değiştirmek

- **Tek projede kalıcı kural:** ajana söylemen yeterli; `AGENTS.md` dosyasının sonundaki "Projeye özel kurallar" bölümüne ekler.
- **Uzun, yalnız belirli işlerde gereken kural:** `docs/kurallar/proje-<konu>.md` dosyasına yazılır; `AGENTS.md` içinde tek satırlık işaretçi kalır.
- **Yalnız aktif aşamada geçerli kural:** aşamanın `PLAN.md` dosyasındaki "Aşama kuralları" bölümüne eklenir, aşamayla arşive gider.
- **Bütün projeler için:** bu repoda `genel/KURALLAR.md` düzenlenir. Kurulmuş projeler kendiliğinden güncellenmez.

## Bu repodaki dosyalar

| Dosya | Görev |
|---|---|
| `genel/KURALLAR.md` | Hedef projeye `AGENTS.md` olarak kurulan kurallar |
| `sablon/docs/` | Hedef projeye kurulan başlangıç belgeleri |
| `kur.ps1`, `surum.json` | Kurucu ve kurulacak dosya listesi |
| `guncelle.ps1` | Kurulu projeyi yeni şablon sürümüne getirir (kuru çalıştırma + yedekli uygulama) |
| `tests/kur-smoke.ps1` | Kurucu ve güncelleme betiğinin duman testi (`.github/workflows/kurucu-smoke.yml` ile CI'da da çalışır) |
| `tests/bilinen-hashler.ps1` | Eski ortak kural hash listesini Git geçmişiyle karşılaştırır (tam geçmiş gerekir) |
| `gorseller/akis.svg` | Akış görseli |
| `docs/KURAL_ESLEME.md` | v0.1'deki kuralların v0.2'de nereye gittiği |
| `docs/arsiv/v0.1-gelistirme/` | Şablonun v0.1 geliştirme geçmişi |
| `docs/HAFIZA_TOKEN_DOGRULAMA.md` | v0.3.2 hafıza ve token iyileştirmesinin doğrulama raporu |

Sürüm 0.3.2, durum "geliştirme". Doğrulama sonuçları ve açık sınırlar `docs/DURUM.md` içindedir.
