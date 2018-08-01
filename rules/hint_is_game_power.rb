class HintIsGamePower < Rule
  def perform
    game.hints.each do |hint|
      next unless hint.value == game.power
      game.cells_in_lane_of(hint).each_with_index do |cell, i|
        next if cell.solved?
        cell.value = i+1
        @changed_board = true
      end
    end
  end
end