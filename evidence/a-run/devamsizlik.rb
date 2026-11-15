# Öğrenci Devamsızlık Kontrol Sistemi
# Devamsızlık sınırı: %30

DEVAMSIZLIK_SINIRI = 30.0

# Renkli terminal çıktısı için ANSI kodları
module Renk
  SIFIRLA   = "\e[0m"
  KALIN     = "\e[1m"
  KIRMIZI   = "\e[31m"
  YESIL     = "\e[32m"
  SARI      = "\e[33m"
  MAVI      = "\e[34m"
  CAMGOBEGI = "\e[36m"
  BEYAZ     = "\e[37m"

  def self.kirmizi(metin)  = "#{KIRMIZI}#{metin}#{SIFIRLA}"
  def self.yesil(metin)    = "#{YESIL}#{metin}#{SIFIRLA}"
  def self.sari(metin)     = "#{SARI}#{metin}#{SIFIRLA}"
  def self.mavi(metin)     = "#{MAVI}#{metin}#{SIFIRLA}"
  def self.kalin(metin)    = "#{KALIN}#{metin}#{SIFIRLA}"
  def self.camgobegi(metin)= "#{CAMGOBEGI}#{metin}#{SIFIRLA}"
end

# Öğrenci verisi: { ad, toplam_ders, devamsiz_ders }
OGRENCILER = [
  { no: "2301", ad: "Ayşe Kaya",        toplam_ders: 40, devamsiz_ders: 4  },
  { no: "2302", ad: "Mehmet Demir",     toplam_ders: 40, devamsiz_ders: 13 },
  { no: "2303", ad: "Zeynep Arslan",    toplam_ders: 40, devamsiz_ders: 7  },
  { no: "2304", ad: "Ali Çelik",        toplam_ders: 40, devamsiz_ders: 15 },
  { no: "2305", ad: "Fatma Yıldız",     toplam_ders: 40, devamsiz_ders: 2  },
  { no: "2306", ad: "Emre Şahin",       toplam_ders: 40, devamsiz_ders: 12 },
  { no: "2307", ad: "Selin Aydın",      toplam_ders: 40, devamsiz_ders: 20 },
  { no: "2308", ad: "Burak Korkmaz",    toplam_ders: 40, devamsiz_ders: 0  },
  { no: "2309", ad: "Merve Doğan",      toplam_ders: 40, devamsiz_ders: 11 },
  { no: "2310", ad: "Hasan Yılmaz",     toplam_ders: 40, devamsiz_ders: 18 },
  { no: "2311", ad: "Cansu Öztürk",     toplam_ders: 40, devamsiz_ders: 9  },
  { no: "2312", ad: "Tarık Bulut",      toplam_ders: 40, devamsiz_ders: 14 },
  { no: "2313", ad: "Nisan Erdoğan",    toplam_ders: 40, devamsiz_ders: 3  },
  { no: "2314", ad: "Ozan Güneş",       toplam_ders: 40, devamsiz_ders: 16 },
  { no: "2315", ad: "İpek Tekin",       toplam_ders: 40, devamsiz_ders: 6  },
]

def devamsizlik_hesapla(ogrenci)
  oran = (ogrenci[:devamsiz_ders].to_f / ogrenci[:toplam_ders]) * 100
  sinir_asimi = oran > DEVAMSIZLIK_SINIRI
  kalan_hak   = [(DEVAMSIZLIK_SINIRI / 100.0 * ogrenci[:toplam_ders]).floor - ogrenci[:devamsiz_ders], 0].max

  {
    yuzde:       oran.round(1),
    sinir_asimi: sinir_asimi,
    kalan_hak:   kalan_hak
  }
end

