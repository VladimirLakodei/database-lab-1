# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'forwardable'
require_relative 'main_application'

# parse class
class Parser
  extend Forwardable

  attr_reader :main_application, :settings, :cart

  def_delegators :@main_application, :store_results, :show_results

  def initialize(settings = {})
    @main_application = MainApplication.instance
    @settings = init_settings(settings)
    @cart = main_application.cart
  end

  def parse!
    doc = Nokogiri::HTML(URI.parse(search_path).open)

    puts "Parsing URL: #{search_path} ... \n"

    doc.at(settings.items_container_class)
       .css(settings.item_container_class)[...settings.items_num]
       .each_with_index do |item_node, index|
      cart.add_item(parse_item(item_node, index))
    end
  end

  private

  def init_settings(settings)
    main_application.settings.merge!(settings)
    main_application.class.settings
  end

  def search_path
    settings.source_site_url +
      settings.source_search_path +
      settings.brand
  end

  def parse_item(item_node, index)
    # we use regular expression here
    # based on config in main_application

    {
      position: index + 1,
      name: item_node.at_css('.product-card__title').attr('title'),
      rate: item_node.at_css('.rating-stars__secondary')&.attr('style')&.gsub(/[a-zA-Z;:]/, '') || '-',
      price: "#{item_node.at_css('.sum').text}#{item_node.at_css('.currency').text}",
      direct_link: item_node.at_css('.product-card__title').attr('href')
    }
  end
end
