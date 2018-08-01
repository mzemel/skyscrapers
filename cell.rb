class Cell
  attr_reader :x, :y, :value

  def initialize(x:, y:, value:, solved: false)
    @x = x
    @y = y
    @value = value
    @solved = solved
  end

  def mark_solved
    @solved = true
  end

  def solved?
    @solved
  end

  def value=(val)
    @value = val
    @solved = true
  end
end