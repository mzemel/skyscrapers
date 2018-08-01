class Hint
  attr_reader :quadrant,:position, :value

  def initialize(quadrant:, position:, value:)
    @quadrant = quadrant
    @position = position
    @value = value
  end

  # def opposite_hint(hints)
  #   opposite_quadrant = (quandrant + 2) % 4
  #   hints[opposite_quadrant][position]
  # end
end
