class Cell
  attr_reader :x, :y, :versions

  def initialize(x:, y:, value:, solved: false, options: [], game:)
    @x = x
    @y = y
    @game = game
    @versions = [{guess_depth: 0, solved: solved, value: value, options: options}]
  end

  def solved?
    versions.last[:solved]
  end

  def options
    versions.last[:options]
  end

  def value
    versions.last[:value]
  end

  def guess_depth
    versions.last[:guess_depth]
  end

  def value=(value)
    versions << {guess_depth: game.guess_depth, solved: true, value: value, options: []}
    game.remove_option_from_cells(self)
  end

  def remove_option(value)
    return if solved?
    options = versions.last[:options] - [value]
    versions << {guess_depth: game.guess_depth, solved: false, value: nil, options: options}
  end

  def revert_to_version(version)
    return if guess_depth < version
    loop do
      break if versions.last[:guess_depth] <= version
      versions.pop
    end
  end

  private

  attr_reader :game
end