RSpec.describe MultipleResultsPresenter do
  let(:disclosure_check) { create(:disclosure_check, :dto_conviction, :completed) }
  let(:disclosure_report) { disclosure_check.disclosure_report }

  subject { described_class.new(disclosure_report) }

  describe '.initialize' do
    it 'processes the check groups (proceedings) for later use' do
      expect(subject.calculator.proceedings).not_to be_empty
    end
  end

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('results/multiples/check') }
  end

  describe '#variant' do
    it { expect(subject.variant).to eq(:multiples) }
  end

  describe '#summary' do
    let(:summary) { subject.summary }
    let(:spent_date) { 'date' }

    context 'when the report is completed' do
      before do
        disclosure_report.completed!
      end

      it 'returns CheckGroupPresenter with spent dates' do
        expect(summary.size).to eq(1)
        expect(summary[0]).to be_an_instance_of(CheckGroupPresenter)
        expect(summary[0].number).to eql(1)
        expect(summary[0].check_group).to eql(disclosure_check.check_group)
        expect(summary[0].spent_date).to eq(Date.new(2020, 7, 1))
      end
    end

    context 'when the report is not yet completed' do
      before do
        disclosure_report.in_progress!
      end

      it 'returns CheckGroupPresenter without spent dates' do
        expect(summary.size).to eq(1)
        expect(summary[0]).to be_an_instance_of(CheckGroupPresenter)
        expect(summary[0].number).to eql(1)
        expect(summary[0].check_group).to eql(disclosure_check.check_group)
        expect(summary[0].spent_date).to eq(nil)
      end
    end
  end
end
