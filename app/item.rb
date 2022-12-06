# frozen_string_literal: true

# work with item
class Item
  ATTRS = %i[position name rate price direct_link].freeze
  attr_accessor(*ATTRS)

  def initialize(attributes)
    raise 'missed attribute' if attributes.keys != ATTRS

    setup_attributes(attributes)
  end

  # print item info in defined format
  def info
    to_s
  end

  # for puts method
  def to_s
    delimiter = '-' * 70

    output_string = ''
    to_h.each do |key, value|
      output_string += "#{key.to_s.yellow}: #{value} \n"
    end
    [output_string, delimiter].join("\n")
  end

  # preparing hash from data
  def to_h
    output_hash = {}

    ATTRS.each do |attr|
      output_hash[attr] = send(attr)
    end

    output_hash
  end

  private

  def setup_attributes(attributes)
    ATTRS.each do |attr|
      send("#{attr}=", attributes[attr])
    end
  end
end
