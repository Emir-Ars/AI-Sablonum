# Durum

- Son güncelleme: 2026-11-27 21:22 +03:00
- Sürüm: v0.3.8 (geliştirme).
- Güncel çalışma: v0.3.8 sürüm yükseltmesi, `README.md`, `docs/DURUM.md` ve `gorseller/akis.svg` güncellendi; Aşama 4 commit ve push bekliyor.

## Son yapılan

- Aşama 4 (v0.3.8 hazırlık): `surum.json` sürümü `0.3.8`, `pendingFeatures` alanı `agent-session-validation` yapıldı; `README.md`, `docs/DURUM.md` ve `gorseller/akis.svg` (`TASARIM.md` eklendi) güncellendi.
- Aşama 3 (`80c127f`, push edildi): `kur.ps1` ve `guncelle.ps1` içine `lfSha256` ve CRLF/LF-dirençli güncelleme + CRLF koruma eklendi; `tests/kur-smoke.ps1` tüm `.ps1` BOM denetimi, `R3` parite testi ve `U20` senaryosuyla genişletildi; `tests/bilinen-hashler.ps1` `FAZLA > 0` için `exit 1` yapacak şekilde sıkılaştırıldı; CI `paths` listesine workflow dosyası eklendi.
- Aşama 2 (`e35743e`, push edildi): `genel/KURALLAR.md` sadeleştirilip `14.784` karaktere indirildi (`.agent`/`.agents`/`.ai-sablon` koruması, §1.2 ve §6 "2 deneme sınırı" görünürlüğü, §3 yol haritası / `TASARIM.md` / `plan: K-xxx` / salt okunur alt ajan netleştirmeleri); önceki ortak metin LF hash'i (`5e91d920...`) `surum.json`'a eklendi.
- Aşama 1 (`bb83360`, push edildi): `PLANLAMA.md` eleştirel araştırma değerlendirme kuralı ve durum geçişleri eklendi; `ARSIVLEME.md` adım 7 günlük çelişkisi, `GIT.md` geçici mesaj dosyası, `sablonlar/TASARIM.md`, `PLAN.md`, `GUNLUK.md` ve 18 satırlık `DURUM.md` şablonu güncellendi.

## Doğrulama

- `tests/kur-smoke.ps1` (Windows PowerShell 5.1): 32 geçti, 0 kaldı, 2 atlandı (`7a` junction erişim engellendi, `8` ACL yazmayı engellemedi — yerel sandbox kısıtı).
- `tests/bilinen-hashler.ps1` (Windows PowerShell 5.1): geçti (`EKSİK=0`, `FAZLA=0`, 15 geçmiş ortak kısım).

## Açık kalan / sınırlar

- Yeni planlama ve eleştirel araştırma değerlendirme kurallarının gerçek bir ajan oturumunda (`plan` → kayıt → uygulama) davranışı henüz gözlenmedi (`agent-session-validation`).

## Sonraki devam noktası

Aşama 4 (v0.3.8) kullanıcı onayıyla commit edilip push edilebilir; ardından kurulu projeler (ör. `Darphane`, `TiktokGame`) kuru çalıştırmayla v0.3.8'e güncellenebilir.
