class Rule
  def initialize(game:)
    @game = game
    @changed_board = false
  end

  def changed_board?
    @changed_board
  end

  private

  attr_reader :game
end