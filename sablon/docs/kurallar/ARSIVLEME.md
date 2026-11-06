# Aşama kapanışı ve arşivleme

Bu dosya bir aşama kapatılırken ve kapanmış bir aşamadaki hata düzeltilirken ("Kurallar" bölümü) okunur. Amaç: sonraki aşamada ajanın eski aşamanın yazılarını okumaması, ama sonraki aşamaları etkileyen hiçbir bilginin kaybolmaması.

## Ne zaman

- Aşamanın bütün alt adımları "Doğrulandı" durumunda,
- `PLAN.md` içindeki aşama kapanış ölçütleri karşılanmış,
- kullanıcı açıkça "aşamayı kapat" demiş.

Bunlardan biri eksikse kapatma; eksik olanı kullanıcıya söyle.

## Yetki

Kullanıcının "aşamayı kapat" veya "arşivle" demesi şu işleri kapsar; her biri için ayrıca onay istenmez:

- Zaten verilmiş kararları ve belgelerden kesin olan bilgiyi ilgili aktif belgeye aktarmak (numaralar değişmez).
- Kapanış özetini yazmak, aşama klasörünü taşımak, bağlantıları düzeltmek, boş aşama klasörünü açmak, yol haritası ve `DURUM.md` satırlarını güncellemek.
- Dizinde "Yerine geçildi" olan kararların tam metnini `docs/arsiv/KARARLAR_ESKI.md` dosyasına taşımak.

Şunlar için kullanıcıya sorulur: yeni karar vermek veya bekleyen kararı ertelemek; kararın kapsamını kayıtta dayanağı olmadan "Proje geneli" yapmak; aşama kuralını proje geneline yaymak; emin olunmayan bilgiyi silmek veya taşımak; var olan arşiv klasörünün üzerine yazmak; "öner" denen düzenlemeler; sonraki aşamaya başlamak. Arşivleme yetkisi genel silme yetkisi değildir. Commit ve push ayrı onay ister.

## Adımlar

1. **Kapanış kontrolü.** `docs/PROJE.md` "Test komutları" bölümü boşsa `docs/kurallar/PLANLAMA.md` "Test komutu" bölümündeki keşif sırasını uygula; komut yine belirlenemezse dur, kullanıcıya sor ve onaylanan komutu önce oraya yaz; komut uydurma. Sonra `docs/PROJE.md` içindeki bütün testleri çalıştır, kapanış ölçütlerini tek tek kontrol et. Sonucu aşamanın `GUNLUK.md` dosyasına yaz. Başarısız test varsa dur.

2. **Kalıcı bilgiyi ayıkla.** Aşama klasöründeki her şeyi şu soruyla gözden geçir: "Sonraki aşamalarda buna ihtiyaç olacak mı?"

   | Aşama klasöründe bulunan | Sonraki aşamaları etkiliyorsa nereye |
   |---|---|
   | Karar (`aktif-asama/KARARLAR.md`) | Tam metni `aktif-asama/KARARLAR.md` içinden **keserek** `docs/KARARLAR.md` dosyasına taşı (numara değişmez); aşama dosyasında yalnız "K-003 — tam metni docs/KARARLAR.md içine taşındı" satırı kalır (aynı bilgi iki yerde durmaz); dizinde kapsamı "Proje geneli" yap. Etkilemiyorsa arşivde kalır; dizinde durumu "Arşivde" olur ve arşiv bağlantısı eklenir |
   | Tasarım (`TASARIM.md`) | Sonraki aşamaları etkileyen sözleşme, yapı veya komut bilgisini `docs/PROJE.md` dosyasına işle; geri kalanı arşivde kalır |
   | Kod yapısı, komut, veri biçimi, arayüz bilgisi | `docs/PROJE.md` güncel mi kontrol et, eksikse ekle |
   | Açık kalan iş veya bilinen sınır | `docs/ACIK_KONULAR.md` (bilinen sınır, devreden not) veya `docs/YOL_HARITASI.md` ilgili aşama satırı |
   | Aşama kuralı (PLAN.md "Aşama kuralları") | Bütün projede geçerli olacaksa `AGENTS.md` "Projeye özel kurallar" |
   | Araştırma belgesi | İleride de kullanılacaksa `docs/arastirma/` altına taşı |

   Emin olmadığın her maddeyi kullanıcıya liste hâlinde sor. Kayıtta dayanağı olmayan kapsam değişikliği ve aşama kuralının proje geneline taşınması kullanıcıya sorulmadan yapılmaz.

