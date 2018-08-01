class OneOppositeTwo < Rule
  def perform
    game.hints.each do |hint|
      next unless hint.value == 2 &&
                  !game.cell_next_to(hint).solved? &&
                  game.cell_opposite_from(hint).value == game.power
      game.cell_next_to(hint).value = game.power - 1
      @changed_board = true
    end
  end
end