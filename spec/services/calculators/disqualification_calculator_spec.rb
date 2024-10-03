require "rails_helper"

RSpec.describe Calculators::DisqualificationCalculator do
  subject(:calculator) { described_class.new(disclosure_check) }

  let(:disclosure_check) do
    build(:disclosure_check,
          under_age:,
          known_date:,
          conviction_length:,
          conviction_length_type:)
  end

  let(:known_date) { Date.new(2018, 10, 31) }
  let(:conviction_length) { nil }
  let(:conviction_length_type) { nil }

  describe Calculators::AdditionCalculator::StartPlusZeroMonths do
    describe "#expiry_date" do
      context "with a length equal to 2 years" do
        let(:conviction_length) { 2 }
        let(:conviction_length_type) { "years" }

        it { expect(calculator.expiry_date.to_s).to eq((known_date + 24.months).to_s) }
      end

      context "without a length" do
        let(:conviction_length) { "no_length" }

        it { expect(calculator.expiry_date.to_s).to eq("2018-10-31") }
      end

      context "with an indefinite length" do
        let(:conviction_length_type) { "indefinite" }

        it { expect(calculator.expiry_date).to eq(ResultsVariant::INDEFINITE) }
      end
    end
  end
end
