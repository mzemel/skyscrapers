class HintIsOne < Rule
  def initialize(game:)
    @game = game
  end

  def perform
    game.hints.each do |hint|
      next if hint.value != 1 || game.cell_next_to(hint).solved?
      game.cell_next_to(hint).value = game.power
    end
  end

  private

  attr_reader :game
end