3. **Ana belgelerde birikmeyi temizle.** Aşama klasörü dışındaki kalıcı belgeler proje boyunca büyümesin diye:
   - `docs/KARARLAR.md`: tamamen yerine geçilmiş kararların tam metnini `docs/arsiv/KARARLAR_ESKI.md` dosyasına taşı (dosya yoksa `# Yerine geçilmiş kararlar (arşiv)` başlığıyla aç; kayıtlar aynen ve tarih sırasıyla sona eklenir). Dizinde satırı kalır ("Yerine geçildi: K-xxx", arşiv bağlantısıyla); böylece K-numarasına verilen bağlantılar kırılmaz. Aktif dosyada yalnız yürürlükteki kararların tam metni kalır.
   - `docs/ACIK_KONULAR.md`: bu aşamada kapanması gereken "En geç" satırları karara bağlandı mı? Bağlanmamışsa kullanıcıya sor; kullanıcı ertelerse "En geç" sütununu yeni aşamaya güncelle ve erteleme nedenini satıra tek cümleyle ekle. Yeni aşamayı ilgilendiren devreden notların başına `[Aşama N]` yaz. Giderilmiş bilinen sınır satırlarını sil ve nedenini günlüğe yaz.
   - `docs/DURUM.md` "Devreden işler": her iş ya `YOL_HARITASI.md` ilgili aşama satırına ya `ACIK_KONULAR.md` dosyasına bağlanır; sahipsiz iş bırakılmaz, bağlanamayanı kullanıcıya sor.
   - `docs/PROJE.md`: kodun şu anki hâliyle karşılaştır; eskimiş bilgiyi sil, yaklaşık 150 satırı geçiyorsa sadeleştirme öner.
   - `AGENTS.md` ve `docs/kurallar/proje-*.md`: tekrar veya çelişki varsa, `AGENTS.md` yaklaşık 20 bin karakteri ya da bir `proje-*.md` dosyası yaklaşık 10 bin karakteri geçtiyse düzenleme (bölme, birleştirme) öner.
   - `docs/arastirma/`: artık hiçbir kalan aşamayı ilgilendirmeyen genel araştırma belgesini `docs/arsiv/00-hazirlik/` altına taşımayı öner.

   Bu adımda yalnız durumu belgelerden kesin olan bilgi taşınır veya silinir (ör. dizinde yerine geçildiği yazılı karar, doğrulanarak giderilmiş sınır). Emin olunmayan her madde ve "öner" denen her düzenleme kullanıcıya sorulur.

4. **Özet yaz.** `docs/aktif-asama/OZET.md` dosyasını oluştur (en fazla 15 satır): aşamanın amacı, yapılan alt adımlar, proje geneline taşınan kararlar, devreden işler, kapanış testi sonucu.

5. **Klasörü taşı.** `docs/aktif-asama/` klasörünü bütünüyle `docs/arsiv/NN-kisa-ad/` olarak taşı. `NN` aşama numarasıdır, iki hanelidir (`01`, `02`…); kısa ad yol haritasındaki aşama adından türetilir. Git deposu varsa `git mv` kullan. Hedef klasör zaten varsa dur ve kullanıcıya sor; üzerine yazma.

6. **Boş aşama klasörü aç.** `docs/kurallar/sablonlar/` içindeki `PLAN.md`, `TASARIM.md`, `KARARLAR.md` ve `GUNLUK.md` dosyalarını yeni `docs/aktif-asama/` klasörüne kopyala; `arastirma-BENIOKU.md` dosyasını `docs/aktif-asama/arastirma/BENIOKU.md` olarak kopyala (Git boş klasör izlemez; bu dosya klasörü korur).

