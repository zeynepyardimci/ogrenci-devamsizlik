# frozen_string_literal: true

# lib/devamsizlik_kontrol.rb
# Devamsizlik kurallari kontrol sinifi.

class DevamsizlikKontrol
  def self.riskli?(ogrenci)
    ogrenci.devamsizlik >= 3
  end

  def self.kaldi?(ogrenci)
    ogrenci.devamsizlik >= 4
  end

  def self.onur_adayi?(ogrenci)
    ogrenci.aktif? && ogrenci.devamsizlik <= 1
  end
end
