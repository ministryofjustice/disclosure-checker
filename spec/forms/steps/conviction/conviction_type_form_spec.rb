require "spec_helper"

RSpec.describe Steps::Conviction::ConvictionTypeForm do
  subject(:form) { described_class.new(arguments) }

  let(:arguments) do
    {
      disclosure_check:,
      conviction_type:,
    }
  end

  let(:disclosure_check) { instance_double(DisclosureCheck, conviction_type: nil, under_age:) }
  let(:conviction_type) { nil }
  let(:under_age) { "yes" }

  describe "#values" do
    context "when under 18" do
      let(:under_age) { "yes" }

      it "shows only the relevant values" do
        expect(form.values).to eq(ConvictionType::YOUTH_PARENT_TYPES)
      end
    end

    context "when over 18" do
      let(:under_age) { "no" }

      it "shows only the relevant values" do
        expect(form.values).to eq(ConvictionType::ADULT_PARENT_TYPES)
      end
    end
  end

  describe "#save" do
    it_behaves_like "a value object form", attribute_name: :conviction_type, example_value: "discharge"

    context "when form is valid" do
      let(:conviction_type) { "discharge" }

      it "saves the record" do
        allow(disclosure_check).to receive(:update).with(
          conviction_type: "discharge",
          # Dependent attributes to be reset
          conviction_subtype: nil,
        ).and_return(true)

        expect(form.save).to be(true)
      end

      context "when conviction_type is already the same on the model" do
        let(:disclosure_check) do
          instance_double(DisclosureCheck, conviction_type:, under_age: "yes")
        end
        let(:conviction_type) { "referral_supervision_yro" }

        it "does not save the record but returns true" do
          expect(disclosure_check).not_to receive(:update)
          expect(form.save).to be(true)
        end
      end
    end
  end
end
