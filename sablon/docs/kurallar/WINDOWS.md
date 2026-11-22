# Windows ve PowerShell

Bu dosya PowerShell komutu yazarken, `.ps1` dosyası oluştururken, dosya kodlaması ve satır sonu işi yaparken veya dosya okuyan/yazan kod yazarken okunur; yalnız ilgili bölüm yeterlidir.

## Kabuk

- Komut çalıştırmadan önce hangi kabukta olduğunu bil (Windows PowerShell 5.1, PowerShell 7, cmd, Git Bash).
- Windows PowerShell 5.1'de `&&` ve `||` yoktur; komutları ayrı çalıştır veya `komut1; if ($?) { komut2 }` kullan.
- Türkçe terminal çıktısı için `[Console]::OutputEncoding = [Text.Encoding]::UTF8`.

## Dosya kodlaması

- `.ps1` dosyaları UTF-8 BOM'lu kaydedilir; Windows PowerShell 5.1 BOM'suz betikteki Türkçe karakterleri yanlış okur.
- Markdown, JSON ve YAML dosyaları UTF-8 BOM'suz kaydedilir.
- Projenin `.gitattributes` dosyası Markdown satır sonunu belirlemiyorsa ve Git `core.autocrlf` açıksa LF ile yazılan belgelerde Git işlemleri "LF will be replaced by CRLF" uyarısı verir; `*.md text eol=lf` gibi bir kural öner. `.gitattributes` değişikliği kullanıcı onayıyla yapılır; var olan dosyaları yeniden normalleştirmek (`git add --renormalize`) ayrıca sorulur.
- Windows PowerShell 5.1'de `Set-Content` ve `Out-File` varsayılan olarak BOM'suz UTF-8 yazmaz; `-Encoding UTF8` de BOM ekler. BOM'suz dosya için `[IO.File]::WriteAllText($yol, $metin, (New-Object Text.UTF8Encoding($false)))` kullan.
- Kodda metin dosyası okurken ve yazarken kodlamayı açıkça ver (ör. UTF-8); ikili dosyada kodlama verilmez. Windows'ta dilin veya aracın varsayılan kodlaması UTF-8 olmayabilir; kod başka makinede farklı sonuç verir.
- Türkçe commit mesajı için `docs/kurallar/GIT.md` "Commit" bölümüne bak.
