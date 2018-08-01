class Cell
  attr_reader :x, :y
  attr_accessor :value

  def initialize(x:, y:, value:)
    @x = x
    @y = y
    @value = value
  end
end