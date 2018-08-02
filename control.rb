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
      if !changed_board
        check_for_win || check_for_loss || game.make_guess
      end
    end
  end

  private

  attr_reader :file

  def load_from_file
    data = YAML.load_file("examples/#{file}.yml")
    if data['hints'].is_a?(String)
      data['hints'] = data['hints'].split(',')
    end
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
    exit
  end

  def check_for_loss
    return unless game.invalid?
    if game.guess_depth > 0
      game.undo_last_guess
      true
    else
      puts 'Failure'
      exit
    end
  end
end