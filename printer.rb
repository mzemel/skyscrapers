class Printer
  def initialize(game:)
    @game = game
  end

  def board
    board = ''
    board += "    #{game.hints[0..game.power - 1].map {|h| h.value || ' '}.join('   ')}\n"
    board += vertical_border
    game.power.times do |i|
      left_hint = game.hints[game.hints.size - (i + 1)].value || ' '
      right_hint = game.hints[game.power + i].value || ' '
      cells = game.cells[i*game.power..(i+1)*game.power-1].map { |c| c.value || ' ' }
      board += "#{left_hint} | " + cells.join(' | ') + " | #{right_hint}\n"
      board += vertical_border
    end
    board += "    #{game.hints[game.power*2..(game.power*3-1)].map {|h| h.value || ' '}.reverse.join('   ')}\n"
    board
  end

  def print
    puts board
  end

  private

  attr_reader :game

  def vertical_border
    '  +' + '-' * (game.power * 4 - 1) + "+\n"
  end
end