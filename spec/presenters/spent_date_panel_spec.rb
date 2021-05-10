RSpec.describe SpentDatePanel do
  subject { described_class.new(kind: 'caution', spent_date: spent_date) }

  let(:spent_date) { nil }
  let(:partial_path) { 'results/shared/spent_date_panel' }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq(partial_path) }
  end

  describe '#scope' do
    context 'for a past date' do
      let(:spent_date) { Date.yesterday }
      it { expect(subject.scope).to eq([partial_path, ResultsVariant::SPENT]) }
    end

    context 'for a future date' do
      let(:spent_date) { Date.tomorrow }
      it { expect(subject.scope).to eq([partial_path, ResultsVariant::NOT_SPENT]) }
    end

    context 'when `spent_date` is not a date, it just returns its value' do
      let(:spent_date) { :foobar }
      it { expect(subject.scope).to eq([partial_path, :foobar]) }
    end
  end

  describe '#date' do
    context 'it is a date instance' do
      let(:spent_date) { Date.new(2018, 10, 31) }
      it { expect(subject.date).to eq('31 October 2018') }
    end

    context 'it is not a date instance' do
      let(:spent_date) { :foobar }
      it { expect(subject.date).to be_nil }
    end
  end
end
