require "rails_helper"

RSpec.describe Calculators::SentenceCalculator do
  subject { described_class.new(disclosure_check) }

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
      context "conviction length of 6 months or less" do
        let(:conviction_months) { 5 }

        it { expect(subject.expiry_date.to_s).to eq("2018-09-19") }
      end

      context "conviction length of 7 to 30 months" do
        let(:conviction_months) { 29 }

        it { expect(subject.expiry_date.to_s).to eq("2021-03-19") }
      end

      context "conviction length of over 30 months and up to 4 years" do
        let(:conviction_months) { 48 }

        it { expect(subject.expiry_date.to_s).to eq("2024-04-19") }
      end

      context "never spent for conviction length over 4 years" do
        let(:conviction_months) { 49 }

        it { expect(subject.expiry_date).to eq(ResultsVariant::NEVER_SPENT) }
      end

      context "there is no upper limit" do
        let(:conviction_months) { 120 } # obscene number of months

        it { expect(subject.valid?).to eq(true) }
        it { expect { subject.expiry_date }.not_to raise_exception(BaseCalculator::InvalidCalculation) }
      end
    end
  end

  describe Calculators::SentenceCalculator::DetentionTraining do
    describe "#expiry_date" do
      context "conviction length of 6 months or less" do
        let(:conviction_months) { 5 }

        it { expect(subject.expiry_date.to_s).to eq("2018-09-19") }
      end

      context "conviction length of 7 to 24 months" do
        let(:conviction_months) { 24 }

        it { expect(subject.expiry_date.to_s).to eq("2020-10-19") }
      end

      context "there is an upper limit" do
        let(:conviction_months) { 25 } # the upper limit in this conviction is 24 months

        it { expect(subject.valid?).to eq(false) }
        it { expect { subject.expiry_date }.to raise_exception(BaseCalculator::InvalidCalculation) }
      end
    end
  end

  describe Calculators::SentenceCalculator::Prison do
    describe "#expiry_date" do
      context "conviction length of 6 months or less" do
        let(:conviction_months) { 5 }

        it { expect(subject.expiry_date.to_s).to eq("2019-03-19") }
      end

      context "conviction length of 7 to 30 months" do
        let(:conviction_months) { 29 }

        it { expect(subject.expiry_date.to_s).to eq("2023-03-19") }
      end

      context "conviction length of over 30 months and up to 4 years" do
        let(:conviction_months) { 48 }

        it { expect(subject.expiry_date.to_s).to eq("2027-10-19") }
      end

      context "never spent for conviction length over 4 years" do
        let(:conviction_months) { 49 }

        it { expect(subject.expiry_date).to eq(ResultsVariant::NEVER_SPENT) }
      end

      context "there is no upper limit" do
        let(:conviction_months) { 120 } # obscene number of months

        it { expect(subject.valid?).to eq(true) }
        it { expect { subject.expiry_date }.not_to raise_exception(BaseCalculator::InvalidCalculation) }
      end
    end

    # Just one example is enough as all other types of sentences behave the same
    describe "#expiry_date - with bail time" do
      let(:known_date) { Date.new(2019, 12, 18) }
      let(:conviction_months) { 31 }
      let(:bail_days) { 50 } # equals to 50 days less in the spent date

      it { expect(subject.expiry_date.to_s).to eq("2029-05-28") }
    end
  end

  describe Calculators::SentenceCalculator::SuspendedPrison do
    describe "#expiry_date" do
      context "conviction length of 6 months or less" do
        let(:conviction_months) { 5 }

        it { expect(subject.expiry_date.to_s).to eq("2019-03-19") }
      end

      context "conviction length of 7 to 24 months" do
        let(:conviction_months) { 24 }

        it { expect(subject.expiry_date.to_s).to eq("2022-10-19") }
      end

      context "there is an upper limit" do
        let(:conviction_months) { 25 } # the upper limit in this conviction is 24 months

        it { expect(subject.valid?).to eq(false) }
        it { expect { subject.expiry_date }.to raise_exception(BaseCalculator::InvalidCalculation) }
      end
    end
  end
end
