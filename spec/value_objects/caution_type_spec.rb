require "rails_helper"

RSpec.describe CautionType do
  describe "YOUTH_TYPES" do
    let(:values) { described_class::YOUTH_TYPES.map(&:to_s) }

    it "returns youth cautions" do
      expect(values).to eq(%w[
        youth_simple_caution
        youth_conditional_caution
      ])
    end
  end

  describe "ADULT_TYPES" do
    let(:values) { described_class::ADULT_TYPES.map(&:to_s) }

    it "returns youth cautions" do
      expect(values).to eq(%w[
        adult_simple_caution
        adult_conditional_caution
      ])
    end
  end

  describe ".values" do
    let(:values) do
      %w[
        youth_simple_caution
        youth_conditional_caution
        adult_simple_caution
        adult_conditional_caution
      ]
    end

    it "returns all possible values" do
      expect(described_class.values.map(&:to_s)).to eq(values)
    end
  end

  describe "#conditional?" do
    subject(:conditional) { described_class.new(value).conditional? }

    context "when youth_conditional_caution" do
      let(:value) { :youth_conditional_caution }

      it { expect(conditional).to eq(true) }
    end

    context "when adult_conditional_caution" do
      let(:value) { :adult_conditional_caution }

      it { expect(conditional).to eq(true) }
    end

    context "when youth_simple_caution" do
      let(:value) { :youth_simple_caution }

      it { expect(conditional).to eq(false) }
    end

    context "when adult_simple_caution" do
      let(:value) { :adult_simple_caution }

      it { expect(conditional).to eq(false) }
    end
  end

  describe "#youth?" do
    subject(:youth) { described_class.new(value).youth? }

    context "when youth_conditional_caution" do
      let(:value) { :youth_conditional_caution }

      it { expect(youth).to eq(true) }
    end

    context "when adult_conditional_caution" do
      let(:value) { :adult_conditional_caution }

      it { expect(youth).to eq(false) }
    end

    context "when youth_simple_caution" do
      let(:value) { :youth_simple_caution }

      it { expect(youth).to eq(true) }
    end

    context "when adult_simple_caution" do
      let(:value) { :adult_simple_caution }

      it { expect(youth).to eq(false) }
    end
  end

  describe "#adult?" do
    subject(:adult) { described_class.new(value).adult? }

    context "when adult_conditional_caution" do
      let(:value) { :adult_conditional_caution }

      it { expect(adult).to eq(true) }
    end

    context "when youth_conditional_caution" do
      let(:value) { :youth_conditional_caution }

      it { expect(adult).to eq(false) }
    end

    context "when adult_simple_caution" do
      let(:value) { :adult_simple_caution }

      it { expect(adult).to eq(true) }
    end

    context "when youth_simple_caution" do
      let(:value) { :youth_simple_caution }

      it { expect(adult).to eq(false) }
    end
  end

  describe "#calculator_class" do
    subject(:caution_type) { described_class.new(:youth_conditional_caution) }

    it "returns the calculator class" do
      expect(caution_type.calculator_class).to eq(Calculators::CautionCalculator)
    end
  end
end
