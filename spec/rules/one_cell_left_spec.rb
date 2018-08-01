require 'rspec'
require_relative '../../loader.rb'

RSpec.describe OneCellLeft do
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
4 | 1 | 2 | 3 | 4 | 1
  +---------------+
2 |   |   |   |   | 2
  +---------------+
3 |   |   |   |   | 2
  +---------------+
1 |   |   |   |   | 2
  +---------------+
    1   3   2   2
BOARD
    end

    before do
      game.cell_at(0,0).value = 1
      game.cell_at(1,0).value = 2
      game.cell_at(2,0).value = 3
      subject.perform
    end

    it "marks cell[3,0] as the last remaining option" do
      expect(game.cell_at(3,0).value).to eq 4
    end

    it 'marks cell[3,0] as solved' do
      expect(game.cell_at(3,0)).to be_solved
    end

    it 'matches the expected board' do
      expect(Printer.new(game: game).board).to eq board
    end
  end
end
