RSpec.describe DbsVisibility do
  subject(:calculator) { described_class.new(kind:, variant:, completed_checks: [disclosure_check]) }

  let(:kind) { "foobar" } # only used in the view partial
  let(:variant) { nil }
  let(:disclosure_check) { nil }

  describe "#to_partial_path" do
    it { expect(calculator.to_partial_path).to eq("results/shared/dbs_visibility") }
  end

  describe "#basic" do
    context "when a spent variant" do
      let(:variant) { ResultsVariant::SPENT }

      it { expect(calculator.basic).to eq(:will_not) }
    end

    context "when not spent variant" do
      let(:variant) { ResultsVariant::NOT_SPENT }

      it { expect(calculator.basic).to eq(:will) }
    end
  end

  describe "#enhanced" do
    context "when a caution" do
      context "and for a youth caution" do
        let(:disclosure_check) { build(:disclosure_check, :youth_simple_caution) }

        context "and for a spent variant" do
          let(:variant) { ResultsVariant::SPENT }

          it { expect(calculator.enhanced).to eq(:will_not) }
        end

        context "and for a not spent variant" do
          let(:variant) { ResultsVariant::NOT_SPENT }

          it { expect(calculator.enhanced).to eq(:will) }
        end
      end

      context "when an adult caution" do
        let(:disclosure_check) { build(:disclosure_check, :adult_caution, known_date:) }
        let(:known_date) { nil }

        context "and for a spent variant" do
          let(:variant) { ResultsVariant::SPENT }

          context "and given less than 6 years ago" do
            let(:known_date) { 5.years.ago }

            it { expect(calculator.enhanced).to eq(:will) }
          end

          context "and given more than 6 years ago" do
            let(:known_date) { 7.years.ago }

            it { expect(calculator.enhanced).to eq(:will_not) }
          end
        end

        context "when a not spent variant" do
          let(:variant) { ResultsVariant::NOT_SPENT }

          it { expect(calculator.enhanced).to eq(:will) }
        end
      end
    end

    context "when a conviction" do
      let(:disclosure_check) { build(:disclosure_check, :compensation) }

      context "and a spent variant" do
        let(:variant) { ResultsVariant::SPENT }

        context "and custodial convictions" do
          let(:disclosure_check) { build(:disclosure_check, :dto_conviction) }

          it { expect(calculator.enhanced).to eq(:will) }
        end

        context "and non-custodial convictions" do
          context "when a youth conviction" do
            let(:disclosure_check) { build(:disclosure_check, :with_youth_rehabilitation_order, conviction_date:) }

            context "and given less than 5.5 years ago" do
              let(:conviction_date) { 5.years.ago }

              it { expect(calculator.enhanced).to eq(:will) }
            end

            context "and given more than 5.5 years ago" do
              let(:conviction_date) { 6.years.ago }

              it { expect(calculator.enhanced).to eq(:maybe) }
            end
          end

          context "when an adult conviction" do
            let(:disclosure_check) { build(:disclosure_check, :with_community_order, conviction_date:) }

            context "and given less than 11 years ago" do
              let(:conviction_date) { 10.years.ago }

              it { expect(calculator.enhanced).to eq(:will) }
            end

            context "and given more than 11 years ago" do
              let(:conviction_date) { 12.years.ago }

              it { expect(calculator.enhanced).to eq(:maybe) }
            end
          end
        end
      end

      context "when a not spent variant" do
        let(:variant) { ResultsVariant::NOT_SPENT }

        it { expect(calculator.enhanced).to eq(:will) }
      end
    end
  end
end
