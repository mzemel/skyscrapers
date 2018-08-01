require 'yaml'

class Control
  attr_reader :game, :cycle

  RULES = [HintIsOne]

  def initialize(game: nil, file:)
    @game = game
    @file = file
    @cycle = 0
    load_from_file unless game
  end

  def perform
    loop do
      print_board if ENV['print']
      changed_board = false
      RULES.each do |klass|
        rule = klass.new(game: game)
        rule.perform
        changed_board ||= rule.changed_board?
      end
      break unless changed_board
      @cycle += 1
    end
  end

  private

  attr_reader :file

  def load_from_file
    data = YAML.load_file("examples/#{file}.yml")
    @game = Game.new(data: data['hints'])
    # data[:cells].each { |cell| do_something }
  end

  def print_board
    puts "Cycle: #{cycle}"
    Printer.new(game: game).print
  end
end