def baslik_yazdir
  puts
  puts Renk.mavi("=" * 70)
  puts Renk.kalin(Renk.mavi("   ÖĞRENCİ DEVAMSIZLIK KONTROL SİSTEMİ"))
  puts Renk.mavi("   Devamsızlık Sınırı: %#{DEVAMSIZLIK_SINIRI.to_i}  |  Tarih: #{Time.now.strftime('%d.%m.%Y')}")
  puts Renk.mavi("=" * 70)
  puts
end

def tablo_baslik_yazdir
  fmt = "%-6s %-20s %10s %12s %10s   %-12s"
  puts Renk.kalin(format(fmt, "No", "Öğrenci Adı", "Toplam", "Devamsız", "Oran %", "Durum"))
  puts Renk.camgobegi("-" * 70)
end

def ogrenci_satiri_yazdir(ogrenci, sonuc)
  fmt = "%-6s %-20s %10d %12d %10.1f   %-12s"

  if sonuc[:sinir_asimi]
    durum  = "⚠  SINIR AŞILDI"
    satir  = format(fmt, ogrenci[:no], ogrenci[:ad],
                    ogrenci[:toplam_ders], ogrenci[:devamsiz_ders],
                    sonuc[:yuzde], durum)
    puts Renk.kirmizi(satir)
  else
    durum  = "✓  Normal (#{sonuc[:kalan_hak]} hak)"
    satir  = format(fmt, ogrenci[:no], ogrenci[:ad],
                    ogrenci[:toplam_ders], ogrenci[:devamsiz_ders],
                    sonuc[:yuzde], durum)
    renk = sonuc[:yuzde] >= 20 ? :sari : :yesil
    puts Renk.send(renk, satir)
  end
end

def ozet_yazdir(sonuclar)
  toplam        = sonuclar.size
  sinir_asan    = sonuclar.count { |s| s[:sinir_asimi] }
  normal        = toplam - sinir_asan
  ortalama_oran = sonuclar.sum { |s| s[:yuzde] } / toplam.to_f

  puts
  puts Renk.mavi("=" * 70)
  puts Renk.kalin("  ÖZET")
  puts Renk.mavi("-" * 70)
  puts "  Toplam Öğrenci Sayısı  : #{Renk.kalin(toplam.to_s)}"
  puts "  Normal Durumdaki       : #{Renk.yesil(normal.to_s)}"
  puts "  Sınırı Aşan            : #{sinir_asan > 0 ? Renk.kirmizi(sinir_asan.to_s) : Renk.yesil("0")}"
  puts "  Ortalama Devamsızlık   : #{Renk.kalin("%#{ortalama_oran.round(1)}")}"
  puts Renk.mavi("=" * 70)
  puts
end

def sinir_asan_liste_yazdir(ogrenciler, sonuclar_map)
  asanlar = ogrenciler.select { |o| sonuclar_map[o[:no]][:sinir_asimi] }
  return if asanlar.empty?

  puts Renk.kirmizi(Renk.kalin("  ⚠  DEVAMSIZLIK SINIRINI AŞAN ÖĞRENCİLER"))
  puts Renk.kirmizi("  " + "-" * 40)
  asanlar.each do |o|
    s = sonuclar_map[o[:no]]
    fazla = (s[:yuzde] - DEVAMSIZLIK_SINIRI).round(1)
    puts Renk.kirmizi("  • [#{o[:no]}] #{o[:ad].ljust(20)} — %#{s[:yuzde]}  (sınırı %#{fazla} aştı)")
  end
  puts
end

# ─── ANA PROGRAM ──────────────────────────────────────────────────────────────

baslik_yazdir
tablo_baslik_yazdir

sonuclar     = []
sonuclar_map = {}

OGRENCILER.each do |ogrenci|
  sonuc = devamsizlik_hesapla(ogrenci)
  ogrenci_satiri_yazdir(ogrenci, sonuc)
  sonuclar << sonuc
  sonuclar_map[ogrenci[:no]] = sonuc
end

ozet_yazdir(sonuclar)
sinir_asan_liste_yazdir(OGRENCILER, sonuclar_map)
