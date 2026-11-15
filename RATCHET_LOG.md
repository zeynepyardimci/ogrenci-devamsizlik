# RATCHET_LOG.md — A Koşusu Hata ve Kural Kaydı

Bu dosya, A koşusunda gözlemlenen **gerçek hataları** belgeler ve her hatayı
kalıcı bir kurala veya teste bağlar. Ratchet (Mandal) mekanizması bu hataların
bir daha yapılmasını engeller.

> **Tarih:** 15.11.2026  
> **Koşu:** A (ilk prototip, `evidence/a-run/devamsizlik.rb`)  
> **Durum:** Tüm A koşusu kanıtları `evidence/a-run/` klasöründe salt okunurdur.

---

## Hata Tablosu

| # | Karşılaşılan Gerçek Hata (A Koşusu) | Kalıcı Kural veya Test | Katman |
|---|--------------------------------------|------------------------|--------|
| 1 | `%30` sınırı `>` operatörüyle kontrol edildi; tam `30.0` değerinde olan Emre Şahin "normal" sayıldı, oysaki `>= 30` olmalıydı | `AGENTS.md §6` — oturum modeline geçildi; yüzde eşiği kaldırıldı. Test: `test_tam_uc_devamsizlik_risklidir` | Sensör |
| 2 | Devamsızlık 40 ders üzerinden yüzde olarak hesaplandı (`devamsiz_ders / toplam_ders * 100`); `0..10` tamsayı oturum modeli uygulanmadı | `AGENTS.md §2` — `devamsizlik` alanı `0..10 Integer` zorunlu. Test: `test_devamsizlik_sinir_sifir_gecerli`, `test_devamsizlik_on_bir_reddedilir` | Sensör |
| 3 | `Ogrenci` sınıfı bulunmadı; veriler Hash ile (`{ no:, ad:, toplam_ders:, devamsiz_ders: }`) temsil edildi | `AGENTS.md §2` — `Ogrenci` sınıfı zorunlu. Test: `test_ogrenci_olusturma` | Rehber |
| 4 | `DevamsizlikKontrol` sınıfı bulunmadı; iş mantığı serbest fonksiyonlarla (`def devamsizlik_hesapla`) yazıldı | `AGENTS.md §3` — `DevamsizlikKontrol` sınıfı zorunlu. Test: `test_dort_devamsizlik_kaldidir` | Rehber |
| 5 | `aktif?` / `mezun?` sorgu metotları mevcut değildi; `define_method` kullanılmadı | `AGENTS.md §2 Sorgu Metotları` — `define_method` zorunlu. Test: `test_aktif_define_method_ile_tanimli_kaynak_kontrolu`, `test_mezun_define_method_ile_tanimli_kaynak_kontrolu` | Sensör |
| 6 | `kaldi?` kuralı yoktu (`devamsizlik >= 4`) | `AGENTS.md §3` — `kaldi?` zorunlu. Test: `test_dort_devamsizlik_kaldidir`, `test_uc_devamsizlik_kaldi_degildir` | Sensör |
| 7 | Özgün kural `onur_adayi?` yoktu | `AGENTS.md §3` — `onur_adayi?` zorunlu. Test: `test_aktif_sifir_devamsizlik_onur_adayi` vb. | Sensör |
| 8 | Minitest test dosyası bulunmadı; kodun doğruluğu yalnızca terminal çıktısıyla değerlendirildi | `AGENTS.md §5` — Her public metot en az bir testle kapsanmalı. `test/ogrenci_test.rb` oluşturuldu | Rehber |

---

## Önleyici Kurallar (İhlal Edilmedi — Önlemek İçin Belgelendi)

Aşağıdaki sorunlar A koşusunda **gerçekleşmedi**, ancak ileriki koşularda
oluşabilecekleri için `AGENTS.md`'de yasaklanmıştır:

- **`method_missing` kullanımı** — A koşusunda başvurulmadı; B+ koşuları için yasaklandı.
- **Monkey patch / açık sınıf müdahalesi** — A koşusunda yapılmadı; B+ için yasaklandı.

---

## Ratchet Durumu

```
A Koşusu  → 8 yapısal sorun tespit edildi
Mandal    → Kurallar AGENTS.md'e yazıldı
           Testler test/ogrenci_test.rb'e yazıldı
           bin/kontrol ile otomatik doğrulama hazır
B Koşusu  → lib/ oluşturuldu; tüm testler yeşile döndü (47 runs, 68 assertions, 0 failures/errors/skips)
```
