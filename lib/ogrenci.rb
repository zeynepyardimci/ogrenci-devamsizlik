# frozen_string_literal: true

# lib/ogrenci.rb
# Ogrenci veri modeli ve durum sorgulari.

class Ogrenci
  GECERLI_DURUMLAR = %i[aktif donduruldu mezun].freeze

  attr_reader :ad, :durum, :devamsizlik

  def initialize(ad:, durum:, devamsizlik:)
    validate_ad!(ad)
    validate_durum!(durum)
    validate_devamsizlik!(devamsizlik)

    @ad          = ad
    @durum       = durum
    @devamsizlik = devamsizlik
  end

  define_method(:aktif?) do
    durum == :aktif
  end

  define_method(:mezun?) do
    durum == :mezun
  end

  private

  def validate_ad!(ad)
    unless ad.is_a?(String)
      raise ArgumentError, "Ad String olmalidir, alinan: #{ad.class} (#{ad.inspect})"
    end
  end

  def validate_durum!(durum)
    return if GECERLI_DURUMLAR.include?(durum)

    raise ArgumentError, "Gecersiz durum (#{durum.inspect}). Yalnizca #{GECERLI_DURUMLAR.inspect} kabul edilir."
  end

  def validate_devamsizlik!(devamsizlik)
    unless devamsizlik.is_a?(Integer)
      raise ArgumentError, "Devamsizlik Integer olmalidir, alinan: #{devamsizlik.class} (#{devamsizlik.inspect})"
    end

    unless (0..10).cover?(devamsizlik)
      raise ArgumentError, "Devamsizlik 0..10 araliginda olmalidir, alinan: #{devamsizlik}"
    end
  end
end
