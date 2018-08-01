require 'rspec'
require_relative '../loader.rb'

RSpec.describe Cell do
  subject { Cell.new(x: x, y: y, value: value, solved: solved) }
  let(:x) { 0 }
  let(:y) { 0 }
  let(:value) { }
  let(:solved) { false }

  it 'is initialized as unsolved' do
    is_expected.to_not be_solved
  end

  context 'when initialized as solved' do
    let(:solved) { true }

    it { is_expected.to be_solved }
  end

  context 'when marked as solved' do
    before { subject.mark_solved }

    it { is_expected.to be_solved }
  end
end
