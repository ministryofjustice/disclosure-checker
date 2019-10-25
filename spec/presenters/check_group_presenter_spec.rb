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

  describe '#check_group_name' do
    context 'caution' do
      let!(:disclosure_check) { create(:disclosure_check, :caution, :completed) }
      it { expect(subject.check_group_name).to eq('caution') }
    end
    context 'conviction' do
      let!(:disclosure_check) { create(:disclosure_check, :conviction,  :completed) }
      it { expect(subject.check_group_name).to eq('conviction') }
    end
  end


  describe '#add_another_sentence_button?' do
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
