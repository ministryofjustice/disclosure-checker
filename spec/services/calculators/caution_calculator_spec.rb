require "rails_helper"

RSpec.describe Calculators::CautionCalculator do
  subject { described_class.new(disclosure_check) }

  describe "#expiry_date" do
    let(:disclosure_check) do
      build(:disclosure_check,
            caution_type:,
            known_date:,
            conditional_end_date:)
    end

    context "for a simple caution" do
      let(:caution_type) { CautionType::ADULT_SIMPLE_CAUTION }
      let(:known_date) { nil }
      let(:conditional_end_date) { nil }

      it "returns the `spent_simple` variant without doing any date calculations" do
        # This is because simple cautions are spent on the day they given.
        expect(subject.expiry_date).to eq(ResultsVariant::SPENT_SIMPLE)
      end
    end

    context "for a conditional caution" do
      let(:caution_type) { CautionType::ADULT_CONDITIONAL_CAUTION }
      let(:known_date) { Date.new(2019, 1, 31) }
      let(:conditional_end_date) { nil }

      context "Difference between conditional end date and caution date less than 3 months" do
        let(:conditional_end_date) { Date.new(2019, 3, 30) }

        it "returns conditional end date" do
          expect(subject.expiry_date.to_s).to eq(conditional_end_date.to_s)
        end
      end

      context "Difference between conditional end date and caution date greater than 3 months" do
        let(:conditional_end_date) { Date.new(2019, 5, 30) }
        let(:result) { Date.new(2019, 4, 30) }

        it "returns caution date plus 3 months" do
          expect(subject.expiry_date.to_s).to eq(result.to_s)
        end
      end

      context "Difference between conditional end date and caution date is 2 months x days" do
        let(:known_date) { Date.new(2001, 12, 4) }
        let(:conditional_end_date) { Date.new(2002, 3, 3) }

        it "returns conditional end date" do
          expect(subject.expiry_date.to_s).to eq(conditional_end_date.to_s)
        end
      end

      context "Leap year" do
        context "Difference between conditional end date and caution date less than 3 months" do
          let(:known_date) { Date.new(2004, 2, 29) }
          let(:conditional_end_date) { Date.new(2004, 5, 28) }

          it "returns conditional end date" do
            expect(subject.expiry_date.to_s).to eq(conditional_end_date.to_s)
          end
        end

        context "Difference between conditional end date and caution date greater than 3 months" do
          let(:known_date) { Date.new(2004, 2, 29) }
          let(:conditional_end_date) { Date.new(2004, 6, 13) }
          let(:result) { Date.new(2004, 5, 29) }

          it "returns caution date plus 3 months" do
            expect(subject.expiry_date.to_s).to eq(result.to_s)
          end
        end
      end

      context "Future date" do
        let(:known_date) { Date.new(2019, 7, 13) }

        context "Difference between conditional end date and caution date less than 3 months" do
          let(:conditional_end_date) { Date.new(2019, 9, 11) }
          let(:result) { Date.new(2004, 5, 29) }

          it "returns conditional end date" do
            expect(subject.expiry_date.to_s).to eq(conditional_end_date.to_s)
          end
        end

        context "Difference between conditional end date and caution date greater than 3 months" do
          let(:conditional_end_date) { Date.new(2019, 11, 11) }
          let(:result) { Date.new(2019, 10, 13) }

          it "returns caution date plus 3 months" do
            expect(subject.expiry_date.to_s).to eq(result.to_s)
          end
        end
      end
    end
  end
end
