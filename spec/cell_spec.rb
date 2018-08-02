require 'rspec'
require_relative '../loader.rb'

RSpec.describe Cell do
  let(:data) { [1,2,2,1,1,2,2,1] }
  let(:game) { Game.new(data: data) }

  subject { game.cells.first }

  it 'is initialized as unsolved' do
    is_expected.to_not be_solved
  end

  context 'when marked as solved' do
    before { subject.value = 1 }

    it { is_expected.to be_solved }

    it 'removes that value from the options of cells in the same lane' do
      expect(game.cells[1].options).to_not include(1)
    end
  end

  describe 'options' do
    it 'is initialized with all possible values from 1 to game power' do
      expect(subject.options.size).to eq game.power
    end

    describe 'remove_option' do
      before { subject.remove_option(2) }

      it 'removes an option' do
        expect(subject.options).to match_array([1])
      end
    end
  end
end
