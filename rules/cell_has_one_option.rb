class CellHasOneOption < Rule
  def perform
    game.cells.each do |cell|
      next unless !cell.solved? && cell.options.size == 1
      cell.value = cell.options[0]
      @changed_board = true
    end
  end
end