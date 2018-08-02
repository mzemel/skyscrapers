class Cell
  attr_reader :x, :y, :value, :options

  def initialize(x:, y:, value:, solved: false, options: [], game:)
    @x = x
    @y = y
    @value = value
    @solved = solved
    @options = options
    @game = game
  end

  def solved?
    @solved
  end

  def value=(val)
    @value = val
    @solved = true
    # set options to empty
    game.remove_option_from_cells(self)
  end

  def remove_option(val)
    return if solved?
    @options -= [val]
  end

  private

  attr_reader :game
end