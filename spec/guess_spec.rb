require 'rspec'
require_relative '../loader.rb'

RSpec.describe Guess do
  let(:data) do
    [3,2,2,1,1,2,2,2,2,2,3,1,1,3,2,4]
  end

  let(:game) { Game.new(data: data) }

  subject { described_class.new(cell: game.cells.first, other_options: [1,2,3]) }

  it 'has a cell' do
    expect(subject.cell).to be_a Cell
  end

  it 'has other_options' do
    expect(subject.other_options).to be_a Array
  end
end