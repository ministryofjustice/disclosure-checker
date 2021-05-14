RSpec.describe DbsVisibility do
  subject { described_class.new(kind: kind, variant: variant, completed_checks: [disclosure_check]) }

  let(:kind) { 'foobar' } # only used in the view partial
  let(:variant) { nil }
  let(:disclosure_check) { nil }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('results/shared/dbs_visibility') }
  end

  describe '#basic' do
    context 'for a spent variant' do
      let(:variant) { ResultsVariant::SPENT }
      it { expect(subject.basic).to eq(:will_not) }
    end

    context 'for a not spent variant' do
      let(:variant) { ResultsVariant::NOT_SPENT }
      it { expect(subject.basic).to eq(:will) }
    end
  end

  describe '#enhanced' do
    context 'for a caution' do
      context 'for a youth caution' do
        let(:disclosure_check) { build(:disclosure_check, :youth_simple_caution) }

        context 'for a spent variant' do
          let(:variant) { ResultsVariant::SPENT }
          it { expect(subject.enhanced).to eq(:will_not) }
        end

        context 'for a not spent variant' do
          let(:variant) { ResultsVariant::NOT_SPENT }
          it { expect(subject.enhanced).to eq(:will) }
        end
      end

      context 'for an adult caution' do
        let(:disclosure_check) { build(:disclosure_check, :adult_caution) }

        context 'for a spent variant' do
          let(:variant) { ResultsVariant::SPENT }
          it { expect(subject.enhanced).to eq(:maybe) }
        end

        context 'for a not spent variant' do
          let(:variant) { ResultsVariant::NOT_SPENT }
          it { expect(subject.enhanced).to eq(:will) }
        end
      end
    end

    context 'for a conviction' do
      let(:disclosure_check) { build(:disclosure_check, :compensation) }

      context 'for a spent variant' do
        context 'for custodial convictions' do
          let(:disclosure_check) { build(:disclosure_check, :dto_conviction) }
          let(:variant) { ResultsVariant::SPENT }

          it { expect(subject.enhanced).to eq(:will) }
        end

        context 'for non-custodial convictions' do
          let(:variant) { ResultsVariant::SPENT }
          it { expect(subject.enhanced).to eq(:maybe) }
        end
      end

      context 'for a not spent variant' do
        let(:variant) { ResultsVariant::NOT_SPENT }
        it { expect(subject.enhanced).to eq(:will) }
      end
    end
  end
end
