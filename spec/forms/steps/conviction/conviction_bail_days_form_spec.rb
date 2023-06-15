require "spec_helper"

RSpec.describe Steps::Conviction::ConvictionBailDaysForm do
  subject(:form) { described_class.new(arguments) }

  let(:arguments) do
    {
      disclosure_check:,
      conviction_bail_days:,
    }
  end
  let(:disclosure_check) { instance_double(DisclosureCheck, conviction_bail_days: nil) }
  let(:conviction_bail_days) { nil }

  describe "#save" do
    context "when form is valid" do
      it "saves the record" do
        allow(disclosure_check).to receive(:update!).with(
          conviction_bail_days:,
        ).and_return(true)

        expect(form.save).to be(true)
      end
    end
  end

  describe "validations" do
    context "when allows blank" do
      let(:conviction_bail_days) { "" }

      it "is valid" do
        expect(form).to be_valid
      end
    end

    context "when allows nil" do
      let(:conviction_bail_days) { nil }

      it "is valid" do
        expect(form).to be_valid
      end
    end

    context "when `conviction_bail_days` is invalid" do
      context "and is not a number" do
        let(:conviction_bail_days) { "sss" }

        it "returns false" do
          expect(form.save).to be(false)
        end

        it "has a validation error on the field" do
          expect(form).not_to be_valid
          expect(form.errors.details[:conviction_bail_days][0][:error]).to eq(:not_a_number)
        end
      end

      context "and is not an whole number" do
        let(:conviction_bail_days) { 1.5 }

        it "returns false" do
          expect(form.save).to be(false)
        end

        it "has a validation error on the field" do
          expect(form).not_to be_valid
          expect(form.errors.details[:conviction_bail_days][0][:error]).to eq(:not_an_integer)
        end
      end

      context "and is not greater than zero" do
        let(:conviction_bail_days) { 0 }

        it "returns false" do
          expect(form.save).to be(false)
        end

        it "has a validation error on the field" do
          expect(form).not_to be_valid
          expect(form.errors.details[:conviction_bail_days][0][:error]).to eq(:greater_than)
        end
      end
    end
  end
end
