# frozen_string_literal: true

require 'pry'
require 'colorize'
require_relative 'app/main_application'
require_relative 'app/parser'

puts "*** #{MainApplication.settings.site_name} parser *** \n".green

puts 'Enter brand name (apple, samsung, motorola, xiaomi, etc...)'
printf 'Or press ENTER for default value (apple): '.yellow
brand = gets.strip

puts
puts 'Select output format (json, csv, file)'
printf 'Or press ENTER for default value (json): '.yellow
output_file_format = gets.strip

input_params = {}
input_params.merge!(brand: brand) unless brand.empty?
input_params.merge!(output_file_format: output_file_format) unless output_file_format.empty?

parser = Parser.new(input_params)
parser.parse!

parser.show_results
parser.store_results
