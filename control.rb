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
    loop do
      changed_board = false
      RULES.each do |klass|
        rule = klass.new(game: game)
        rule.perform
        if rule.changed_board?
          changed_board ||= true
          @cycle += 1
          system "clear"
          print_board if ENV['print']
          sleep 0.05
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
    puts "Cycle: #{cycle}"
    puts "Depth: #{game.guess_depth}"
    guess = game.guesses.last
    if guess
      puts "Last guess: #{guess.cell.value} at [#{guess.cell.x},#{guess.cell.y}]"
    else
      puts "Last guess: "
    end
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
      puts "FAKE NEWS"
      game.undo_last_guess
      return perform
    else
      puts 'Failure'
      true
    end
  end

  def make_guess
    game.make_guess
    perform
  end
end