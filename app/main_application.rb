# frozen_string_literal: true

require 'singleton'
require 'yaml'
require_relative 'cart'

# base config class
class MainApplication
  include Singleton

  attr_accessor :settings, :cart

  def initialize
    @settings = YAML.load_file("#{__dir__}/../config/settings.yml")
    @cart = Cart.new
  end

  def show_results
    # Example of a class method call
    cart.class.show_time

    cart.show_all_items
  end

  def store_results
    settings_object = self.class.settings
    output_path = "#{__dir__}/../#{settings_object.output_dir}"

    cart.send("save_to_#{settings_object.output_file_format}", output_path)
  rescue StandardError => _e
    raise 'Output file format isn\'t supported'
  end

  def self.settings
    OpenStruct.new(instance.settings)
  end
end
