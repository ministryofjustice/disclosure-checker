require "rails_helper"

RSpec.describe Calculators::DisqualificationCalculator do
  subject(:calculator) { described_class.new(disclosure_check) }

  let(:disclosure_check) do
    build(:disclosure_check,
          known_date:,
          conviction_length:,
          conviction_length_type:)
  end

  let(:known_date) { Date.new(2018, 10, 31) }
  let(:conviction_length) { nil }
  let(:conviction_length_type) { nil }

  describe Calculators::DisqualificationCalculator::StartPlusZeroMonths do
    describe "#expiry_date" do
      context "without a length" do
        it { expect(calculator.expiry_date.to_s).to eq("2018-10-31") }
      end
    end
  end

  context "with a length" do
    let(:conviction_length) { 6 }
    let(:conviction_length_type) { "months" }

    it { expect(calculator.expiry_date.to_s).to eq("2019-04-30") }
  end
end
