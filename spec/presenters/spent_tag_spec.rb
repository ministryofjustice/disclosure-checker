RSpec.describe SpentTag do
  subject { described_class.new(spent_date: spent_date) }

  let(:spent_date) { nil }

  describe '#color' do
    context 'when spent date is in the past' do
      let(:spent_date) { Date.yesterday }

      it { expect(subject.color).to eq(SpentTag::GREEN) }
    end

    context 'when spent date is in the future' do
      let(:spent_date) { Date.tomorrow }

      it { expect(subject.color).to eq(SpentTag::RED) }
    end

    context 'when spent date is NEVER_SPENT' do
      let(:spent_date) { ResultsVariant::NEVER_SPENT }

      it { expect(subject.color).to eq(SpentTag::RED) }
    end

    context 'when spent date is SPENT_SIMPLE' do
      let(:spent_date) { ResultsVariant::SPENT_SIMPLE }

      it { expect(subject.color).to eq(SpentTag::GREEN) }
    end

    context 'when spent date is INDEFINITE' do
      let(:spent_date) { ResultsVariant::INDEFINITE }

      it { expect(subject.color).to eq(SpentTag::RED) }
    end
  end

  describe '#variant' do
    context 'when spent date is a date' do
      context 'when is a past date' do
        let(:spent_date) { Date.yesterday }

        it { expect(subject.variant).to eq(ResultsVariant::SPENT) }
      end

      context 'when is a future date' do
        let(:spent_date) { Date.tomorrow }

        it { expect(subject.variant).to eq(ResultsVariant::NOT_SPENT) }
      end
    end

    context 'when spent date is INDEFINITE' do
      let(:spent_date) { ResultsVariant::INDEFINITE }

      it { expect(subject.variant).to eq(ResultsVariant::INDEFINITE) }
    end

    context 'when spent date is SPENT_SIMPLE' do
      let(:spent_date) { ResultsVariant::SPENT_SIMPLE }

      it { expect(subject.variant).to eq(ResultsVariant::SPENT_SIMPLE) }
    end

    context 'when spent date is NEVER_SPENT' do
      let(:spent_date) { ResultsVariant::NEVER_SPENT }

      it { expect(subject.variant).to eq(ResultsVariant::NEVER_SPENT) }
    end
  end

  describe '#scope' do
    it { expect(subject.scope).to eq('results/spent_tag') }
  end
end
