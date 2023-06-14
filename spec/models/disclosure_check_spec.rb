require "rails_helper"

RSpec.describe DisclosureCheck, type: :model do
  subject(:disclosure_check) { described_class.new(attributes) }

  let(:attributes) { {} }

  describe "#conviction" do
    let(:attributes) { { conviction_subtype: "adult_criminal_behaviour" } }

    it "returns the ConvictionType value-object" do
      expect(disclosure_check.conviction).to eq(ConvictionType::ADULT_CRIMINAL_BEHAVIOUR)
    end

    it "returns nil for caution" do
      expect(disclosure_check.caution).to be_nil
    end
  end

  describe "#caution" do
    let(:attributes) { { caution_type: "adult_simple_caution" } }

    it "returns the CautionType value-object" do
      expect(disclosure_check.caution).to eq(CautionType::ADULT_SIMPLE_CAUTION)
    end

    it "returns nil for conviction" do
      expect(disclosure_check.conviction).to be_nil
    end
  end

  describe "#drag_through?" do
    it "delegates to the conviction" do
      spy = verifying_spy(disclosure_check)
      expect(spy).to receive(:conviction).and_call_original
      disclosure_check.drag_through?
    end
  end
end
