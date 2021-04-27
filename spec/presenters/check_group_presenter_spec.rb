RSpec.describe CheckGroupPresenter do
  let!(:disclosure_check) { create(:disclosure_check, :completed) }
  let(:number) { 1 }
  let(:spent_date) { nil }

  subject {
    described_class.new(
      number,
      disclosure_check.check_group,
      spent_date: spent_date,
      scope: 'foobar'
    )
  }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('foobar/shared/check') }
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

  describe '#spent_date_panel' do
    let(:spent_date) { 'date' }

    before do
      allow(subject).to receive(:first_check_kind).and_return('caution')
    end

    it 'builds a SpentDatePanel instance with the correct attributes' do
      panel = subject.spent_date_panel

      expect(panel).to be_an_instance_of(SpentDatePanel)
      expect(panel.spent_date).to eq(spent_date)
      expect(panel.kind).to eq('caution')
    end
  end

  describe '#check_group_kind' do
    context 'caution' do
      let!(:disclosure_check) { create(:disclosure_check, :caution, :completed) }
      it { expect(subject.check_group_kind).to eq('caution') }
    end
    context 'conviction' do
      let!(:disclosure_check) { create(:disclosure_check, :conviction,  :completed) }
      it { expect(subject.check_group_kind).to eq('conviction') }
    end
  end

  describe '#add_another_sentence_button?' do
    context 'when the disclosure report is already completed' do
      before do
        disclosure_check.disclosure_report.completed!
      end

      it 'always returns false' do
        expect(subject.add_another_sentence_button?).to eq(false)
      end
    end

    context 'when the disclosure report is still in progress' do
      context 'caution' do
        let!(:disclosure_check) { create(:disclosure_check, :caution, :completed) }
        it { expect(subject.add_another_sentence_button?).to eq(false) }
      end

      context 'conviction' do
        let!(:disclosure_check) { create(:disclosure_check, :conviction,  :completed) }
        it { expect(subject.add_another_sentence_button?).to eq(true) }
      end
    end
  end
end
