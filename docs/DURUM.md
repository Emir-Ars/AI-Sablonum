# Durum

- Son güncelleme: 2026-11-24 13:52:32 +03:00
- Sürüm: v0.3.5 (geliştirme).
- Dal: main `558042a` (DURUM kaydı) push edildi; uzak kimlik aynı. CI yeşil: v0.3.5 `d88952a` [koşu 45375951329](https://github.com/Emir-Ars/AI-Sablonum/actions/runs/45375951329), v0.3.4 `6674fd4` [koşu 45009115147](https://github.com/Emir-Ars/AI-Sablonum/actions/runs/45009115147). `558042a` için koşu listede yok (neden doğrulanmadı). Bu güncelleme commit edilmedi.
- Güncel çalışma: [v0.3.5 sohbet planlama, kapsam, okuma rehberi, karar durumu, kapanış sonucu](DOGRULAMA_v0.3.5.md); altı değişiklik uygulandı. Aktif aşama yok.

## Son yapılan

- v0.3.5: "N'yi planla" ile isteğe bağlı sohbet planı; "uygula"nın kapsamı hemen önce planı sunulan adım (belirsizse tek kapsam sorusu); sohbet planı için ihtiyaç kadar kayıt; okuma rehberi başlangıç noktası; karar dizininde "Durum" ve "Tam metin" ayrımı; kapanış commit'inin sonucu yeni aktif `GUNLUK.md` dosyasında.
- v0.3.4'ün commit sonrası kayıtları v0.3.5 commit'ine dahil edildi.

## Doğrulama

- Yerel (Windows PowerShell 5.1): duman testi geçti=30, kaldı=0, atlandı=0; hash denetimi EKSİK=0, FAZLA=0; BOM/CRLF yok; `git diff --check` temiz.
- Güncelleme denemesi (geçici klasör): v0.3.4 kurulumu v0.3.5'e güncellendi; ortak kısım yenilendi, özel bölüm korundu.
- Yalnız metinle kontrol edildi (gerçek ajan oturumunda denenmedi): üç örnek davranış, rapordaki "Yalnız metin üzerinden kontrol edilen davranışlar".
- CI: v0.3.4 ve v0.3.5 yeşil (yukarıdaki bağlantılar). Bağımsız alt ajan incelemesi yapılmadı.

## Açık kalan / sınırlar

- Ortak kısım 14.044 karakter (v0.3.4: 12.798); kök `AGENTS.md` 15.069. Açık konular: [DOGRULAMA_v0.3.5.md](DOGRULAMA_v0.3.5.md#açık-konular).
- Yerel inceleme notu, kullanıcı notu ve görev dosyaları commit'e alınmaz.

## Sonraki devam noktası

Bekleyen iş yok. Gerçek projede ilk kullanımda v0.3.5 davranışları gözlenir. Bu not uygulama izni değildir.
