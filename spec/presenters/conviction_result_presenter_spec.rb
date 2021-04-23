RSpec.describe ConvictionResultPresenter do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check, :dto_conviction) }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('results/conviction') }
  end

  describe '#summary' do
    let(:summary) { subject.summary }

    it 'returns the correct question-answer pairs' do
      expect(summary.size).to eq(4)

      expect(summary[0].question).to eql(:conviction_subtype)
      expect(summary[0].answer).to eql('detention_training_order')

      expect(summary[1].question).to eql(:under_age)
      expect(summary[1].answer).to eql('yes')

      expect(summary[2].question).to eql(:known_date)
      expect(summary[2].answer).to eq('31 October 2018')

      expect(summary[3].question).to eql(:conviction_length)
      expect(summary[3].answer).to eq('9 weeks')
    end

    context 'when no length given' do
      let(:disclosure_check) {
        build(:disclosure_check, :dto_conviction, conviction_length_type: ConvictionLengthType::NO_LENGTH)
      }

      it 'returns the correct question-answer pairs' do
        expect(summary.size).to eq(4)

        expect(summary[3].question).to eql(:conviction_length)
        expect(summary[3].answer).to eq('No length was given')
      end
    end

    context 'pay a victim compensation' do
      let(:disclosure_check) { build(:disclosure_check, :compensation) }

      it 'returns the correct question-answer pairs' do
        expect(summary.size).to eq(4)

        expect(summary[0].question).to eql(:conviction_subtype)
        expect(summary[0].answer).to eql('compensation_to_a_victim')

        expect(summary[1].question).to eql(:under_age)
        expect(summary[1].answer).to eql('yes')

        expect(summary[2].question).to eql(:known_date)
        expect(summary[2].answer).to eq('31 October 2018')

        expect(summary[3].question).to eql(:compensation_payment_date)
        expect(summary[3].answer).to eq('31 October 2019')
      end
    end

    context 'when there are approximate dates' do
      let(:disclosure_check) { build(:disclosure_check, :compensation, approximate_compensation_payment_date: true) }

      it 'formats the date to indicate it is approximate' do
        expect(summary[2].question).to eql(:known_date)
        expect(summary[2].answer).to eq('31 October 2018')

        expect(summary[3].question).to eql(:compensation_payment_date)
        expect(summary[3].answer).to eq('31 October 2019 (approximate)')
      end
    end

    context 'when there is time on bail' do
      let(:disclosure_check) { build(:disclosure_check, :dto_conviction, conviction_bail_days: 15) }

      it 'returns the correct question-answer pairs' do
        expect(summary.size).to eq(5)

        expect(summary[0].question).to eql(:conviction_subtype)
        expect(summary[0].answer).to eql('detention_training_order')

        expect(summary[1].question).to eql(:under_age)
        expect(summary[1].answer).to eql('yes')

        expect(summary[2].question).to eql(:conviction_bail_days)
        expect(summary[2].answer).to eq(15)

        expect(summary[3].question).to eql(:known_date)
        expect(summary[3].answer).to eq('31 October 2018')

        # ignoring following rows as they are the same as in other tests
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
    let(:disclosure_check) { build(:disclosure_check, :dto_conviction, conviction_bail_days: bail_days) }

    context 'when there is time on bail' do
      let(:bail_days) { 5 }
      it { expect(subject.time_on_bail?).to eq(true) }
    end

    context 'when there is no time on bail' do
      let(:bail_days) { nil }
      it { expect(subject.time_on_bail?).to eq(false) }
    end

    context 'when time on bail is zero' do
      let(:bail_days) { 0 }
      it { expect(subject.time_on_bail?).to eq(false) }
    end
  end
end
