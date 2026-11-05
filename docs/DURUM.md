# Durum

- Son güncelleme: 2026-11-05 13:06
- Sürüm: v0.3.0 (geliştirme)
- Dal: main

## Kısa özet

Şablon v0.2'de sadeleşti (ayrıntı: `docs/KURAL_ESLEME.md`). v0.3.0 üç başlıkta ilerledi:

- A, kural metinleri: kapsam bazlı yetki (tek adım veya aralık), küçük iş istisnası, varsayım kuralı tek maddede, test komutunu projede keşfetme, kısaltılmış "Doğrulandı" satırı, netleşen inceleme katmanları.
- B, depo bakımı: `.gitattributes`, `GOREV_*.md` ignore, `DURUM.md` kurala uydu, README'ye var olan projeye kurulum ve izin ayarı önerileri.
- C, kurucu: `tests/kur-smoke.ps1` (16 senaryo), CI iş akışı, `guncelle.ps1` (kuru çalıştırma, yedekli uygulama) ve kayıtta `agentsCommonSha256`.

## Doğrulananlar (ayrıntı: `docs/arsiv/v0.2-gelistirme/DOGRULAMA.md` ve git geçmişi)

- `tests/kur-smoke.ps1` yerelde (Windows PowerShell 5.1, sürüm 0.3.0 sonrası): geçti=16 kaldı=0 atlandı=0. CI (`kurucu-smoke`, windows-latest) commit `fd36f40` için başarılı.
- `AGENTS.md` ortak kısmı `genel/KURALLAR.md` ile aynı (13.081 karakter, 56 madde). `guncelle.ps1` tasarımı ve kodu bağımsız alt ajanla incelendi.

## Doğrulanmayanlar

- Gerçek Codex ve Claude oturumlarında yeni kurallara (kapsam aralığı, küçük iş istisnası) uyum denenmedi.
- Kod incelemesinden sonra yapılan üç küçük düzeltme (salt okunur kayıt, üst yol dosya, başlıksız `AGENTS.md`) yeniden incelenmedi ve testle doğrudan sınanmadı.
- `guncelle.ps1` yazma atomik değil; satır sonu veya BOM farkı "kullanıcı değiştirmiş" sayılır. Ev klasörü iletisi bu makinede sınanmadı (önce "iç içe" iletisi çıkar).
- README'deki Codex değerleri yalnız belgede örnek geçenlerle sınırlı; Claude izin örneği çalışan bir oturumda denenmedi.
- Eski doğrulanmayanlar (SVG önizlemesi, `git mv` ile arşivleme, dolu `PLAN.md` yükü): `DOGRULAMA.md`.

## Sıradaki seçim

`GOREV_v0.3.md` görev bitince silinmeli (kullanıcı onayı bekliyor). Kullanıcının seçimi bekleniyor. Bu bölüm uygulama izni değildir.
