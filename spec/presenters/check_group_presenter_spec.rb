RSpec.describe CheckGroupPresenter do
  let!(:disclosure_check) { create(:disclosure_check, :completed) }
  let!(:disclosure_report) { disclosure_check.disclosure_report }
  let(:number) { 1 }

  subject { described_class.new(number, disclosure_check.check_group, scope: 'some/path') }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('check_your_answers/shared/check') }
  end

  describe '#summary' do
    let(:summary) { subject.summary }
    context 'for a single youth caution' do
      it 'returns CheckPresenter' do
        expect(summary.size).to eq(1)
        expect(summary[0]).to be_an_instance_of(CheckPresenter)
        expect(summary[0].disclosure_check).to eql(disclosure_check)
      end
    end
  end
end
