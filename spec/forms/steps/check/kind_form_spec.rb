require "spec_helper"

RSpec.describe Steps::Check::KindForm do
  subject(:form) { described_class.new(arguments) }

  let(:arguments) do
    {
      disclosure_check:,
      kind:,
    }
  end
  let(:disclosure_check) { instance_double(DisclosureCheck, kind: nil) }
  let(:kind) { nil }

  describe ".choices" do
    it "returns the relevant choices" do
      expect(described_class.choices).to eq(%w[
        caution
        conviction
      ])
    end
  end

  describe "#save" do
    it_behaves_like "a value object form", attribute_name: :kind, example_value: "caution"

    context "when form is valid" do
      let(:kind) { "caution" }

      it "saves the record" do
        allow(disclosure_check).to receive(:update!).with(
          kind: "caution",
          # Dependent attributes to be reset
          under_age: nil,
          caution_type: nil,
          conviction_type: nil,
          conviction_subtype: nil,
          conviction_date: nil,
        ).and_return(true)

        expect(form.save).to be(true)
      end

      context "when kind is already the same on the model" do
        let(:disclosure_check) { instance_double(DisclosureCheck, kind:) }
        let(:kind) { "conviction" }

        it "does not save the record but returns true" do
          expect(disclosure_check).not_to receive(:update)
          expect(form.save).to be(true)
        end
      end
    end
  end
end
