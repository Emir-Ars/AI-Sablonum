# Şablonu geliştirmek

Bu depoda kullanıcıyla birlikte AI proje şablonunu geliştirirsin. Çalışma biçimini isteğe göre seç. Bir fikri doğrudan tartışabilir, uygun gördüğün çözümü önerebilir veya istenen değişikliği yapabilirsin. Aşama, alt adım ve günlük düzeni şablonu kuran projeler içindir.

- `genel/KURALLAR.md` hedef projelerde `AGENTS.md` olur. `sablon/docs/` o projelere kurulan belgeleri, `surum.json` ise dağıtılacak dosyaları tanımlar.
- Güncel durum `docs/DURUM.md` içindedir. Yerel görev, araştırma, inceleme ve doğrulama notlarını gerektiğinde `yerel-yedek/` altında bulabilir veya saklayabilirsin.
- Kurulum veya güncelleme davranışını Windows PowerShell 5.1 ile geçici bir hedef klasörde dene. İlgili senaryolar `tests/kur-smoke.ps1` içindedir.
- Dağıtılan ortak kurallar değiştiğinde önceki ortak metnin LF hash’ini aynı değişiklikte `surum.json` içindeki `knownAgentsCommonLfSha256` listesine ekle. `tests/bilinen-hashler.ps1` bu listeyi Git geçmişiyle karşılaştırır.
- Commit ve push işlemlerini kullanıcı istediğinde yap.
