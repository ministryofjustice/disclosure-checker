RSpec.describe ConvictionResultPresenter do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check, :dto_conviction) }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('results/conviction') }
  end

  describe '#variant' do
    before do
      allow(subject).to receive(:expiry_date).and_return(expiry_date)
    end

    context 'spent conviction' do
      let(:expiry_date) { Date.yesterday }
      it { expect(subject.variant).to eq('conviction_spent') }
    end

    context 'not spent conviction' do
      let(:expiry_date) { Date.tomorrow }
      it { expect(subject.variant).to eq('conviction_not_spent') }
    end

    context 'never spent conviction' do
      let(:expiry_date) { :never_spent }
      it { expect(subject.variant).to eq('conviction_never_spent') }
    end

    context 'no record (motoring-specific)' do
      let(:expiry_date) { :no_record }
      it { expect(subject.variant).to eq('conviction_no_record') }
    end
  end

  describe '#summary' do
    let(:summary) { subject.summary }

    it 'returns the correct question-answer pairs' do
      expect(summary.size).to eq(6)

      expect(summary[0].question).to eql(:kind)
      expect(summary[0].answer).to eql('conviction')

      expect(summary[1].question).to eql(:conviction_type)
      expect(summary[1].answer).to eql('custodial_sentence')

      expect(summary[2].question).to eql(:conviction_subtype)
      expect(summary[2].answer).to eql('detention_training_order')

      expect(summary[3].question).to eql(:under_age)
      expect(summary[3].answer).to eql('yes')

      expect(summary[4].question).to eql(:known_date)
      expect(summary[4].answer).to eq('31 October 2018')

      expect(summary[5].question).to eql(:conviction_length)
      expect(summary[5].answer).to eq('9 weeks')
    end

    context 'when no length given' do
      let(:disclosure_check) {
        build(:disclosure_check, :dto_conviction, conviction_length_type: ConvictionLengthType::NO_LENGTH)
      }

      it 'returns the correct question-answer pairs' do
        expect(summary.size).to eq(6)

        expect(summary[5].question).to eql(:conviction_length)
        expect(summary[5].answer).to eq('No length was given')
      end
    end

    context 'pay a victim compensation' do
      let(:disclosure_check) { build(:disclosure_check, :compensation) }

      it 'returns the correct question-answer pairs' do
        expect(summary.size).to eq(6)

        expect(summary[0].question).to eql(:kind)
        expect(summary[0].answer).to eql('conviction')

        expect(summary[1].question).to eql(:conviction_type)
        expect(summary[1].answer).to eql('financial')

        expect(summary[2].question).to eql(:conviction_subtype)
        expect(summary[2].answer).to eql('compensation_to_a_victim')

        expect(summary[3].question).to eql(:under_age)
        expect(summary[3].answer).to eql('yes')

        expect(summary[4].question).to eql(:known_date)
        expect(summary[4].answer).to eq('31 October 2018')

        expect(summary[5].question).to eql(:compensation_payment_date)
        expect(summary[5].answer).to eq('31 October 2019')
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
end
