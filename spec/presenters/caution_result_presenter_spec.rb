RSpec.describe CautionResultPresenter do
  subject(:presenter) { described_class.new(disclosure_check, scope:) }

  let(:disclosure_check) { build(:disclosure_check, :youth_simple_caution) }
  let(:scope) { "results" }

  before do
    allow(disclosure_check).to receive(:id).and_return("12345")
  end

  describe "#scope" do
    it { expect(presenter.scope).to eq([scope, "caution"]) }
  end

  describe "#kind" do
    it { expect(presenter.kind).to eq("caution") }
  end

  describe "#order_type" do
    it { expect(presenter.order_type).to eq("youth_simple_caution") }
  end

  describe "#summary" do
    let(:summary) { presenter.summary }

    context "when a youth simple caution" do
      it "returns the correct question-answer pairs" do
        expect(summary.size).to eq(2)

        expect(summary[0].question).to be(:under_age)
        expect(summary[0].answer).to eql("yes")
        expect(summary[0].change_path).to be_nil

        expect(summary[1].question).to be(:known_date)
        expect(summary[1].answer).to eq("31 October 2018")
        expect(summary[1].change_path).to eq("/steps/caution/known_date?check_id=12345&next_step=cya")
      end
    end

    context "when a youth conditional caution" do
      let(:disclosure_check) { build(:disclosure_check, :youth_conditional_caution) }

      it "returns the correct question-answer pairs" do
        expect(summary.size).to eq(3)

        expect(summary[0].question).to be(:under_age)
        expect(summary[0].answer).to eql("yes")
        expect(summary[0].change_path).to be_nil

        expect(summary[1].question).to be(:known_date)
        expect(summary[1].answer).to eq("31 October 2018")
        expect(summary[1].change_path).to eq("/steps/caution/known_date?check_id=12345&next_step=cya")

        expect(summary[2].question).to be(:conditional_end_date)
        expect(summary[2].answer).to eq("25 December 2018")
        expect(summary[2].change_path).to eq("/steps/caution/conditional_end_date?check_id=12345")
      end
    end

    context "when there are approximate dates" do
      let(:disclosure_check) { build(:disclosure_check, :youth_conditional_caution, approximate_known_date: true) }

      it "formats the date to indicate it is approximate" do
        expect(summary[1].question).to be(:known_date)
        expect(summary[1].answer).to eq("31 October 2018 (approximate)")

        expect(summary[2].question).to be(:conditional_end_date)
        expect(summary[2].answer).to eq("25 December 2018")
      end
    end
  end

  describe "#expiry_date" do
    before do
      allow_any_instance_of(CheckResult).to receive(:expiry_date).and_return("foobar") # rubocop:disable RSpec/AnyInstance
    end

    it "delegates the method to the calculator" do
      expect(presenter.expiry_date).to eq("foobar")
    end
  end
end
