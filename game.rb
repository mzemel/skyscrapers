require './loader.rb'

class Game
  attr_reader :power, :hints, :cells, :guesses

  def initialize(data:)
    raise "Incorrect number of hints" if data.size % 4 != 0
    @power = data.size / 4
    @data = data
    @hints = []
    @cells = []
    @guesses = []
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

  def complete?
    return false unless cells.all?(&:solved?)
    return false if invalid?
    expected_values = (1..power).to_a
    hints[0..(power * 2 - 1)].all? do |hint|
      cells_in_lane_of(hint).map(&:value).sort == expected_values
    end
  end

  def invalid?
    duplicate_values? || incorrect_cells_seen?
  end

  def duplicate_values?
    hints[0..(power * 2 - 1)].any? do |hint|
      values = cells_in_lane_of(hint).map(&:value)
      values.compact.uniq.size != values.compact.size
    end
  end

  # Cases
  # 1. not all cells are filled in, and there are less seen (should be ok)
  # 2. not all cells are filled in, and there are more seen (bad)
  # 3. all cells are filled in, and it's equal (good)
  # 4. all cells are filled in, and it's not equal (bad)
  def incorrect_cells_seen?
    # TODO: Move this into the hint responsibility
    hints.any? do |hint|
      next unless hint.value
      highest_cell = 0
      cells_seen = 0
      cells_with_values = 0
      cells_in_lane_of(hint).each do |cell|
        cells_with_values += 1 if cell.value
        if cell.value.to_i > highest_cell
          cells_seen += 1
          highest_cell = cell.value
        end
      end
      (cells_with_values < power && cells_seen > hint.value) ||
      (cells_with_values == power && cells_seen != hint.value)
    end
  end

  def make_guess
    cell_to_guess = cells.detect { |cell| cell.options.size == 2 }
    cell_to_guess ||= cells.detect { |cell| cell.options.size == 3 }
    cell_to_guess ||= cells.detect { |cell| cell.options.size == 4 }
    cell_to_guess ||= cells.detect { |cell| cell.options.size == 5 }
    options = cell_to_guess.options
    chosen_value = options.shift
    add_guess(Guess.new(cell: cell_to_guess, other_options: options))
    cell_to_guess.value = chosen_value
  end

  def add_guess(guess)
    guesses << guess
  end

  # TODO: Every cell set during this guess depth must be reverted and their options restored
  # But also when their options are modified, they must be restored as well.
  def undo_last_guess
    cells.each { |cell| cell.revert_to_version(guess_depth - 1) }
    last_guess = guesses.pop
    next_guess_option = last_guess.other_options.pop
    if last_guess.other_options.empty?
      last_guess.cell.value = next_guess_option
    else
      add_guess(last_guess)
      last_guess.cell.value = next_guess_option
    end
  end

  def guess_depth
    guesses.size
  end

  def guessing
    guess_depth > 0
  end

  private

  attr_reader :data

  def initialize_hints
    data.each_slice(power).with_index do |hints_slice, quadrant|
      hints_slice.each_with_index do |hint, position|
        position = power - (position + 1) if [2,3].include?(quadrant)
        hint = hint.to_i.zero? ? nil : hint.to_i
        hints << Hint.new(quadrant: quadrant, value: hint, position: position)
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
