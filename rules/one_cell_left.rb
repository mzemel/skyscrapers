# A process-of-elimination rule
class OneCellLeft < Rule
  def perform
    game.hints.each do |hint|
      unsolved_cells = game.cells_in_lane_of(hint).reject(&:solved?)
      next unless unsolved_cells.size == 1
      values = game.cells_in_lane_of(hint).select(&:solved?).map(&:value)
      remaining_value = ((1..game.power).to_a - values).first
      unsolved_cells[0].value = remaining_value
      @changed_board = true
    end
  end
end