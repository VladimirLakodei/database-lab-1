# frozen_string_literal: true

# item container module
module ItemContainer
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def show_time
      printf "\nSite parsed at ".green
      puts "#{DateTime.now.strftime('%d/%m/%Y %H:%M')} \n".blue
    end
  end

  module InstanceMethods
    def add_item(attributes)
      items << Item.new(attributes)
    end

    def remove_item
      # remove item method body
    end

    def delete_items
      # remove all items method body
    end

    def method_missing(method_name, *args, &block)
      if method_name =~ /show_all_items(.*)/
        items.map { |item| puts item }
      else
        super
      end
    end

    def respond_to_missing?(method_name, include_private = false)
      method_name =~ /show_(.*)/ || super
    end
  end
end