7. **Bağlantıları düzelt ve tara.** Projede `aktif-asama/` geçen bağlantıları ara; artık arşive giden bilgiyi gösterenleri yeni `docs/arsiv/NN-kisa-ad/` yoluna çevir. Bu, adım 2'de aktif belgelere taşınan metinlerdeki bağlantıları da kapsar (ör. taşınan kararın `aktif-asama/TASARIM.md` bağlantısı). Arşivlenen `PLAN.md` "İlgili kaynaklar" sütunundaki bağlantılar da aşağıdaki kuralla düzeltilir. Ardından arşive taşınan klasördeki bütün yerel bağlantıları tara: klasör bir seviye derine indiği için klasör dışını gösteren `../` bağlantıları bozulur: her bağlantının hedefine bak, klasör dışındaysa bir `../` ekle, hedef taşınan klasörün kendi içindeyse yolu yeni konuma göre çöz; yalnız bağlantı yolunu düzelt, metni değiştirme. Tarama sonucunu (kırık bağlantı sayısı) günlüğe yaz.

8. **Ana belgeleri güncelle.**
   - `docs/YOL_HARITASI.md`: aşama satırı "Tamamlandı", arşiv sütununa `arsiv/NN-kisa-ad/OZET.md` bağlantısı.
   - `docs/DURUM.md`: baştan yaz. "Aktif aşama" alanına "Yok (Aşama N kapandı)", "Güncel alt adım" alanına "Yok", "Son yapılan" bölümüne aşama özetinin bağlantısını, "Sonraki devam noktası" bölümüne "Sıradaki aşama için araştırma belgeleri ve kullanıcı seçimi bekleniyor." yaz.

9. **Commit öner.** Değişen ve taşınan dosyaların listesini ve Türkçe commit mesajını öner; onay gelince commit et.

## Hazırlık belgeleri

Yol haritası kabul edildikten sonra kullanıcı isterse yalnız yol haritası hazırlığına ait belgeler (artık gerekmeyen ilk araştırma notları gibi) `docs/arsiv/00-hazirlik/` altına taşınabilir. Yol haritası ve proje geneli kararlar taşınmaz.

## Kurallar

- Arşive taşınan dosyaların içeriği değiştirilmez; yalnız göreli bağlantılar düzeltilebilir. Bu düzeltmeyi kapanışı yapan ajan adım 7'de yapar. Eski arşivler sırf yeni belge biçimine uydurmak için yeniden yazılmaz.
- Arşivdeki bir karar sonradan değişirse arşiv metni değiştirilmez: yeni K-numarası açılır, "Önceki karar" alanı ve `docs/KARARLAR.md` dizini ilişkiyi gösterir. Arşive taşınan kararların dizin satırı ve arşiv bağlantısı kalır.
- Alt adım ve karar numaraları tekrar kullanılmaz. Karar numaraları bütün proje boyunca artar (`K-001`, `K-002` …); alt adım numaraları aşama numarasıyla başlar (`2.1`). Projede daha önce başka bir arşiv klasör adı kullanılmışsa (ör. `faz-01`) yeni arşiv de o adlandırmaya uyar.
- Kapanmış bir aşamada sonradan hata çıkarsa arşiv değiştirilmez. Düzeltme aktif aşamada yeni bir alt adım olarak yapılır (ör. `3.7 — 1.4'teki tarih hatasının düzeltilmesi`) ve gerekçesi aktif aşamanın `GUNLUK.md` dosyasına yazılır (kapanmış aşamanın arşivdeki günlüğü değiştirilmez). Yeni aşama henüz seçilmediyse (aktif `PLAN.md` boştur) kapanmış aşamanın numarasıyla devam eden alt adım açılır (ör. aşama 1 kapandıysa `1.11`); bu satır yeni aşama seçilince de `PLAN.md` içinde kalır.
- Taşıma yarıda kalırsa (ör. hata nedeniyle) yeniden denemeden önce `docs/aktif-asama/` ve hedef arşiv klasörünü karşılaştır; kopya kayıt veya kayıp varsa kullanıcıya bildir.
- Arşivleme sonraki aşamayı planlama veya uygulama izni değildir.
