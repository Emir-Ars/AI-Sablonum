# Durum

- Son güncelleme: 2026-11-26 09:51:52 +03:00
- Sürüm: v0.3.6 (geliştirme).
- Durum geçişi düzenlemesi `main` dalında `f320603` üzerine hazırlandı.
- Güncel çalışma: uygulama başladığında yol haritasındaki aşama ve aktif plandaki üst adımlar ilerlemeyi gösteriyor.

## Son yapılan

- İlk alt adımın uygulaması başlayınca aşama `Devam ediyor` olur. Bir alt adımın uygulaması başlayınca `Planlandı` durumundaki üst satırları `Uygulanıyor` olur. Önceki ortak metnin LF hash’i `surum.json` listesine eklendi.
- Kısa plan satırı aynı etkin planda numaralı alt satırlara ayrılıyor. Planlama belgeleri kaydediyor. Açık uygulama komutu belirtilen satırı veya aralığı kapsıyor.
- Depo ajanı kullanıcıyla doğrudan çalışır. Kök `AGENTS.md` deponun geliştirme rehberidir. Kök `CLAUDE.md` aynı rehberi yükler.
- Yerel görev ve araştırma dosyaları `yerel-yedek/` içinde. İncelemeler, sürüm doğrulamaları ve geliştirme arşivi `yerel-yedek/docs/` altında.

## Doğrulama

- Windows PowerShell 5.1 ile 30 kurulum ve güncelleme senaryosu geçti. Başarısız veya atlanan senaryo yok.
- Önceki v0.3.6 paketiyle kurulan geçici projede, kurulum kaydındaki ortak metin hash alanı yokken güncelleme iki yeni kuralı kurdu. Dolu plan, yol haritası ve projeye özel kural korundu.
- Tam Git geçmişi ile bilinen ortak metin hash’leri eşleşti (EKSİK=0, FAZLA=0).
- Geçici projede plan kaydı ve yeniden planlama kod dosyalarını değiştirmedi. İlk alt adımın testi geçti, ikinci alt adım `Planlandı` kaldı.
- Ayrı geçici projede v0.3.5 → v0.3.6 geçişi doğrulandı. Dolu plan ve projeye özel bölüm korundu.

## Açık kalan / sınırlar

- Yeni durum geçişlerinin bir ajan oturumundaki uygulaması henüz denenmedi.
- Sohbetle sınırlı mod ve aralık yetkisi metin üzerinden kontrol edildi. Yeni bir Codex veya Claude oturumunda komut yorumlama denenmedi.

## Sonraki devam noktası

Yeni bir şablon fikri doğrudan bu depoda ele alınabilir. Önceki gönderimin CI sonucu için kullanıcının izni veya ileteceği sonuç bekleniyor.
