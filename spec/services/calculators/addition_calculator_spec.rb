require "rails_helper"

RSpec.describe Calculators::AdditionCalculator do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) do
    build(:disclosure_check,
          known_date:,
          conviction_length:,
          conviction_length_type:)
  end

  let(:known_date) { Date.new(2018, 10, 31) }

  let(:conviction_length) { nil }
  let(:conviction_length_type) { nil }

  describe Calculators::AdditionCalculator::PlusZeroMonths do
    describe "#expiry_date" do
      context "without a conviction length" do
        it { expect(subject.expiry_date.to_s).to eq("2020-10-31") }
      end

      context "with an indefinite conviction length" do
        let(:conviction_length_type) { "indefinite" }

        it { expect(subject.expiry_date).to eq(ResultsVariant::INDEFINITE) }
      end

      context "with a conviction length" do
        let(:conviction_length) { 5 }
        let(:conviction_length_type) { "years" }

        it { expect(subject.expiry_date.to_s).to eq("2023-10-31") }
      end
    end
  end

  describe Calculators::AdditionCalculator::PlusSixMonths do
    describe "#expiry_date" do
      context "without a conviction length" do
        it { expect(subject.expiry_date.to_s).to eq("2020-10-31") }
      end

      context "with an indefinite conviction length" do
        let(:conviction_length_type) { "indefinite" }

        it { expect(subject.expiry_date).to eq(ResultsVariant::INDEFINITE) }
      end

      context "with a conviction length" do
        let(:conviction_length) { 5 }
        let(:conviction_length_type) { "years" }

        it { expect(subject.expiry_date.to_s).to eq("2024-04-30") }
      end
    end
  end

  describe Calculators::AdditionCalculator::PlusTwelveMonths do
    describe "#expiry_date" do
      context "without a conviction length" do
        it { expect(subject.expiry_date.to_s).to eq("2020-10-31") }
      end

      context "with an indefinite conviction length" do
        let(:conviction_length_type) { "indefinite" }

        it { expect(subject.expiry_date).to eq(ResultsVariant::INDEFINITE) }
      end

      context "with a conviction length" do
        let(:conviction_length) { 5 }
        let(:conviction_length_type) { "years" }

        it { expect(subject.expiry_date.to_s).to eq("2024-10-31") }
      end
    end
  end

  describe Calculators::AdditionCalculator::StartPlusSixMonths do
    describe "#expiry_date" do
      it { expect(subject.expiry_date.to_s).to eq("2019-04-30") }
    end
  end

  describe Calculators::AdditionCalculator::StartPlusTwelveMonths do
    describe "#expiry_date" do
      it { expect(subject.expiry_date.to_s).to eq("2019-10-31") }
    end
  end
end
