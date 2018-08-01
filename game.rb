require './loader.rb'

class Game
  attr_reader :power, :hints, :cells

  def initialize(data:)
    raise "Incorrect number of hints" if data.size % 4 != 0
    @power = Math.sqrt(data.size).to_i
    @data = data
    @hints = []
    @cells = []
    initialize_hints
    initialize_cells
  end

  def cell_at(x,y)
    cells[y*power + x]
  end

  def cell_next_to(hint)
    x,y = case hint.quadrant
    when 0
      [hint.position, 0]
    when 1
      [power - 1, hint.position]
    when 2
      [hint.position, power - 1]
    when 3
      [0, hint.position]
    end
    cell_at(x,y)
  end

  def cell_opposite_from(hint)
    x,y = case hint.quadrant
    when 0
      [hint.position, power - 1]
    when 1
      [0, hint.position]
    when 2
      [hint.position, 0]
    when 3
      [power - 1, hint.position]
    end
    cell_at(x,y)
  end

  def cells_in_lane_of(hint)
    case hint.quadrant
    when 0
      0.upto(power-1).map { |y| cell_at(hint.position, y) }
    when 1
      (power - 1).downto(0).map { |x| cell_at(x, hint.position) }
    when 2
      (power - 1).downto(0).map { |y| cell_at(hint.position, y) }
    when 3
      0.upto(power-1).map { |x| cell_at(x, hint.position) }
    end
  end

  def hint_opposite_from(hint)
    hints.detect do |opp|
      opp.position == hint.position &&
      opp.quadrant == (hint.quadrant + 2) % 4
    end
  end

  def remove_option_from_cells(cell)
    0.upto(power-1).each do |i|
      cell_at(i, cell.y).remove_option(cell.value)
      cell_at(cell.x, i).remove_option(cell.value)
    end
  end

  private

  attr_reader :data

  def initialize_hints
    data.each_slice(power).with_index do |hints_slice, quadrant|
      hints_slice.each_with_index do |hint, position|
        position = power - (position + 1) if [2,3].include?(quadrant)
        @hints << Hint.new(quadrant: quadrant, value: hint, position: position)
      end
    end
  end

  def initialize_cells
    power.times do |y|
      power.times do |x|
        cells << Cell.new(x: x, y: y, value: nil, game: self, options: (1..power).to_a)
      end
    end
  end
end
