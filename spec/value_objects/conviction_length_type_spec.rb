require "rails_helper"

RSpec.describe ConvictionLengthType do
  describe "#without_length?" do
    subject(:without_length) { described_class.new(value).without_length? }

    context "when days" do
      let(:value) { :days }

      it { expect(without_length).to eq(false) }
    end

    context "when weeks" do
      let(:value) { :weeks }

      it { expect(without_length).to eq(false) }
    end

    context "when months" do
      let(:value) { :months }

      it { expect(without_length).to eq(false) }
    end

    context "when years" do
      let(:value) { :years }

      it { expect(without_length).to eq(false) }
    end

    context "when no_length" do
      let(:value) { :no_length }

      it { expect(without_length).to eq(true) }
    end

    context "when indefinite" do
      let(:value) { :indefinite }

      it { expect(without_length).to eq(true) }
    end
  end

  describe ".values" do
    it "returns all possible values" do
      expect(described_class.values.map(&:to_s)).to eq(%w[
        days
        weeks
        months
        years
        indefinite
        no_length
      ])
    end
  end
end
