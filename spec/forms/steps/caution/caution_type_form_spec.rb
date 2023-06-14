require "spec_helper"

RSpec.describe Steps::Caution::CautionTypeForm do
  subject(:form) { described_class.new(arguments) }

  let(:arguments) do
    {
      disclosure_check:,
      caution_type:,
    }
  end
  let(:disclosure_check) { instance_double(DisclosureCheck, caution_type: nil, under_age:) }
  let(:caution_type) { nil }
  let(:under_age) { "yes" }

  describe "#values" do
    context "when under 18" do
      let(:under_age) { "yes" }

      it "shows only the relevant values" do
        expect(form.values).to eq(
          [
            CautionType.new(:youth_simple_caution),
            CautionType.new(:youth_conditional_caution),
          ],
        )
      end
    end

    context "when over 18" do
      let(:under_age) { "no" }

      it "shows only the relevant values" do
        expect(form.values).to eq(
          [
            CautionType.new(:adult_simple_caution),
            CautionType.new(:adult_conditional_caution),
          ],
        )
      end
    end
  end

  describe "#save" do
    let(:caution_type) { "youth_simple_caution" }

    it_behaves_like "a value object form", attribute_name: :caution_type, example_value: "youth_simple_caution"

    context "when form is valid" do
      it "saves the record" do
        allow(disclosure_check).to receive(:update!).with(
          caution_type:,
          # Dependent attributes to be reset
          known_date: nil,
          conditional_end_date: nil,
        ).and_return(true)
        expect(form.save).to be(true)
      end

      context "when caution_type is already the same on the model" do
        let(:disclosure_check) do
          instance_double(DisclosureCheck, caution_type:, under_age: "yes")
        end

        it "does not save the record but returns true" do
          expect(disclosure_check).not_to receive(:update)
          expect(form.save).to be(true)
        end
      end
    end
  end
end
