RSpec.describe ConvictionResultPresenter do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check, :dto_conviction) }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('results/conviction') }
  end

  describe '#question_attributes' do
    it {
      expect(
        subject.question_attributes
      ).to eq([:kind, :conviction_type, :conviction_subtype, :under_age, :known_date, :conviction_length, :conviction_length_type, :compensation_payment_date])
    }
  end

  # TODO: this needs more tests
  describe '#summary' do
    let(:summary) { subject.summary }

    it 'return array of objects' do
      expect(summary.size).to eq(7)

      expect(summary[0].question).to eql(:kind)
      expect(summary[0].answer).to eql('conviction')
    end
  end

  describe '#expiry_date' do
    before do
      allow_any_instance_of(ConvictionCheckResult).to receive(:expiry_date).and_return('foobar')
    end

    it 'delegates the method to the calculator' do
      expect(subject.expiry_date).to eq('foobar')
    end
  end
end
