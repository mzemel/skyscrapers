class OppositeHintsAddUp < Rule
  def perform
    game.hints.each do |hint|
      next unless hint.value + game.hint_opposite_from(hint).value - 1 == game.power
      cell = game.cells_in_lane_of(hint)[hint.value - 1]
      next if cell.solved?
      cell.value = game.power
      @changed_board = true
    end
  end
end