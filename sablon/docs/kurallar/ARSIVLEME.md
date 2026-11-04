# Aşama kapanışı ve arşivleme

Bu dosya yalnız bir aşama kapatılırken okunur. Amaç: sonraki aşamada ajanın eski aşamanın yazılarını okumaması, ama sonraki aşamaları etkileyen hiçbir bilginin kaybolmaması.

## Ne zaman

- Aşamanın bütün alt adımları "Doğrulandı" durumunda,
- `PLAN.md` içindeki aşama kapanış ölçütleri karşılanmış,
- kullanıcı açıkça "aşamayı kapat" demiş.

Bunlardan biri eksikse kapatma; eksik olanı kullanıcıya söyle.

## Adımlar

1. **Kapanış kontrolü.** `docs/PROJE.md` içindeki bütün testleri çalıştır, kapanış ölçütlerini tek tek kontrol et. Sonucu aşamanın `GUNLUK.md` dosyasına yaz. Başarısız test varsa dur.

2. **Kalıcı bilgiyi ayıkla.** Aşama klasöründeki her şeyi şu soruyla gözden geçir: "Sonraki aşamalarda buna ihtiyaç olacak mı?"

   | Aşama klasöründe bulunan | Sonraki aşamaları etkiliyorsa nereye |
   |---|---|
   | Karar (`aktif-asama/KARARLAR.md`) | Tam metnini `docs/KARARLAR.md` dosyasına taşı (numara değişmez); dizinde kapsamı "Proje geneli" yap. Etkilemiyorsa arşivde kalır; dizinde durumu "Arşivde" olur ve arşiv bağlantısı eklenir |
   | Tasarım (`TASARIM.md`) | Sonraki aşamaları etkileyen sözleşme, yapı veya komut bilgisini `docs/PROJE.md` dosyasına işle; geri kalanı arşivde kalır |
   | Kod yapısı, komut, veri biçimi, arayüz bilgisi | `docs/PROJE.md` güncel mi kontrol et, eksikse ekle |
   | Açık kalan iş veya bilinen sınır | `docs/ACIK_KONULAR.md` (bilinen sınır, devreden not) veya `docs/YOL_HARITASI.md` ilgili aşama satırı |
   | Aşama kuralı (PLAN.md "Aşama kuralları") | Bütün projede geçerli olacaksa `AGENTS.md` "Projeye özel kurallar" |
   | Araştırma belgesi | İleride de kullanılacaksa `docs/arastirma/` altına taşı |

   Emin olmadığın her maddeyi kullanıcıya liste hâlinde sor. Kullanıcıya sorulmadan bir karar veya kural proje geneline taşınmaz.

3. **Ana belgelerde birikmeyi temizle.** Aşama klasörü dışındaki kalıcı belgeler proje boyunca büyümesin diye:
   - `docs/KARARLAR.md`: tamamen yerine geçilmiş kararların tam metnini `docs/arsiv/KARARLAR_ESKI.md` dosyasına taşı. Dizinde satırı kalır ("Yerine geçildi: K-xxx", arşiv bağlantısıyla); böylece K-numarasına verilen bağlantılar kırılmaz. Aktif dosyada yalnız yürürlükteki kararların tam metni kalır.
   - `docs/ACIK_KONULAR.md`: bu aşamada kapanması gereken "En geç" satırları karara bağlandı mı? Bağlanmamışsa kullanıcıya sor. Yeni aşamayı ilgilendiren devreden notları işaretle.
   - `docs/DURUM.md` "Devreden işler": her iş ya `YOL_HARITASI.md` ilgili aşama satırına ya `ACIK_KONULAR.md` dosyasına bağlanır; sahipsiz iş bırakılmaz, bağlanamayanı kullanıcıya sor.
   - `docs/PROJE.md`: kodun şu anki hâliyle karşılaştır; eskimiş bilgiyi sil, yaklaşık 150 satırı geçiyorsa sadeleştirme öner.
   - `AGENTS.md` "Projeye özel kurallar" ve `docs/kurallar/proje-*.md`: tekrar veya çelişki varsa ya da toplam yaklaşık 15 bin karakteri geçtiyse düzenleme öner.
   - `docs/arastirma/`: artık hiçbir kalan aşamayı ilgilendirmeyen genel araştırma belgesini `docs/arsiv/00-hazirlik/` altına taşımayı öner.

   Bu maddelerdeki taşıma ve silmeler kullanıcı onayıyla yapılır.

