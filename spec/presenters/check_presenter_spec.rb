RSpec.describe CheckPresenter do
  let(:disclosure_check) { instance_double(DisclosureCheck) }
  let(:scope) { 'foobar' }

  subject { described_class.new(disclosure_check, scope: scope) }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('foobar/shared/check_row') }
  end

  describe '#summary' do
    let(:item_presenter) { instance_double(ResultsPresenter, summary: item_summary) }
    let(:item_summary) { [1,2,3] }

    before do
      allow(ResultsItemPresenter).to receive(:build).and_return(item_presenter)
    end

    it 'returns the items from the `ResultsItemPresenter`' do
      expect(ResultsItemPresenter).to receive(:build).with(disclosure_check, scope: scope)
      expect(subject.summary).to eq(item_summary)
    end
  end
end
