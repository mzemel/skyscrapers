require 'rspec'
require_relative '../../loader.rb'

RSpec.describe OppositeHintsAddUp do
  let(:data) do
    [3,2,2,1,1,2,2,2,2,2,3,1,1,3,2,4]
  end
  let(:game) { Game.new(data: data) }

  subject { described_class.new(game: game) }

  describe '#perform' do
    let(:board) do
<<-BOARD
    3   2   2   1
  +---------------+
4 |   |   |   | 4 | 1
  +---------------+
2 |   | 4 |   |   | 2
  +---------------+
3 |   |   | 4 |   | 2
  +---------------+
1 |   |   |   |   | 2
  +---------------+
    1   3   2   2
BOARD
    end

    before do
      subject.perform
    end

    it "marks cell[1,1] as game power" do
      expect(game.cell_at(1,1).value).to eq game.power
    end

    it 'marks cell[1,1] as solved' do
      expect(game.cell_at(1,1)).to be_solved
    end

    it 'matches the expected board' do
      expect(Printer.new(game: game).board).to eq board
    end
  end
end
