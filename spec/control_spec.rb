require 'rspec'
require_relative '../loader.rb'

RSpec.describe Control do
  subject { described_class.new(game: game) }

  context 'when game is given' do
    let(:data) do
      [3,2,2,1,1,2,2,2,2,2,3,1,1,3,2,4]
    end
    let(:game) { Game.new(data: data) }

    it 'has a game' do
      expect(subject.game).to be_a Game
    end
  end

  context 'when no game is given' do
    let(:game) { }

    it 'loads game data from .yml file' do
      expected_hints = YAML.load_file('./examples/1.yml')['hints']
      expect(subject.game.hints.map(&:value)).to eq(expected_hints)
    end

    describe '#perform' do
      it 'applies rules to the game' do
        subject.perform
        expect(subject.game.cells[3]).to be_solved
      end

      it 'breaks after 1 cycle' do
        subject.perform
        expect(subject.cycle).to eq 1
      end
    end
  end
end
