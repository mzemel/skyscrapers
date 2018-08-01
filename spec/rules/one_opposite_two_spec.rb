require 'rspec'
require_relative '../../loader.rb'

RSpec.describe OneOppositeTwo do
  let(:data) do
    [4,1,2,2,3,1,2,2,2,2,4,1,1,2,3,2]
  end
  let(:game) { Game.new(data: data) }

  subject { described_class.new(game: game) }

  describe '#perform' do
    let(:board) do
<<-BOARD
    4   1   2   2
  +---------------+
2 |   |   |   |   | 3
  +---------------+
3 |   |   |   |   | 1
  +---------------+
2 |   |   |   |   | 2
  +---------------+
1 | 4 |   |   | 3 | 2
  +---------------+
    1   4   2   2
BOARD
    end

    before do
      game.cell_at(0,3).value = game.power
      subject.perform
    end

    it "marks cell[3,3] as the second-highest number" do
      expect(game.cell_at(3,3).value).to eq game.power - 1
    end

    it 'marks cell[3,3] as solved' do
      expect(game.cell_at(3,3)).to be_solved
    end

    it 'matches the expected board' do
      expect(Printer.new(game: game).board).to eq board
    end
  end
end
