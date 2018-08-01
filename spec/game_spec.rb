require 'rspec'
require_relative '../loader.rb'

RSpec.describe Game do
  let(:data) do
    [3,2,2,1,1,2,2,2,2,2,3,1,1,3,2,4]
  end

  subject { described_class.new(data: data) }

  it 'has a power of 4' do
    expect(subject.power).to eq 4
  end

  it 'has power * 4 hints' do
    expect(subject.hints.size).to eq subject.power * 4
  end

  describe 'hints' do
    describe 'first hint' do
      let(:hint) { subject.hints.first }

      it 'has a quadrant of 0' do
        expect(hint.quadrant).to eq 0
      end

      it 'has a value of 3' do
        expect(hint.value).to eq 3
      end

      it 'has a position of 0' do
        expect(hint.position).to eq 0
      end
    end

    describe 'last hint' do
      let(:hint) { subject.hints.last }

      it 'has a quadrant of 3' do
        expect(hint.quadrant).to eq 3
      end

      it 'has a value of 4' do
        expect(hint.value).to eq 4
      end

      it 'has a position of 0' do
        expect(hint.position).to eq 0
      end
    end
  end

  describe 'cells' do
    it 'has power**2 cells' do
      expect(subject.cells.size).to eq subject.power**2
    end

    describe 'first cell' do
      let(:cell) { subject.cells.first }

      it 'has an x coordinate of 0' do
        expect(cell.x).to eq 0
      end

      it 'has a y coordinate of 0' do
        expect(cell.y).to eq 0
      end

      it 'has no value' do
        expect(cell.value).to be nil
      end
    end

    describe 'last cell' do
      let(:cell) { subject.cells.last }

      it 'has an x coordinate of 3' do
        expect(cell.x).to eq 3
      end

      it 'has a y coordinate of 3' do
        expect(cell.y).to eq 3
      end

      it 'has no value' do
        expect(cell.value).to be nil
      end
    end
  end
end
