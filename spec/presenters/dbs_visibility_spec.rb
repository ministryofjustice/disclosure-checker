RSpec.describe DbsVisibility do
  subject { described_class.new(kind: kind, variant: variant, completed_checks: [disclosure_check]) }

  let(:kind) { nil }
  let(:variant) { nil }
  let(:disclosure_check) { nil }

  describe '#to_partial_path' do
    it { expect(subject.to_partial_path).to eq('results/shared/dbs_visibility') }
  end

  # Note: for basic checks it does not matter if it is a caution or a conviction
  describe '#basic' do
    let(:kind) { 'foobar' }

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
      let(:kind) { 'caution' }

      context 'for a youth caution' do
        let(:disclosure_check) { build(:disclosure_check, :youth_simple_caution) }

        context 'for a spent variant' do
          let(:variant) { ResultsVariant::SPENT }
          it { expect(subject.enhanced).to eq(:will_not) }
        end

        context 'for a not spent variant' do
          let(:variant) { ResultsVariant::NOT_SPENT }
          it { expect(subject.enhanced).to eq(:will_not) }
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
      let(:kind) { 'conviction' }

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
end
