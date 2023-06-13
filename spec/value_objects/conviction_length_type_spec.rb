require "rails_helper"

RSpec.describe ConvictionLengthType do
  describe "#without_length?" do
    subject { described_class.new(value).without_length? }

    context "days" do
      let(:value) { :days }

      it { expect(subject).to eq(false) }
    end

    context "weeks" do
      let(:value) { :weeks }

      it { expect(subject).to eq(false) }
    end

    context "months" do
      let(:value) { :months }

      it { expect(subject).to eq(false) }
    end

    context "years" do
      let(:value) { :years }

      it { expect(subject).to eq(false) }
    end

    context "no_length" do
      let(:value) { :no_length }

      it { expect(subject).to eq(true) }
    end

    context "indefinite" do
      let(:value) { :indefinite }

      it { expect(subject).to eq(true) }
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
