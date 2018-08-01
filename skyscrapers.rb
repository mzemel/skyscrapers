ENV['print'] = 'true'

require './loader.rb'

puts 'Welcome to Skyscrapers'
puts 'Please enter an example (default: 1)'
file = gets.chomp

file = '1' if file == ""

Control.new(game: nil, file: file).perform