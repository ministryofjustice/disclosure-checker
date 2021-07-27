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
        let(:disclosure_check) { build(:disclosure_check, :adult_caution, known_date: known_date) }
        let(:known_date) { nil }

        context 'for a spent variant' do
          let(:variant) { ResultsVariant::SPENT }

          context 'given less than 6 years ago' do
            let(:known_date) { 5.years.ago }
            it { expect(subject.enhanced).to eq(:will) }
          end

          context 'given more than 6 years ago' do
            let(:known_date) { 7.years.ago }
            it { expect(subject.enhanced).to eq(:maybe) }
          end
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
        let(:variant) { ResultsVariant::SPENT }

        context 'for custodial convictions' do
          let(:disclosure_check) { build(:disclosure_check, :dto_conviction) }
          it { expect(subject.enhanced).to eq(:will) }
        end

        context 'for non-custodial convictions' do
          context 'for a youth conviction' do
            let(:disclosure_check) { build(:disclosure_check, :with_youth_rehabilitation_order, conviction_date: conviction_date) }

            context 'given less than 5.5 years ago' do
              let(:conviction_date) { 5.years.ago }
              it { expect(subject.enhanced).to eq(:will) }
            end

            context 'given more than 5.5 years ago' do
              let(:conviction_date) { 6.years.ago }
              it { expect(subject.enhanced).to eq(:maybe) }
            end
          end

          context 'for an adult conviction' do
            let(:disclosure_check) { build(:disclosure_check, :with_community_order, conviction_date: conviction_date) }

            context 'given less than 11 years ago' do
              let(:conviction_date) { 10.years.ago }
              it { expect(subject.enhanced).to eq(:will) }
            end

            context 'given more than 11 years ago' do
              let(:conviction_date) { 12.years.ago }
              it { expect(subject.enhanced).to eq(:maybe) }
            end
          end
        end
      end

      context 'for a not spent variant' do
        let(:variant) { ResultsVariant::NOT_SPENT }
        it { expect(subject.enhanced).to eq(:will) }
      end
    end
  end
end
