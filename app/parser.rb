# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require_relative 'main_application'
require_relative 'card'

# parse class
class Parser
  attr_reader :settings, :card

  def initialize(settings = {})
    @settings = init_settings(settings)
    @card = Card.new
  end

  def parse!
    doc = Nokogiri::HTML(URI.parse(search_path).open)

    puts "Parsing URL: #{search_path}... \n"

    doc.at(settings.items_container_class)
       .css(settings.item_container_class)[...settings.items_num]
       .each_with_index do |item_node, index|
      card.add_item(parse_item(item_node, index))
    end
  end

  def show_results
    # Example of a class method call
    Card.show_time

    card.show_all_items
  end

  def store_results
    card.send("save_to_#{settings.output_file_format}", settings.output_path)
  rescue StandardError => _e
    raise 'Output file format isn\'t supported'
  end

  private

  def init_settings(settings)
    MainApplication.instance.settings.merge!(settings)
    MainApplication.settings
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
