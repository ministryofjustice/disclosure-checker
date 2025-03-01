require "rails_helper"

RSpec.describe Calculators::SentenceCalculator do
  subject(:calculator) { described_class.new(disclosure_check) }

  let(:disclosure_check) do
    build(:disclosure_check,
          known_date:,
          conviction_length:,
          conviction_length_type:)
  end

  let(:known_date) { Date.new(2016, 10, 20) }
  let(:conviction_length) { nil }
  let(:conviction_length_type) { ConvictionLengthType::MONTHS.to_s }
  let(:conviction_end_date) { calculator.send(:conviction_end_date) }

  describe Calculators::SentenceCalculator::Detention do
    describe "#expiry_date" do
      context "with conviction length of 12 months or less" do
        let(:conviction_length) { 11 }
        let(:expected) { conviction_end_date.advance(months: 6) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "with conviction length of over 12 months and up to 4 years" do
        let(:conviction_length) { 48 }
        let(:expected) { conviction_end_date.advance(months: 24) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "with conviction length over 4 years" do
        let(:conviction_length) { 49 }
        let(:expected) { conviction_end_date.advance(months: 42) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when conviction length is in years" do
        let(:conviction_length_type) { ConvictionLengthType::YEARS.to_s }
        let(:conviction_length) { 1 }
        let(:expected) { conviction_end_date.advance(months: 6) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when conviction length is in weeks" do
        let(:conviction_length_type) { ConvictionLengthType::WEEKS.to_s }
        let(:conviction_length) { 53 }
        let(:expected) { conviction_end_date.advance(months: 24) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when conviction length is in days" do
        let(:conviction_length_type) { ConvictionLengthType::DAYS.to_s }
        let(:conviction_length) { 367 }
        let(:expected) { conviction_end_date.advance(months: 24) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when there is no upper limit" do
        let(:conviction_length) { 240 }

        it { expect(calculator.valid?).to be(true) }
        it { expect { calculator.expiry_date }.not_to raise_exception(BaseCalculator::InvalidCalculation) }
      end
    end

    context "when schedule 18 offence over 4 years" do
      let(:conviction_length) { 49 }

      before do
        disclosure_check.conviction_schedule18 = "yes"
        disclosure_check.conviction_multiple_sentences = "no"
      end

      it { expect(calculator.expiry_date).to eq ResultsVariant::NEVER_SPENT }
    end
  end

  describe Calculators::SentenceCalculator::DetentionTraining do
    describe "#expiry_date" do
      context "with conviction length of 12 months or less" do
        let(:conviction_length) { 11 }
        let(:expected) { conviction_end_date.advance(months: 6) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "with conviction length of over 12 months and up to 24 months" do
        let(:conviction_length) { 24 }
        let(:expected) { conviction_end_date.advance(months: 24) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when conviction length is in years" do
        let(:conviction_length_type) { ConvictionLengthType::YEARS.to_s }
        let(:conviction_length) { 1 }
        let(:expected) { conviction_end_date.advance(months: 6) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when conviction length is in weeks" do
        let(:conviction_length_type) { ConvictionLengthType::WEEKS.to_s }
        let(:conviction_length) { 53 }
        let(:expected) { conviction_end_date.advance(months: 24) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when conviction length is in days" do
        let(:conviction_length_type) { ConvictionLengthType::DAYS.to_s }
        let(:conviction_length) { 367 }
        let(:expected) { conviction_end_date.advance(months: 24) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when there is an upper limit" do
        let(:conviction_length) { 25 } # the upper limit in this conviction is 24 months

        it { expect(calculator.valid?).to be(false) }
        it { expect { calculator.expiry_date }.to raise_exception(BaseCalculator::InvalidCalculation) }
      end
    end
  end

  describe Calculators::SentenceCalculator::Prison do
    describe "#expiry_date" do
      context "with conviction length of 12 months or less" do
        let(:conviction_length) { 11 }
        let(:expected) { conviction_end_date.advance(months: 12) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "with conviction length of over 12 months and up to 48 months" do
        let(:conviction_length) { 29 }
        let(:expected) { conviction_end_date.advance(months: 48) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "with conviction length over 4 years" do
        let(:conviction_length) { 49 }
        let(:expected) { conviction_end_date.advance(months: 84) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when conviction length is in years" do
        let(:conviction_length_type) { ConvictionLengthType::YEARS.to_s }
        let(:conviction_length) { 1 }
        let(:expected) { conviction_end_date.advance(months: 12) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when conviction length is in weeks" do
        let(:conviction_length_type) { ConvictionLengthType::WEEKS.to_s }
        let(:conviction_length) { 53 }
        let(:expected) { conviction_end_date.advance(months: 48) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when conviction length is in days" do
        let(:conviction_length_type) { ConvictionLengthType::DAYS.to_s }
        let(:conviction_length) { 367 }
        let(:expected) { conviction_end_date.advance(months: 48) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when there is no upper limit" do
        let(:conviction_length) { 120 }

        it { expect(calculator.valid?).to be(true) }
        it { expect { calculator.expiry_date }.not_to raise_exception(BaseCalculator::InvalidCalculation) }
      end
    end

    context "when schedule 18 offence over 4 years" do
      let(:conviction_length) { 49 }

      before do
        disclosure_check.conviction_schedule18 = "yes"
        disclosure_check.conviction_multiple_sentences = "no"
      end

      it { expect(calculator.expiry_date).to eq ResultsVariant::NEVER_SPENT }
    end
  end

  describe Calculators::SentenceCalculator::SuspendedPrison do
    describe "#expiry_date" do
      context "with conviction length of 12 months or less" do
        let(:conviction_length) { 11 }
        let(:expected) { conviction_end_date.advance(months: 12) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "with conviction length of over 12 months and up to 24 months" do
        let(:conviction_length) { 24 }
        let(:expected) { conviction_end_date.advance(months: 48) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when conviction length is in years" do
        let(:conviction_length_type) { ConvictionLengthType::YEARS.to_s }
        let(:conviction_length) { 1 }
        let(:expected) { conviction_end_date.advance(months: 12) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when conviction length is in weeks" do
        let(:conviction_length_type) { ConvictionLengthType::WEEKS.to_s }
        let(:conviction_length) { 53 }
        let(:expected) { conviction_end_date.advance(months: 48) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when conviction length is in days" do
        let(:conviction_length_type) { ConvictionLengthType::DAYS.to_s }
        let(:conviction_length) { 367 }
        let(:expected) { conviction_end_date.advance(months: 48) }

        it { expect(calculator.expiry_date.to_s).to eq(expected.to_s) }
      end

      context "when there is an upper limit" do
        let(:conviction_length) { 25 } # the upper limit in this conviction is 24 months

        it { expect(calculator.valid?).to be(false) }
        it { expect { calculator.expiry_date }.to raise_exception(BaseCalculator::InvalidCalculation) }
      end
    end
  end
end
