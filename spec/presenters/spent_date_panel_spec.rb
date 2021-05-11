RSpec.describe SpentDatePanel do
  subject { described_class.new(kind: 'caution', variant: :foobar, spent_date: spent_date) }

  let(:spent_date) { nil }
  let(:partial_path) { 'results/shared/spent_date_panel' }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq(partial_path) }
  end

  describe '#scope' do
    it 'uses the partial and the variant to build the scope' do
      expect(subject.scope).to eq([partial_path, :foobar])
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
