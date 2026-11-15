# AGENTS.md — Öğrenci Devamsızlık Sistemi: Bağlayıcı Kurallar

Bu dosya, bu projede çalışan tüm yapay zekâ ajanları için zorunlu ve bağlayıcı
kurallardır. Hiçbir ajan bu kurallara aykırı davranamaz; aykırı üretilen kod
geçersizdir.

---

## 1. Ruby Sürümü

- Ruby sürümü **3.4** olmalıdır.
- `.ruby-version` dosyasının içeriği tam olarak `3.4` olmalıdır.

---

## 2. `Ogrenci` Sınıfı

- Sınıfın adı **`Ogrenci`** olmalıdır (Türkçe, ASCII uyumlu).
- Aşağıdaki alanlar bulunmalıdır:
  - `ad`          — String, öğrencinin adı
  - `durum`       — Symbol, yalnızca `:aktif`, `:donduruldu` veya `:mezun`
  - `devamsizlik` — Integer, `0..10` aralığında (sınırlar dahil)
- `durum` alanı yalnızca `:aktif`, `:donduruldu`, `:mezun` değerlerini kabul
  etmelidir; geçersiz değer `ArgumentError` yükseltmelidir.
- `devamsizlik` alanı `0..10` aralığı dışında bir değer aldığında
  `ArgumentError` yükseltmelidir.

### Sorgu Metotları

- `aktif?` ve `mezun?` metotları **kesinlikle `define_method`** ile
  oluşturulmalıdır.
- `define_method` kullanımı test tarafından doğrudan denetlenir;
  `def aktif?` veya `def mezun?` sözdizimi kullanılmamalıdır.
- **`method_missing` kesinlikle kullanılmamalıdır.**

---

## 3. `DevamsizlikKontrol` Sınıfı

- Sınıfın adı **`DevamsizlikKontrol`** olmalıdır.
- Kurallar:
  | Metot         | Koşul                          | Açıklama                      |
  |---------------|--------------------------------|-------------------------------|
  | `riskli?`     | `devamsizlik >= 3`             | Tam 3 devamsızlık risklidir   |
  | `kaldi?`      | `devamsizlik >= 4`             | Tam 3 devamsızlık kaldı değil |
  | `onur_adayi?` | `aktif? && devamsizlik <= 1`   | Özgün kural                   |

---

## 4. Yasak Örüntüler

- **`method_missing`** hiçbir sınıfta kullanılmamalıdır.
- **Monkey patch / açık sınıf müdahalesi** yapılmamalıdır:
  `String`, `Integer`, `Array`, `Hash` vb. standart Ruby sınıfları
  `class String ... end` bloğuyla genişletilemez.
- **Harici büyük gem** (Rails, ActiveSupport, dry-rb, vb.) kullanılmamalıdır.
  Yalnızca Ruby 3.4 standart kütüphanesi ve Minitest kullanılabilir.

---

## 5. Kod Kalitesi

- Kod okunabilir, nesne yönelimli ve test edilebilir olmalıdır.
- Her public metot en az bir Minitest testiyle kapsanmalıdır.
- `lib/ogrenci.rb` ve `lib/devamsizlik_kontrol.rb` dosyaları ayrı tutulmalıdır.
- `test/ogrenci_test.rb` dosyası tüm kuralları denetlemelidir.

---

## 6. Devamsızlık Modeli

- Devamsızlık birimi **oturum** (0–10 tam sayı) olarak modellenmelidir.
- Yüzde hesabı değil, oturum sayısı üzerinden çalışılmalıdır.
- A koşusundaki 40 ders / yüzde modeli bu projede geçerli **değildir**.
