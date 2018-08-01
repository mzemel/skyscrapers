require './loader.rb'

class Game
  attr_reader :power, :hints, :cells

  def initialize(data:)
    raise "Incorrect number of hints" if data.size % 4 != 0
    @power = data.size / 4
    @data = data
    @hints = []
    @cells = []
    initialize_hints
    initialize_cells
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
    power.times do |x|
      power.times do |y|
        cells << Cell.new(x: x, y: y, value: nil)
      end
    end
  end
end
