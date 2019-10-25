RSpec.describe CheckAnswersPresenter do
  let!(:disclosure_check) { create(:disclosure_check, :completed) }
  let!(:disclosure_report) { disclosure_check.disclosure_report }

  subject { described_class.new(disclosure_report) }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('check_your_answers/check') }
  end

  describe '#summary' do
    let(:summary) { subject.summary }
    context 'for a single youth caution' do
      it 'returns CheckGroupPresenter' do
        expect(summary.size).to eq(1)
        expect(summary[0]).to be_an_instance_of(CheckGroupPresenter)
        expect(summary[0].number).to eql(1)
        expect(summary[0].check_group).to eql(disclosure_check.check_group)
      end
    end
  end
end
