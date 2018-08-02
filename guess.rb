class Guess
  attr_reader :cell, :other_options

  def initialize(cell:, other_options:)
    @cell = cell
    @other_options = other_options
  end
end