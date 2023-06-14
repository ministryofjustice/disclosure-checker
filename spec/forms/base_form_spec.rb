require "spec_helper"

RSpec.describe BaseForm do
  subject(:form) { described_class.new }

  describe "#persisted?" do
    it "always returns false" do
      expect(form.persisted?).to eq(false)
    end
  end

  describe "#new_record?" do
    it "always returns true" do
      expect(form.new_record?).to eq(true)
    end
  end

  describe "#to_key" do
    it "always returns nil" do
      expect(form.to_key).to be_nil
    end
  end

  describe "[]" do
    let(:disclosure_check) { instance_double(DisclosureCheck) }

    before do
      form.disclosure_check = disclosure_check
    end

    it "read the attribute directly without using the method" do
      expect(form).not_to receive(:disclosure_check)
      expect(form[:disclosure_check]).to eq(disclosure_check)
    end
  end

  describe "[]=" do
    let(:disclosure_check) { instance_double(DisclosureCheck) }

    it "assigns the attribute directly without using the method" do
      expect(form).not_to receive(:disclosure_check=)
      form[:disclosure_check] = disclosure_check
      expect(form.disclosure_check).to eq(disclosure_check)
    end
  end

  describe "conviction_type and conviction_subtype value objects" do
    let(:disclosure_check) do
      instance_double(
        DisclosureCheck, conviction_type: "referral_supervision_yro", conviction_subtype: "referral_order"
      )
    end

    before do
      form.disclosure_check = disclosure_check
    end

    describe "#conviction_subtype" do
      it "returns the value object constant" do
        expect(form.conviction_subtype).to eq(ConvictionType::REFERRAL_ORDER)
      end
    end
  end
end