4. **Özet yaz.** `docs/aktif-asama/OZET.md` dosyasını oluştur (en fazla 15 satır): aşamanın amacı, yapılan alt adımlar, proje geneline taşınan kararlar, devreden işler, kapanış testi sonucu.

5. **Klasörü taşı.** `docs/aktif-asama/` klasörünü bütünüyle `docs/arsiv/NN-kisa-ad/` olarak taşı. `NN` aşama numarasıdır, iki hanelidir (`01`, `02`…); kısa ad yol haritasındaki aşama adından türetilir. Git deposu varsa `git mv` kullan. Hedef klasör zaten varsa dur ve kullanıcıya sor; üzerine yazma.

6. **Boş aşama klasörü aç.** `docs/kurallar/sablonlar/` içindeki `PLAN.md`, `TASARIM.md`, `KARARLAR.md` ve `GUNLUK.md` dosyalarını yeni `docs/aktif-asama/` klasörüne kopyala; boş bir `docs/aktif-asama/arastirma/` klasörü oluştur.

7. **Bağlantıları düzelt.** Projede `aktif-asama/` geçen bağlantıları ara. Artık arşive giden bilgiyi gösterenleri yeni `docs/arsiv/NN-kisa-ad/` yoluna çevir.

8. **Ana belgeleri güncelle.**
   - `docs/YOL_HARITASI.md`: aşama satırı "Tamamlandı", arşiv sütununa `arsiv/NN-kisa-ad/OZET.md` bağlantısı.
   - `docs/DURUM.md`: baştan yaz. "Aşama N kapandı; sıradaki aşama için araştırma belgeleri ve kullanıcı seçimi bekleniyor."

9. **Commit öner.** Değişen ve taşınan dosyaların listesini ve Türkçe commit mesajını öner; onay gelince commit et.

## Hazırlık belgeleri

Yol haritası kabul edildikten sonra kullanıcı isterse yalnız yol haritası hazırlığına ait belgeler (artık gerekmeyen ilk araştırma notları gibi) `docs/arsiv/00-hazirlik/` altına taşınabilir. Yol haritası ve proje geneli kararlar taşınmaz.

## Kurallar

- Arşive taşınan dosyaların içeriği değiştirilmez; yalnız göreli bağlantılar düzeltilebilir.
- Alt adım ve karar numaraları tekrar kullanılmaz. Karar numaraları bütün proje boyunca artar (`K-001`, `K-002` …); alt adım numaraları aşama numarasıyla başlar (`2.1`). Projede daha önce başka bir arşiv klasör adı kullanılmışsa (ör. `faz-01`) yeni arşiv de o adlandırmaya uyar.
- Kapanmış bir aşamada sonradan hata çıkarsa arşiv değiştirilmez. Düzeltme aktif aşamada yeni bir alt adım olarak yapılır (ör. `3.7 — 1.4'teki tarih hatasının düzeltilmesi`) ve gerekçesi o aşamanın günlüğüne yazılır.
- Taşıma yarıda kalırsa (ör. hata nedeniyle) yeniden denemeden önce `docs/aktif-asama/` ve hedef arşiv klasörünü karşılaştır; kopya kayıt veya kayıp varsa kullanıcıya bildir.
- Arşivleme sonraki aşamayı planlama veya uygulama izni değildir.
