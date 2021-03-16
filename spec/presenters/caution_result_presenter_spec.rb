RSpec.describe CautionResultPresenter do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check, :youth_simple_caution) }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('results/caution') }
  end

  describe '#variant' do
    context 'when simple caution' do
      it { expect(subject.variant).to eq('caution_spent_simple') }
    end

    context 'when conditional cautions' do
      let(:disclosure_check) { build(:disclosure_check, :youth_conditional_caution) }

      before do
        allow(subject).to receive(:expiry_date).and_return(expiry_date)
      end

      context 'spent caution' do
        let(:expiry_date) { Date.yesterday }
        it { expect(subject.variant).to eq('caution_spent') }
      end

      context 'not spent caution' do
        let(:expiry_date) { Date.tomorrow }
        it { expect(subject.variant).to eq('caution_not_spent') }
      end
    end
  end

  describe '#summary' do
    let(:summary) { subject.summary }

    context 'for a youth simple caution' do
      it 'returns the correct question-answer pairs' do
        expect(summary.size).to eq(2)

        expect(summary[0].question).to eql(:under_age)
        expect(summary[0].answer).to eql('yes')

        expect(summary[1].question).to eql(:known_date)
        expect(summary[1].answer).to eq('31 October 2018')
      end
    end

    context 'for a youth conditional caution' do
      let(:disclosure_check) { build(:disclosure_check, :youth_conditional_caution) }

      it 'returns the correct question-answer pairs' do
        expect(summary.size).to eq(3)

        expect(summary[0].question).to eql(:under_age)
        expect(summary[0].answer).to eql('yes')

        expect(summary[1].question).to eql(:known_date)
        expect(summary[1].answer).to eq('31 October 2018')

        expect(summary[2].question).to eql(:conditional_end_date)
        expect(summary[2].answer).to eq('25 December 2018')
      end
    end

    context 'when there are approximate dates' do
      let(:disclosure_check) { build(:disclosure_check, :youth_conditional_caution, approximate_known_date: true) }

      it 'formats the date to indicate it is approximate' do
        expect(summary[1].question).to eql(:known_date)
        expect(summary[1].answer).to eq('31 October 2018 (approximate)')

        expect(summary[2].question).to eql(:conditional_end_date)
        expect(summary[2].answer).to eq('25 December 2018')
      end
    end
  end

  describe '#expiry_date' do
    before do
      allow_any_instance_of(CheckResult).to receive(:expiry_date).and_return('foobar')
    end

    it 'delegates the method to the calculator' do
      expect(subject.expiry_date).to eq('foobar')
    end
  end

  describe '#time_on_bail?' do
    let(:disclosure_check) { build(:disclosure_check, conviction_bail_days: bail_days) }

    context 'it is always false for cautions, as there is no bail question' do
      let(:bail_days) { nil }
      it { expect(subject.time_on_bail?).to eq(false) }
    end
  end
end
