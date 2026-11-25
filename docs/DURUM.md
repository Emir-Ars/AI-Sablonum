# Durum

- Son güncelleme: 2026-11-25 15:16:18 +03:00
- Sürüm: v0.3.6 (geliştirme).
- Yerel dal `main` üzerindeki son commit `aae649a`. Önceki kayıtta `123851b` gönderimi uzak depodan doğrulandı. Bu düzenlemeler çalışma klasöründe.
- Güncel çalışma: geliştirme rehberi sadeleştirildi ve yerel çalışma belgeleri Git tarafından yok sayılan `yerel-yedek/` klasörüne taşındı.

## Son yapılan

- Kısa plan satırı aynı etkin planda numaralı alt satırlara ayrılıyor. Planlama belgeleri kaydediyor. Açık uygulama komutu belirtilen satırı veya aralığı kapsıyor.
- Depo ajanı kullanıcıyla doğrudan çalışır. Kök `AGENTS.md` deponun geliştirme rehberidir. Kök `CLAUDE.md` aynı rehberi yükler.
- Yerel görev ve araştırma dosyaları `yerel-yedek/` içinde. İncelemeler, sürüm doğrulamaları ve geliştirme arşivi `yerel-yedek/docs/` altında.

## Doğrulama

- Windows PowerShell 5.1 ile bu düzenlemede 28 senaryo geçti. İki Windows izin senaryosu atlandı (7a ve 8). Başarısız senaryo yok. R2, kök rehberleri içermeyen paket ile tam deponun aynı ajan dosyalarını kurduğunu doğruladı. Tam Git geçmişinin geçici kopyasında hash denetimi EKSİK=0, FAZLA=0.
- Geçici projede plan kaydı ve yeniden planlama kod dosyalarını değiştirmedi. İlk alt adımın testi geçti, ikinci alt adım `Planlandı` kaldı.
- Ayrı geçici projede v0.3.5 → v0.3.6 geçişi doğrulandı. Dolu plan ve projeye özel bölüm korundu.

## Açık kalan / sınırlar

- Sohbetle sınırlı mod ve aralık yetkisi metin üzerinden kontrol edildi. Yeni bir Codex veya Claude oturumunda komut yorumlama denenmedi.

## Sonraki devam noktası

Yeni bir şablon fikri doğrudan bu depoda ele alınabilir. Önceki gönderimin CI sonucu için kullanıcının izni veya ileteceği sonuç bekleniyor.
