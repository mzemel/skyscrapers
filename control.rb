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
    @start = Time.now.to_f
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
    puts "Completed in #{Time.now.to_f - @start} seconds"
    true
  end

  def check_for_loss
    return unless game.invalid?
    if game.guess_depth > 0
      puts "\n^ Bad state encountered; undoing last guess"
      guess = game.guesses.last
      puts "Guess was #{guess.cell.value} at [#{guess.cell.x},#{guess.cell.y}] (other options: #{guess.other_options.join(',')})"
      game.undo_last_guess
      puts "Guess depth is reset to #{game.guess_depth}"
      return perform
    else
      puts 'Failure'
      true
    end
  end

  def make_guess
    game.make_guess
    guess = game.guesses.last
    puts "Guessing #{guess.cell.value} at [#{guess.cell.x},#{guess.cell.y}] (other options: #{guess.other_options.join(',')})"
    puts "Guess depth: #{game.guess_depth}"
    perform
  end
end