require "spec_helper"

RSpec.describe Steps::Conviction::ConvictionLengthForm do
  subject(:form) { described_class.new(arguments) }

  let(:arguments) do
    {
      disclosure_check:,
      conviction_length:,
    }
  end

  let(:disclosure_check) do
    instance_double(
      DisclosureCheck,
      conviction_length_type: "months",
      conviction_subtype: ConvictionType::YOUTH_REHABILITATION_ORDER.to_s,
    )
  end

  let(:conviction_length) { "3" }

  describe "#i18n_attribute" do
    it "returns the key that will be used to translate legends and hints" do
      expect(form.i18n_attribute).to eq("months")
    end
  end

  describe "#conviction_length_type" do
    it "delegates to `disclosure_checker`" do
      expect(disclosure_check).to receive(:conviction_length_type)
      expect(form.conviction_length_type).to eq("months")
    end
  end

  describe "#save" do
    context "when form is valid" do
      it "saves the record" do
        allow(disclosure_check).to receive(:update!).with(
          conviction_length:,
        ).and_return(true)

        expect(form.save).to be(true)
      end
    end

    describe "Validation" do
      context "when conviction_length is invalid" do
        context "and length is not a number" do
          let(:conviction_length) { "sss" }

          it "returns false" do
            expect(form.save).to be(false)
          end

          it "has a validation error on the field" do
            expect(form).not_to be_valid
            expect(form.errors.details[:conviction_length][0][:error]).to eq(:not_a_number)
          end
        end

        context "when length is not greater than 0" do
          let(:conviction_length) { 0 }

          it "returns false" do
            expect(form.save).to be(false)
          end

          it "has a validation error on the field" do
            expect(form).not_to be_valid
            expect(form.errors.details[:conviction_length][0][:error]).to eq(:greater_than)
          end
        end

        context "when length is too long" do
          let(:conviction_length) { described_class::HUNDRED_YEARS_IN_DAYS + 1 }

          it "returns false" do
            expect(form.save).to be(false)
          end

          it "has a validation error on the field" do
            expect(form).not_to be_valid
            expect(form.errors.details[:conviction_length][0][:error]).to eq(:less_than)
          end
        end

        context "when length is not an whole number" do
          let(:conviction_length) { 1.5 }

          it "returns false" do
            expect(form.save).to be(false)
          end

          it "has a validation error on the field" do
            expect(form).not_to be_valid
            expect(form.errors.details[:conviction_length][0][:error]).to eq(:not_an_integer)
          end
        end

        context "when length upper limit validation for a Suspended prison sentence" do
          let(:disclosure_check) do
            build(:disclosure_check, :suspended_prison_sentence, conviction_length_type: "months")
          end

          context "when upper limit is valid" do
            let(:conviction_length) { 24 }

            it "returns true" do
              expect(form.save).to be(true)
            end
          end

          context "when upper limit is not valid" do
            let(:conviction_length) { 25 }

            it "returns false" do
              expect(form.save).to be(false)
            end

            it "has a validation error on the field" do
              expect(form).not_to be_valid
              expect(form.errors.details[:conviction_length][0][:error]).to eq(:invalid_sentence)
            end
          end
        end

        context "when length upper limit validation for a DTO sentence" do
          let(:disclosure_check) do
            build(:disclosure_check, :dto_conviction, conviction_length_type: "months")
          end

          context "when upper limit is valid" do
            let(:conviction_length) { 24 }

            it "returns true" do
              expect(form.save).to be(true)
            end
          end

          context "when upper limit is not valid" do
            let(:conviction_length) { 25 }

            it "returns false" do
              expect(form.save).to be(false)
            end

            it "has a validation error on the field" do
              expect(form).not_to be_valid
              expect(form.errors.details[:conviction_length][0][:error]).to eq(:invalid_sentence)
            end
          end
        end
      end
    end
  end
end
