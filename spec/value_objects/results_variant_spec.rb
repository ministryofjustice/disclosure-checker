require 'rails_helper'

RSpec.describe ResultsVariant do
  subject { described_class.new(value) }

  describe '.values' do
    it 'returns all possible values' do
      expect(described_class.values.map(&:to_s)).to eq(%w(
        spent
        not_spent
        never_spent
        spent_simple
        indefinite
      ))
    end
  end

  describe '#to_date' do
    context 'when the variant is `never_spent`' do
      let(:value) { 'never_spent' }

      it 'considers an infinity date' do
        expect(subject.to_date).to eq(Date::Infinity.new)
      end
    end

    context 'when the variant is `indefinite`' do
      let(:value) { 'indefinite' }

      it 'considers a very far in the future date but not infinite' do
        expect(subject.to_date).to eq(Date.new(2049, 1, 1))
      end
    end

    # This is just a smoke test, it should not fail unless this service
    # and the code has been around for maaaaany years LOL.
    context 'when current date is over the `indefinite` date' do
      let(:value) { 'indefinite' }

      it 'fails if the `indefinite` date is no longer in the future' do
        expect(subject.to_date.future?).to be(true)
      end
    end
  end

  describe '#spent?' do
    context 'for a SPENT variant' do
      let(:value) { 'spent' }
      it { expect(subject.spent?).to eq(true) }
    end

    context 'for a SPENT_SIMPLE variant' do
      let(:value) { 'spent_simple' }
      it { expect(subject.spent?).to eq(true) }
    end

    context 'for a NOT_SPENT variant' do
      let(:value) { 'not_spent' }
      it { expect(subject.spent?).to eq(false) }
    end

    context 'for a NEVER_SPENT variant' do
      let(:value) { 'never_spent' }
      it { expect(subject.spent?).to eq(false) }
    end

    context 'for a INDEFINITE variant' do
      let(:value) { 'indefinite' }
      it { expect(subject.spent?).to eq(false) }
    end
  end
end
