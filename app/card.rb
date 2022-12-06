# frozen_string_literal: true

require 'json'
require 'csv'
require_relative 'modules/item_container'
require_relative 'item'

# card class
class Card
  include ItemContainer
  include ItemContainer::InstanceMethods

  attr_accessor :items

  def initialize
    @items = []
  end

  def save_to_file(output_path)
    IO.write("#{output_path}/items.txt", items2array.join("\n"))
  end

  def save_to_json(output_path)
    File.open("#{output_path}/items.json", 'w') do |f|
      f.write(JSON.pretty_generate(items2array))
    end
  end

  def save_to_csv(output_path)
    CSV.open("#{output_path}/items.csv", 'wb') do |csv|
      csv << items2array.first.keys
      items2array.each do |hash|
        csv << hash.values
      end
    end
  end

  private

  def items2array
    items.map(&:to_h)
  end
end
