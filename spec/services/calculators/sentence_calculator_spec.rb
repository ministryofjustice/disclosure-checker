require "rails_helper"

RSpec.describe Calculators::SentenceCalculator do
  subject(:calculator) { described_class.new(disclosure_check) }

  let(:disclosure_check) do
    build(:disclosure_check,
          known_date:,
          conviction_bail_days: bail_days,
          conviction_length: conviction_months,
          conviction_length_type: ConvictionLengthType::MONTHS.to_s)
  end

  let(:known_date) { Date.new(2016, 10, 20) }
  let(:conviction_months) { nil }
  let(:bail_days) { nil }

  describe Calculators::SentenceCalculator::Detention do
    describe "#expiry_date" do
      context "with conviction length of 12 months or less" do
        let(:conviction_months) { 11 }

        it { expect(calculator.expiry_date.to_s).to eq("2018-03-19") }
      end

      context "with conviction length of 12 to 30 months" do
        let(:conviction_months) { 29 }

        it { expect(calculator.expiry_date.to_s).to eq("2021-03-19") }
      end

      context "with conviction length of over 30 months and up to 4 years" do
        let(:conviction_months) { 48 }

        it { expect(calculator.expiry_date.to_s).to eq("2022-10-19") }
      end

      context "when never spent for conviction length over 4 years" do
        let(:conviction_months) { 49 }

        it { expect(calculator.expiry_date.to_s).to eq("2024-05-19") }
      end

      context "when there is no upper limit" do
        let(:conviction_months) { 240 }

        it { expect(calculator.valid?).to eq(true) }
        it { expect { calculator.expiry_date }.not_to raise_exception(BaseCalculator::InvalidCalculation) }
      end
    end
  end

  describe Calculators::SentenceCalculator::DetentionTraining do
    describe "#expiry_date" do
      context "with conviction length of 12 months or less" do
        let(:conviction_months) { 11 }

        it { expect(calculator.expiry_date.to_s).to eq("2018-03-19") }
      end

      context "with conviction length of 7 to 24 months" do
        let(:conviction_months) { 24 }

        it { expect(calculator.expiry_date.to_s).to eq("2020-10-19") }
      end

      context "when there is an upper limit" do
        let(:conviction_months) { 25 } # the upper limit in this conviction is 24 months

        it { expect(calculator.valid?).to eq(false) }
        it { expect { calculator.expiry_date }.to raise_exception(BaseCalculator::InvalidCalculation) }
      end
    end
  end

  describe Calculators::SentenceCalculator::Prison do
    describe "#expiry_date" do
      context "with conviction length of 12 months or less" do
        let(:conviction_months) { 11 }

        it { expect(calculator.expiry_date.to_s).to eq("2018-09-19") }
      end

      context "with conviction length of 7 to 30 months" do
        let(:conviction_months) { 29 }

        it { expect(calculator.expiry_date.to_s).to eq("2023-03-19") }
      end

      context "with conviction length of over 30 months and up to 4 years" do
        let(:conviction_months) { 48 }

        it { expect(calculator.expiry_date.to_s).to eq("2024-10-19") }
      end

      context "when never spent for conviction length over 4 years" do
        let(:conviction_months) { 49 }

        it { expect(calculator.expiry_date.to_s).to eq("2027-11-19") }
      end

      context "when there is no upper limit" do
        let(:conviction_months) { 120 }

        it { expect(calculator.valid?).to eq(true) }
        it { expect { calculator.expiry_date }.not_to raise_exception(BaseCalculator::InvalidCalculation) }
      end
    end

    # Just one example is enough as all other types of sentences behave the same
    describe "#expiry_date - with bail time" do
      let(:known_date) { Date.new(2019, 12, 18) }
      let(:conviction_months) { 31 }
      let(:bail_days) { 50 } # equals to 50 days less in the spent date

      it { expect(calculator.expiry_date.to_s).to eq("2026-05-28") }
    end
  end

  describe Calculators::SentenceCalculator::SuspendedPrison do
    describe "#expiry_date" do
      context "with conviction length of 12 months or less" do
        let(:conviction_months) { 11 }

        it { expect(calculator.expiry_date.to_s).to eq("2018-09-19") }
      end

      context "with conviction length of 7 to 24 months" do
        let(:conviction_months) { 24 }

        it { expect(calculator.expiry_date.to_s).to eq("2022-10-19") }
      end

      context "when there is an upper limit" do
        let(:conviction_months) { 25 } # the upper limit in this conviction is 24 months

        it { expect(calculator.valid?).to eq(false) }
        it { expect { calculator.expiry_date }.to raise_exception(BaseCalculator::InvalidCalculation) }
      end
    end
  end
end
