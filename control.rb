require 'yaml'

class Control
  attr_reader :game, :cycle

  RULES = [
    HintIsOne, OneOppositeTwo, HintIsGamePower, OppositeHintsAddUp, OneCellLeft,
    CellHasOneOption
  ]

  def initialize(game: nil, file:)
    @game = game
    @file = file
    @cycle = 1
    load_from_file unless game
  end

  def perform
    print_board if ENV['print']
    loop do
      changed_board = false
      RULES.each do |klass|
        rule = klass.new(game: game)
        rule.perform
        if rule.changed_board?
          changed_board ||= true
          @cycle += 1
          print_board if ENV['print']
        end
      end
      break unless changed_board
    end
    check_for_win || check_for_loss || make_guess
  end

  private

  attr_reader :file

  def load_from_file
    data = YAML.load_file("examples/#{file}.yml")
    @game = Game.new(data: data['hints'])
    # data[:cells].each { |cell| do_something }
  end

  def print_board
    puts "\nCycle: #{cycle}"
    Printer.new(game: game).print
  end

  def check_for_win
    return unless game.complete?
    puts 'Congrats - you won!'
    true
  end

  def check_for_loss
    return unless game.invalid?
    puts 'You have reach an invalid state; if you are in a guess, return to the parent.'
    puts 'If you are not in a guess, you have lost somehow.'
    true
  end

  def make_guess
    puts 'Have not won or lost; must guess or add more rules'
    # make guess
    # set guess state and guess depth
    # perform
  end
end