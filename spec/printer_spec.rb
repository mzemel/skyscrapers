require 'rspec'
require_relative '../loader.rb'

RSpec.describe Printer do
  let(:data) do
    [3,2,2,1,1,2,2,2,2,2,3,1,1,3,2,4]
  end
  let(:game) { Game.new(data: data) }

  subject { described_class.new(game: game) }

  let(:board) do
<<-BOARD
   3  2  2  1
  +-----------+
4 |  |  |  |  | 1
  +-----------+
2 |  |  |  |  | 2
  +-----------+
3 |  |  |  |  | 2
  +-----------+
1 |  |  |  |  | 2
  +-----------+
    1  3  2  2
BOARD
  end

  it 'correctly formats the board' do
    expect(subject.board).to eq(board)
  end

  xit 'will print to STDOUT' do
    expect(Kernel).to receive(:puts)
    subject.print
  end
end