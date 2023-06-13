RSpec.describe ConvictionResultPresenter do
  subject { described_class.new(disclosure_check, scope:) }

  let(:disclosure_check) { build(:disclosure_check, :dto_conviction) }
  let(:scope) { "results" }

  before do
    allow(disclosure_check).to receive(:id).and_return("12345")
  end

  describe "#scope" do
    it { expect(subject.scope).to eq([scope, "conviction"]) }
  end

  describe "#kind" do
    it { expect(subject.kind).to eq("conviction") }
  end

  describe "#order_type" do
    it { expect(subject.order_type).to eq("detention_training_order") }
  end

  describe "#summary" do
    let(:summary) { subject.summary }

    it "returns the correct question-answer pairs" do
      expect(summary.size).to eq(4)

      expect(summary[0].question).to be(:under_age)
      expect(summary[0].answer).to eql("yes")
      expect(summary[0].change_path).to be_nil

      expect(summary[1].question).to be(:conviction_date)
      expect(summary[1].answer).to eq("1 January 2018")
      expect(summary[1].change_path).to be_nil

      expect(summary[2].question).to be(:known_date)
      expect(summary[2].answer).to eq("31 October 2018")
      expect(summary[2].change_path).to eq("/steps/conviction/known_date?check_id=12345&next_step=cya")

      expect(summary[3].question).to be(:conviction_length)
      expect(summary[3].answer).to eq("9 weeks")
      expect(summary[3].change_path).to eq("/steps/conviction/conviction_length_type?check_id=12345")
    end

    context "when no length given" do
      let(:disclosure_check) do
        build(:disclosure_check, :dto_conviction, conviction_length_type: ConvictionLengthType::NO_LENGTH)
      end

      it "returns the correct question-answer pairs" do
        expect(summary.size).to eq(4)

        expect(summary[3].question).to be(:conviction_length)
        expect(summary[3].answer).to eq("No length was given")
        expect(summary[3].change_path).to eq("/steps/conviction/conviction_length_type?check_id=12345")
      end
    end

    context "pay a victim compensation" do
      let(:disclosure_check) { build(:disclosure_check, :compensation) }

      it "returns the correct question-answer pairs" do
        expect(summary.size).to eq(4)

        expect(summary[3].question).to be(:compensation_payment_date)
        expect(summary[3].answer).to eq("31 October 2019")
        expect(summary[3].change_path).to eq("/steps/conviction/compensation_payment_date?check_id=12345&next_step=cya")
      end
    end

    context "when there are approximate dates" do
      let(:disclosure_check) { build(:disclosure_check, :compensation, approximate_compensation_payment_date: true) }

      it "formats the date to indicate it is approximate" do
        expect(summary[2].question).to be(:known_date)
        expect(summary[2].answer).to eq("31 October 2018")

        expect(summary[3].question).to be(:compensation_payment_date)
        expect(summary[3].answer).to eq("31 October 2019 (approximate)")
      end
    end

    context "when there is time on bail" do
      let(:disclosure_check) { build(:disclosure_check, :dto_conviction, conviction_bail_days: 15) }

      it "returns the correct question-answer pairs" do
        expect(summary.size).to eq(5)

        expect(summary[4].question).to be(:conviction_bail_days)
        expect(summary[4].answer).to eq(15)
        expect(summary[4].change_path).to eq("/steps/conviction/conviction_bail_days?check_id=12345&next_step=cya")
      end
    end
  end

  describe "#expiry_date" do
    before do
      allow_any_instance_of(CheckResult).to receive(:expiry_date).and_return("foobar")
    end

    it "delegates the method to the calculator" do
      expect(subject.expiry_date).to eq("foobar")
    end
  end
end
