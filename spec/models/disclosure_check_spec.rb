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
      expect(disclosure_check).to receive(:conviction) # rubocop:disable RSpec/SubjectStub
      disclosure_check.drag_through?
    end
  end

  describe "#conviction_length_in_years" do
    context "when length is input is in months" do
      it "returns length in 1 year" do
        conviction_length = 12
        disclosure_check.conviction_length_type = ConvictionLengthType::MONTHS.to_s

        expect(disclosure_check.conviction_length_in_years(conviction_length)).to eq 1
      end

      it "returns length in 1.5 years" do
        conviction_length = 18
        disclosure_check.conviction_length_type = ConvictionLengthType::MONTHS.to_s

        expect(disclosure_check.conviction_length_in_years(conviction_length)).to eq 1.5
      end
    end

    context "when length is input in days" do
      it "returns length between 1 and 2 years" do
        conviction_length = 500
        disclosure_check.conviction_length_type = ConvictionLengthType::DAYS.to_s

        expect(disclosure_check.conviction_length_in_years(conviction_length)).to be_between(1, 2)
      end
    end

    context "when length is input in weeks" do
      it "returns length between 1 and 2 years" do
        conviction_length = 78
        disclosure_check.conviction_length_type = ConvictionLengthType::WEEKS.to_s

        expect(disclosure_check.conviction_length_in_years(conviction_length)).to be_between(1, 2)
      end
    end

    context "when length is input in years" do
      it "returns length the years input" do
        conviction_length = 5
        disclosure_check.conviction_length_type = ConvictionLengthType::YEARS.to_s

        expect(disclosure_check.conviction_length_in_years(conviction_length)).to eq 5
      end
    end
  end

  describe "#schedule18_over_4_years" do
    context "when conviction_schedule18 is 'yes'" do
      before { disclosure_check.conviction_schedule18 = "yes" }

      context "when not multiple sentences" do
        before { disclosure_check.conviction_multiple_sentences = "no" }

        it { expect(disclosure_check.schedule18_over_4_years).to eq "yes" }
      end

      context "when multiple sentences" do
        before { disclosure_check.conviction_multiple_sentences = "yes" }

        context "when single sentence is over 4 years" do
          before { disclosure_check.single_sentence_over4 = "yes" }

          it { expect(disclosure_check.schedule18_over_4_years).to eq "yes" }
        end

        context "when single sentence is not over 4 years" do
          before { disclosure_check.single_sentence_over4 = "no" }

          it { expect(disclosure_check.schedule18_over_4_years).to eq "no" }
        end
      end
    end

    context "when conviction_schedule18 is 'no'" do
      before { disclosure_check.conviction_schedule18 = "no" }

      it { expect(disclosure_check.schedule18_over_4_years).to eq "no" }
    end
  end

  describe "#schedule18_over_4_years?" do
    context "when conviction_schedule18 is 'yes'" do
      before do
        disclosure_check.conviction_schedule18 = "yes"
        disclosure_check.conviction_multiple_sentences = "no"
      end

      it { expect(disclosure_check).to be_schedule18_over_4_years }
    end

    context "when conviction_schedule18 is 'no'" do
      before do
        disclosure_check.conviction_schedule18 = "no"
      end

      it { expect(disclosure_check).not_to be_schedule18_over_4_years }
    end
  end
end
