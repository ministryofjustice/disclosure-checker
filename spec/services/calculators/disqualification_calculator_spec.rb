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

  describe Calculators::DisqualificationCalculator::Youths do
    let(:under_age) { GenericYesNo::YES }

    describe "#expiry_date" do
      context "with an indefinite length" do
        let(:conviction_length_type) { "indefinite" }

        it { expect(calculator.expiry_date).to eq(ResultsVariant::INDEFINITE) }
      end

      context "without a length" do
        let(:conviction_length_type) { "no_length" }

        it { expect(calculator.expiry_date).to eq(ResultsVariant::NO_LENGTH) }
      end
    end
  end

  describe Calculators::DisqualificationCalculator::Adults do
    let(:under_age) { GenericYesNo::NO }

    describe "#expiry_date" do
      context "with an indefinite length" do
        let(:conviction_length_type) { "indefinite" }

        it { expect(calculator.expiry_date).to eq(ResultsVariant::INDEFINITE) }
      end

      context "without a length" do
        let(:conviction_length_type) { "no_length" }

        it { expect(calculator.expiry_date).to eq(ResultsVariant::NO_LENGTH) }
      end
    end
  end
end
