class HintIsOne < Rule
  def perform
    game.hints.each do |hint|
      next unless hint.value == 1 && !game.cell_next_to(hint).solved?
      game.cell_next_to(hint).value = game.power
      @changed_board = true
    end
  end
end