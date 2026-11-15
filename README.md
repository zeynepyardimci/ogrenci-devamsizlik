# Öğrenci Devamsızlık Sistemi

Ruby 3.4 ile yazılmış, nesne yönelimli öğrenci devamsızlık kontrol sistemi.
Ratchet (Mandal) yöntemiyle iteratif olarak geliştirilmektedir.

---

## Proje Durumu

| Koşu | Tarih | Durum |
|------|-------|-------|
| **A Koşusu** | 15.11.2026 | ✅ Tamamlandı — kanıtlar `evidence/a-run/`'da |
| **B Koşusu** | 15.11.2026 | ✅ Tamamlandı — kanıtlar `evidence/b-run/`'da |

---

## A/B Koşusu ve Ölçüm Raporu

### 1. Test ve Kod Kalitesi Ölçümleri

| Ölçüm Alanı | A Koşusu Değeri | B Koşusu Değeri |
|---|---|---|
| **Ruby Sürümü** | 3.4.7 (2025-10-08) | 3.4.7 (2025-10-08) |
| **Öğrenci Sınıfı (`Ogrenci`)** | ❌ Yok (Hash yapısı) | ✅ Mevcut (`lib/ogrenci.rb`) |
| **`ad` Alanı Tür Doğrulaması** | ❌ Yok | ✅ String doğrulaması (`ArgumentError`) |
| **`DevamsizlikKontrol` Sınıfı** | ❌ Yok (Düz fonksiyon) | ✅ Mevcut (`lib/devamsizlik_kontrol.rb`) |
| **`define_method` Kullanımı** | ❌ Yok | ✅ `aktif?` ve `mezun?` define_method ile tanımlı |
| **Devamsızlık Modeli** | ❌ 40 ders / serbest yüzde | ✅ 0..10 Integer oturum modeli |
| **`kaldi?` Kuralı** | ❌ Yok | ✅ Mevcut (`devamsizlik >= 4`) |
| **`onur_adayi?` Kuralı** | ❌ Yok | ✅ Mevcut (`aktif? && devamsizlik <= 1`) |
| **Test Runs** | Uygulanmadı (Minitest test altyapısı yoktu) | 47 runs |
| **Assertions** | Uygulanmadı (Minitest test altyapısı yoktu) | 68 assertions |
| **Failures** | Uygulanmadı (Minitest test altyapısı yoktu) | 0 failures |
| **Errors** | Uygulanmadı (Minitest test altyapısı yoktu) | 0 errors |
| **Skips** | Uygulanmadı (Minitest test altyapısı yoktu) | 0 skips |
| **`bin/kontrol` Çıkış Kodu** | ❌ Mevcut değil | 0 (Başarılı) |
| **Doğrulama Sonucu** | ❌ Harness yok | ✅ TÜM KONTROLLER BAŞARILI |

### 2. Koşu ve Süreç Metrikleri

| Metrik | A Koşusu | B Koşusu | Doğrulama Notu |
|---|---|---|---|
| **Kullanıcı Prompt Sayısı (Doğrudan Görev)** | 1 prompt (Prompt #1) | 1 prompt (Prompt #6) | Sohbet geçmişindeki `USER_INPUT` kayıtlarından doğrulandı |
| **Etkileşimli Ara Turlar (Interactive Turns)** | 2 soru-cevap ara adımı | 0 (Doğrudan yürütüldü) | A koşusunda veri formatı ve çıktı türü soru-cevap ile netleştirildi |
| **Mandal/Harness Hazırlık Turları** | — | 4 prompt (Prompt #2, #3, #4, #5) | B koşusu öncesi AGENTS.md, testler ve kontrol harness'ı hazırlandı |
| **Teslimat ve Kalite Kontrol Turları** | — | 2 prompt (Prompt #7, #8) | ad tür doğrulaması, ANSI temizliği ve teslimat düzenlemeleri |
| **Token Kullanımı** | Ölçülmedi | Ölçülmedi | Oturum bazlı harici token sayacı takip edilmedi |
| **Maliyet Bilgisi** | Ölçülmedi | Ölçülmedi | Oturum bazlı harici faturalandırma metriği takip edilmedi |

---

## A Koşusunda Tespit Edilen Sorunlar

Ayrıntılar için → [`RATCHET_LOG.md`](RATCHET_LOG.md)

1. `%30` eşiği `>` ile kontrol edildi (tam 30'da olan Emre Şahin yanlış sınıflandırıldı)
2. Devamsızlık 40 ders yüzdesiyle modellendi; `0..10` oturum modeli yoktu
3. `Ogrenci` sınıfı yoktu
4. `DevamsizlikKontrol` sınıfı yoktu
5. `define_method` ile `aktif?` / `mezun?` oluşturulmadı
6. `kaldi?` kuralı yoktu
7. `onur_adayi?` kuralı yoktu
8. Minitest testleri yoktu

---

## Proje Yapısı

```
ogrenci-devamsizlik/
├── .github/
│   └── workflows/
│       └── ci.yml               # GitHub Actions CI iş akışı (Ruby 3.4)
├── .gitignore                   # Git hariç tutma kuralları (.ruby-lsp, .bundle vb.)
├── .ruby-version                 # 3.4
├── AGENTS.md                     # Bağlayıcı kurallar
├── CLAUDE.md                     # → AGENTS.md (SymbolicLink)
├── README.md                     # Bu dosya
├── RATCHET_LOG.md                # A koşusu hata ve kural kaydı
├── bin/
│   ├── kontrol                   # Doğrulama betiği (ruby bin/kontrol)
│   └── izle.rb                  # Dosya değişiklik izleyici
├── evidence/
│   ├── a-run/                   # Salt okunur — A koşusu kanıtları
│   │   ├── devamsizlik.rb
│   │   ├── output.txt
│   │   └── ruby-version.txt
│   └── b-run/                   # B koşusu kanıtları
│       ├── output.txt
│       └── ruby-version.txt
├── lib/
│   ├── ogrenci.rb
│   └── devamsizlik_kontrol.rb
└── test/
    └── ogrenci_test.rb          # Minitest test paketi (47 test)
```

---

## Kurulum ve Çalıştırma

```powershell
# Doğrulama betiğini çalıştır
ruby bin/kontrol

# Testleri doğrudan çalıştır
ruby -Ilib test/ogrenci_test.rb

# Dosya değişiklik izleyiciyi başlat
ruby bin/izle.rb
```

---

## Yapamadıklarım

Aşağıdaki iş veya sınırlama devam etmektedir:

- **Kaydetme tetikleyicisi (on-save hook) bağlanamadı** — Antigravity IDE,
  "dosya kaydet" olayını Skills/Rules sistemi üzerinden doğrudan tetikleyici
  olarak sunmamaktadır. Alternatif olarak `bin/izle.rb` oluşturuldu
  (polling tabanlı, standart Ruby kütüphanesiyle çalışır).

---

## Kurallar

Tüm bağlayıcı kurallar için → [`AGENTS.md`](AGENTS.md)
