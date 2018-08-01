class Printer
  def initialize(game:)
    @game = game
  end

  def board
    board = ''
    board += "   #{game.hints[0..game.power - 1].map(&:value).join('  ')}\n"
    board += '  +' + '-' * (game.power * 3 - 1) + "+\n"
  end

  def print
    puts board
  end

  private

  attr_reader :game
end