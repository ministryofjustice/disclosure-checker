require "rails_helper"

RSpec.describe ResultsVariant do
  subject(:results_variant) { described_class.new(value) }

  describe ".values" do
    it "returns all possible values" do
      expect(described_class.values.map(&:to_s)).to eq(%w[
        spent
        not_spent
        never_spent
        spent_simple
        indefinite
        no_length
      ])
    end
  end

  describe "#to_date" do
    context "when the variant is `never_spent`" do
      let(:value) { "never_spent" }

      it "considers an infinity date" do
        expect(results_variant.to_date).to eq(Date::Infinity.new)
      end
    end

    context "when the variant is `indefinite`" do
      let(:value) { "indefinite" }

      it "considers a very far in the future date but not infinite" do
        expect(results_variant.to_date).to eq(Date.new(2049, 1, 1))
      end
    end

    # This is just a smoke test, it should not fail unless this service
    # and the code has been around for maaaaany years LOL.
    context "when current date is over the `indefinite` date" do
      let(:value) { "indefinite" }

      it "fails if the `indefinite` date is no longer in the future" do
        expect(results_variant.to_date.future?).to be(true)
      end
    end
  end

  describe "#spent?" do
    context "with a SPENT variant" do
      let(:value) { "spent" }

      it { expect(results_variant.spent?).to eq(true) }
    end

    context "with a SPENT_SIMPLE variant" do
      let(:value) { "spent_simple" }

      it { expect(results_variant.spent?).to eq(true) }
    end

    context "with a NOT_SPENT variant" do
      let(:value) { "not_spent" }

      it { expect(results_variant.spent?).to eq(false) }
    end

    context "with a NEVER_SPENT variant" do
      let(:value) { "never_spent" }

      it { expect(results_variant.spent?).to eq(false) }
    end

    context "with a INDEFINITE variant" do
      let(:value) { "indefinite" }

      it { expect(results_variant.spent?).to eq(false) }
    end

    context "with a NO_LENGTH variant" do
      let(:value) { "no_length" }

      it { expect(results_variant.spent?).to eq(false) }
    end
  end
end
