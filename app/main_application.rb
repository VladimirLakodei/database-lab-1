# frozen_string_literal: true

require 'singleton'

# base config class
class MainApplication
  include Singleton

  DEFAULT_SETTINGS = {
    site_name: 'Allo.ua',
    source_site_url: 'https://allo.ua/',
    source_search_path: 'ua/products/mobile/proizvoditel-',
    brand: 'apple',
    items_container_class: '.products-layout__container',
    item_container_class: '.products-layout__item',
    output_file_format: :json,
    items_num: 10,
    output_path: "#{__dir__}/../output"
  }.freeze

  attr_accessor :settings

  def initialize
    @settings = DEFAULT_SETTINGS.dup
  end

  def add(key, value)
    @settings[key] = value
  end

  def self.settings
    OpenStruct.new(instance.settings)
  end
end
