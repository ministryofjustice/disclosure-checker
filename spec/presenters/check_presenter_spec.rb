RSpec.describe CheckPresenter do
  let(:disclosure_check) { create(:disclosure_check, :completed) }

  subject { described_class.new(disclosure_check) }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('check_your_answers/shared/check_row') }
  end


  describe '#summary' do
    let(:summary) { subject.summary }
    context 'for a single youth caution' do
      it 'returns CheckRow' do
        expect(summary).to be_an_instance_of(CheckRow)
        expect(summary.question_answers.size).to eq(4)
      end
    end
  end
end
