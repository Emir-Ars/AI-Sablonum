# v0.1 → v0.2 kural eşlemesi

Bu belge yalnız şablon reposunda durur, projelere kurulmaz. v0.1'deki kuralların v0.2'de nereye gittiğini gösterir.

## Boyut

| | v0.1 | v0.2 |
|---|---|---|
| Her oturumda yüklenen kural (`AGENTS.md`) | ~25.000 karakter, 110 madde | ~10.800 karakter, 55 madde |
| Her oturumda okunan belgeler | Plan + Devir (proje büyüdükçe uzar) | `DURUM.md` (en fazla 30 satır) + aktif aşamanın `PLAN.md` dosyası |
| Yalnız gerektiğinde okunan kural | Yok | `docs/kurallar/ARSIVLEME.md`, `docs/kurallar/INCELEME.md` |

## Nasıl azaldı?

Azaltma üç yolla yapıldı; hiçbir koruma kaldırılmadı:

1. **Tekrarlar birleştirildi.** "Plan/durum/devir/arşiv uygulama izni değildir" cümlesi v0.1'de 10'dan fazla yerde geçiyordu; v0.2'de kırmızı çizgilerde bir kez geçer. "Doğrulanmamışı doğrulandı sayma" cümlesi de yaklaşık 8 yerden tek maddeye indi.
2. **Nadiren gereken prosedürler ayrı dosyaya taşındı.** Aşama arşivleme (13 madde) ve bağımsız inceleme (9 madde) her oturumda değil, yalnız o iş yapılırken okunur.
3. **Çekince ve açıklama cümleleri çıkarıldı.** "Bu kural teknik kilit değildir", "denetim betiği X'i kanıtlamaz", "model ayarı değiştirilmez" gibi ajana iş yaptırmayan cümleler, öğrenme/mühendislik anlatımı maddeleri ve kurulum denetimiyle (`kontrol.ps1`) ilgili kurallar kaldırıldı.

## Bölüm bölüm

| v0.1 bölümü | Madde | v0.2'deki yeri | Değişiklik |
|---|---|---|---|
| İletişim ve kapsam | 7 | §2 İletişim | "Yöntemlere yapay sınır koyma" gibi çekinceler çıktı; açıklama biçimi tek maddeye indi |
| Araştırma ve belirsizlik | 6 | §8 (1 madde) + §1.5 | Doğrulama sırası korundu, ayrıntılar kısaldı |
| Planlama ve uygulama izni | 16 | §1.1–1.2 + §3 | Senin akışına göre yeniden yazıldı: araştırma → yol haritası → aşama araştırması → aşama planı → alt adım |
| Teknik kalite ve aşama bazında anlatım | 7 | §8 | Öğrenme/anlatım maddeleri çıktı; yapı haritası `PROJE.md` dosyasına taşındı |
| Ortak proje kayıtları | 16 | §4 + §5 | Tek tabloyla "ne nereye yazılır"; Devir yerine kısa `DURUM.md`; okunmayacak dosyalar açıkça yazıldı |
| Hazırlık ve aşama arşivi | 13 | §7 (özet) + `docs/kurallar/ARSIVLEME.md` | Sabit klasör düzeniyle sadeleşti: aktif aşama klasörü bütünüyle taşınır |
| Test ve doğrulama | 14 | §9 | Aynı kurallar, daha kısa |
| Bağımsız inceleme | 9 | §9 (1 madde) + `docs/kurallar/INCELEME.md` | Üç katman korundu |
| Dosyaları ve kurulumu koruma | 7 | §1.4, §1.6, §8 | Kurulum özeti/SHA kuralları çıktı |
| Git ve dış sistemler | 11 | §1.3 + §10 + §9 | Aynı kurallar |
| Windows ve kalıcı kurallar | 7 | §11 + §6 | Kabuk kuralı kabuktan bağımsız yazıldı |
| — | — | §6 Yeni kural verildiğinde | **Yeni:** çalışırken verilen kuralın nereye yazılacağı |
| — | — | `ARSIVLEME.md` adım 3, §5, §6 | **Yeni:** ana belgelerde birikme sınırları (eski kararlar, `PROJE.md`, özel kurallar, devreden işler, genel araştırma) |

## Belge yapısı

| v0.1 | v0.2 |
|---|---|
| `docs/PLAN.md` (yol haritası + aşama ayrıntısı birlikte) | `docs/YOL_HARITASI.md` (yalnız ana aşamalar) + `docs/aktif-asama/PLAN.md` (yalnız aktif aşama) |
| `docs/KARARLAR.md` (bütün kararlar) | `docs/KARARLAR.md` (proje geneli) + `docs/aktif-asama/KARARLAR.md` (aşamaya özgü) |
| `docs/GUNLUK.md` (sürekli büyür) | `docs/aktif-asama/GUNLUK.md` (aşamayla arşive gider) |
| `docs/DEVIR.md` | `docs/DURUM.md` (en fazla 30 satır) |
| Yok | `docs/PROJE.md` (kodun güncel hâli; aşamalar arası köprü) |
| Yok | `docs/arastirma/`, `docs/aktif-asama/arastirma/` |
| Yok | `docs/ACIK_KONULAR.md` (bekleyen kararlar, proje düzeyi sınırlar, devreden notlar) |
| Yok | `docs/aktif-asama/TASARIM.md` (aşama tasarımı, riskler, farklar) |
| Karar numarası: her yerde `K-NNN` | Aynı: bütün proje boyunca artan `K-NNN`; `docs/KARARLAR.md` başında her kararın tek satırlık dizini |
| `.ai-sablon/kontrol.ps1` | Kaldırıldı (eski belge biçimini denetliyordu) |
