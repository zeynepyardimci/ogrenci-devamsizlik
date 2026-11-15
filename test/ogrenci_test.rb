# frozen_string_literal: true

# test/ogrenci_test.rb
# Minitest test paketi.
#
# TASARIM KARARI:
#   lib/ dosyaları mevcut değilse testler skip ya da başarılı gösterilmez.
#   require_relative doğrudan yüklenir; LoadError olursa test süiti
#   kendi hatasıyla ölür — bu BEKLENEN ve DOĞRU davranıştır.
#   B koşusunda lib/ tamamlandığında bütün testler gerçekten çalışır.

require "minitest/autorun"
require_relative "../lib/ogrenci"
require_relative "../lib/devamsizlik_kontrol"

# ===========================================================================
# Yardımcı: kaynak kodu oku (define_method / method_missing denetimi için)
# ===========================================================================
OGRENCI_SRC              = File.read(File.expand_path("../lib/ogrenci.rb",             __dir__))
DEVAMSIZLIK_KONTROL_SRC  = File.read(File.expand_path("../lib/devamsizlik_kontrol.rb", __dir__))

# ===========================================================================
# Ogrenci Sınıfı Testleri
# ===========================================================================
class OgrenciTest < Minitest::Test

  # ── Temel oluşturma ──────────────────────────────────────────────────────

  def test_ogrenci_olusturma
    o = Ogrenci.new(ad: "Ayse", durum: :aktif, devamsizlik: 2)
    assert_equal "Ayse", o.ad
    assert_equal :aktif, o.durum
    assert_equal 2,      o.devamsizlik
  end

  # ── Ad alanı tür kontrolleri ─────────────────────────────────────────────

  def test_ad_string_olmak_zorunda_nil_reddedilir
    assert_raises(ArgumentError) { Ogrenci.new(ad: nil, durum: :aktif, devamsizlik: 0) }
  end

  def test_ad_string_disindaki_turler_reddedilir
    assert_raises(ArgumentError) { Ogrenci.new(ad: 12345, durum: :aktif, devamsizlik: 0) }
    assert_raises(ArgumentError) { Ogrenci.new(ad: :ayse, durum: :aktif, devamsizlik: 0) }
  end

  # ── Geçerli durumlar ─────────────────────────────────────────────────────

  def test_gecerli_durum_aktif
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 0)
    assert_equal :aktif, o.durum
  end

  def test_gecerli_durum_donduruldu
    o = Ogrenci.new(ad: "X", durum: :donduruldu, devamsizlik: 0)
    assert_equal :donduruldu, o.durum
  end

  def test_gecerli_durum_mezun
    o = Ogrenci.new(ad: "X", durum: :mezun, devamsizlik: 0)
    assert_equal :mezun, o.durum
  end

  # ── Geçersiz durum reddedilmeli ──────────────────────────────────────────

  def test_gecersiz_durum_symbol_reddedilir
    assert_raises(ArgumentError) { Ogrenci.new(ad: "X", durum: :bilinmeyen, devamsizlik: 0) }
  end

  def test_gecersiz_durum_string_reddedilir
    assert_raises(ArgumentError) { Ogrenci.new(ad: "X", durum: "aktif", devamsizlik: 0) }
  end

  def test_gecersiz_durum_nil_reddedilir
    assert_raises(ArgumentError) { Ogrenci.new(ad: "X", durum: nil, devamsizlik: 0) }
  end

  # ── Devamsızlık tür kontrolü ─────────────────────────────────────────────

  def test_devamsizlik_integer_olmak_zorunda
    # Float Integer değildir
    assert_raises(ArgumentError) { Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 2.5) }
  end

  def test_devamsizlik_string_reddedilir
    assert_raises(ArgumentError) { Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: "3") }
  end

  def test_devamsizlik_nil_reddedilir
    assert_raises(ArgumentError) { Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: nil) }
  end

  # ── Devamsızlık sınır değerleri (dahil) ──────────────────────────────────

  def test_devamsizlik_sinir_sifir_gecerli
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 0)
    assert_equal 0, o.devamsizlik
  end

  def test_devamsizlik_sinir_on_gecerli
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 10)
    assert_equal 10, o.devamsizlik
  end

  def test_devamsizlik_negatif_reddedilir
    assert_raises(ArgumentError) { Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: -1) }
  end

  def test_devamsizlik_on_bir_reddedilir
    assert_raises(ArgumentError) { Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 11) }
  end

  # ── aktif? metodu ────────────────────────────────────────────────────────

  def test_aktif_sorgusu_aktif_icin_dogru
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 0)
    assert_equal true, o.aktif?
  end

  def test_aktif_sorgusu_donduruldu_icin_yanlis
    o = Ogrenci.new(ad: "X", durum: :donduruldu, devamsizlik: 0)
    assert_equal false, o.aktif?
  end

  def test_aktif_sorgusu_mezun_icin_yanlis
    o = Ogrenci.new(ad: "X", durum: :mezun, devamsizlik: 0)
    assert_equal false, o.aktif?
  end

  # ── mezun? metodu ────────────────────────────────────────────────────────

  def test_mezun_sorgusu_mezun_icin_dogru
    o = Ogrenci.new(ad: "X", durum: :mezun, devamsizlik: 0)
    assert_equal true, o.mezun?
  end

  def test_mezun_sorgusu_aktif_icin_yanlis
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 0)
    assert_equal false, o.mezun?
  end

  def test_mezun_sorgusu_donduruldu_icin_yanlis
    o = Ogrenci.new(ad: "X", durum: :donduruldu, devamsizlik: 0)
    assert_equal false, o.mezun?
  end

  # ── define_method pozitif kontrolü ───────────────────────────────────────
  # Kaynak kodda "define_method :aktif?" ve "define_method :mezun?"
  # ifadelerinin gerçekten bulunduğunu denetler.
  # "def aktif?" / "def mezun?" sözdizimi olmamalıdır.

  def test_aktif_define_method_ile_tanimli_kaynak_kontrolu
    assert_match(/define_method\s*[(:]\s*:?aktif\?/, OGRENCI_SRC,
      "Kaynak kodda 'define_method :aktif?' bulunamadi — def aktif? kullanilamaz")
  end

  def test_mezun_define_method_ile_tanimli_kaynak_kontrolu
    assert_match(/define_method\s*[(:]\s*:?mezun\?/, OGRENCI_SRC,
      "Kaynak kodda 'define_method :mezun?' bulunamadi — def mezun? kullanilamaz")
  end

  def test_aktif_def_sozdizimi_kullanilmamis
    refute_match(/^\s*def aktif\?/, OGRENCI_SRC,
      "Kaynak kodda 'def aktif?' bulundu — define_method kullanilmali")
  end

  def test_mezun_def_sozdizimi_kullanilmamis
    refute_match(/^\s*def mezun\?/, OGRENCI_SRC,
      "Kaynak kodda 'def mezun?' bulundu — define_method kullanilmali")
  end

  # ── method_missing yasağı — kaynak kodu ve davranış ──────────────────────

  def test_method_missing_kaynak_kodda_yok_ogrenci
    refute_match(/method_missing/, OGRENCI_SRC,
      "Ogrenci kaynaginda 'method_missing' bulundu — kullanim yasaktir")
  end

  def test_method_missing_kaynak_kodda_yok_devamsizlik_kontrol
    refute_match(/method_missing/, DEVAMSIZLIK_KONTROL_SRC,
      "DevamsizlikKontrol kaynaginda 'method_missing' bulundu — kullanim yasaktir")
  end

  def test_bilinmeyen_metot_no_method_error_uretir
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 0)
    assert_raises(NoMethodError) { o.tamamen_bilinmeyen_bir_metot_xyzzy }
  end

  # ── Monkey patch / açık sınıf denetimi ───────────────────────────────────
  # Standart Ruby sınıflarına monkey patch yapılmadığını denetler.

  def test_string_sinifina_monkey_patch_yapilmamis
    refute_match(/class\s+String/, OGRENCI_SRC,
      "Ogrenci kaynaginda String sinifina mudahale bulundu")
    refute_match(/class\s+String/, DEVAMSIZLIK_KONTROL_SRC,
      "DevamsizlikKontrol kaynaginda String sinifina mudahale bulundu")
  end

  def test_integer_sinifina_monkey_patch_yapilmamis
    refute_match(/class\s+Integer/, OGRENCI_SRC,
      "Ogrenci kaynaginda Integer sinifina mudahale bulundu")
    refute_match(/class\s+Integer/, DEVAMSIZLIK_KONTROL_SRC,
      "DevamsizlikKontrol kaynaginda Integer sinifina mudahale bulundu")
  end

  def test_array_sinifina_monkey_patch_yapilmamis
    refute_match(/class\s+Array/, OGRENCI_SRC)
    refute_match(/class\s+Array/, DEVAMSIZLIK_KONTROL_SRC)
  end

  def test_hash_sinifina_monkey_patch_yapilmamis
    refute_match(/class\s+Hash/, OGRENCI_SRC)
    refute_match(/class\s+Hash/, DEVAMSIZLIK_KONTROL_SRC)
  end
end

# ===========================================================================
# DevamsizlikKontrol Sınıfı Testleri
# ===========================================================================
class DevamsizlikKontrolTest < Minitest::Test

  # ── riskli? kuralı ──────────────────────────────────────────────────────

  def test_tam_uc_devamsizlik_risklidir
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 3)
    assert DevamsizlikKontrol.riskli?(o), "Tam 3 devamsizlik riskli olmali"
  end

  def test_iki_devamsizlik_riskli_degildir
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 2)
    refute DevamsizlikKontrol.riskli?(o), "2 devamsizlik riskli olmamali"
  end

  def test_sifir_devamsizlik_riskli_degildir
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 0)
    refute DevamsizlikKontrol.riskli?(o)
  end

  def test_dort_devamsizlik_de_risklidir
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 4)
    assert DevamsizlikKontrol.riskli?(o)
  end

  def test_on_devamsizlik_de_risklidir
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 10)
    assert DevamsizlikKontrol.riskli?(o)
  end

  # ── kaldi? kuralı ───────────────────────────────────────────────────────

  def test_uc_devamsizlik_kaldi_degildir
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 3)
    refute DevamsizlikKontrol.kaldi?(o), "3 devamsizlik kalmiyor olmamali"
  end

  def test_dort_devamsizlik_kaldidir
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 4)
    assert DevamsizlikKontrol.kaldi?(o), "4 devamsizlik kaldi olmali"
  end

  def test_iki_devamsizlik_kaldi_degildir
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 2)
    refute DevamsizlikKontrol.kaldi?(o)
  end

  def test_on_devamsizlik_de_kaldidir
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 10)
    assert DevamsizlikKontrol.kaldi?(o)
  end

  # ── onur_adayi? kuralı ───────────────────────────────────────────────────

  def test_aktif_sifir_devamsizlik_onur_adayi
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 0)
    assert DevamsizlikKontrol.onur_adayi?(o), "Aktif, 0 devamsizlik onur adayi olmali"
  end

  def test_aktif_bir_devamsizlik_onur_adayi
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 1)
    assert DevamsizlikKontrol.onur_adayi?(o), "Aktif, 1 devamsizlik onur adayi olmali"
  end

  def test_aktif_iki_devamsizlik_onur_adayi_degil
    o = Ogrenci.new(ad: "X", durum: :aktif, devamsizlik: 2)
    refute DevamsizlikKontrol.onur_adayi?(o), "Aktif, 2 devamsizlik onur adayi olmamali"
  end

  def test_donduruldu_sifir_devamsizlikta_onur_adayi_degil
    o = Ogrenci.new(ad: "X", durum: :donduruldu, devamsizlik: 0)
    refute DevamsizlikKontrol.onur_adayi?(o), "Dondurulmus ogrenci onur adayi olamaz"
  end

  def test_mezun_sifir_devamsizlikta_onur_adayi_degil
    o = Ogrenci.new(ad: "X", durum: :mezun, devamsizlik: 0)
    refute DevamsizlikKontrol.onur_adayi?(o), "Mezun ogrenci onur adayi olamaz"
  end
end
