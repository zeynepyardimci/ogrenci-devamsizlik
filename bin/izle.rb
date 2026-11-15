#!/usr/bin/env ruby
# frozen_string_literal: true

# bin/izle.rb
# Dosya değişiklik izleyici — standart kütüphane (Fiddle ile inotify yok,
# platform bağımsız polling kullanılır).
# Kullanım: ruby bin/izle.rb
#
# NOT: Antigravity IDE'nin yerleşik "kaydetme tetikleyicisi" (on-save hook)
# sistemi bu proje için yapılandırılmamıştır. Desteklenip desteklenmediği
# araştırıldı; Antigravity'nin Skills/Rules sistemi "dosya kaydet" olayını
# tetikleyici olarak doğrudan sunmamaktadır. Bu nedenle aşağıdaki Ruby
# tabanlı polling izleyici oluşturulmuştur.

require "open3"

ROOT    = File.expand_path("..", __dir__)
KONTROL = File.join(ROOT, "bin", "kontrol")
PATTERN = File.join(ROOT, "{lib,test}/**/*.rb")
ARALIK  = 2  # saniye

puts "\e[34m→ Dosya izleyici başlatıldı (her #{ARALIK}s kontrol)\e[0m"
puts "  Çıkmak için Ctrl+C"
puts

# İlk anlık görüntü
def anlık_goruntu
  Dir.glob(File.join(File.expand_path("..", __dir__), "{lib,test}/**/*.rb"))
     .each_with_object({}) { |f, h| h[f] = File.mtime(f) rescue nil }
end

onceki = anlık_goruntu

trap("INT") do
  puts "\n\e[33m→ İzleyici durduruldu.\e[0m"
  exit 0
end

loop do
  sleep ARALIK
  simdiki = anlık_goruntu

  degisen = simdiki.select do |dosya, zaman|
    onceki[dosya] != zaman
  end

  yeni = simdiki.keys - onceki.keys

  if degisen.any? || yeni.any?
    (degisen.keys + yeni).each do |d|
      puts "\e[33m↺ Değişti: #{d.sub(ROOT + File::SEPARATOR, "")}\e[0m"
    end
    puts
    system("ruby", KONTROL)
    puts
  end

  onceki = simdiki
end
