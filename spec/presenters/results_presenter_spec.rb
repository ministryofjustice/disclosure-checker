RSpec.describe ResultsPresenter do
  subject(:calculator) { described_class.new(disclosure_report) }

  let(:disclosure_check) { create(:disclosure_check, :dto_conviction, :completed) }
  let(:disclosure_report) { disclosure_check.disclosure_report }

  describe ".initialize" do
    it "processes the check groups (proceedings) for later use" do
      expect(calculator.calculator.proceedings).not_to be_empty
    end
  end

  describe "#scope" do
    it { expect(calculator.scope).to eq(:results) }
  end

  describe "#summary" do
    let(:summary) { calculator.summary }
    let(:spent_date) { "date" }

    context "when the report is completed" do
      before do
        disclosure_report.completed!
      end

      it "returns CheckGroupPresenter with spent dates" do
        expect(summary.size).to eq(1)
        expect(summary[0]).to be_an_instance_of(CheckGroupPresenter)
        expect(summary[0].number).to be(1)
        expect(summary[0].check_group).to eql(disclosure_check.check_group)
        expect(summary[0].spent_date).to eq(Date.new(2019, 7, 2))
      end
    end

    context "when the report is not yet completed" do
      before do
        disclosure_report.in_progress!
      end

      it "returns CheckGroupPresenter without spent dates" do
        expect(summary.size).to eq(1)
        expect(summary[0]).to be_an_instance_of(CheckGroupPresenter)
        expect(summary[0].number).to be(1)
        expect(summary[0].check_group).to eql(disclosure_check.check_group)
        expect(summary[0].spent_date).to be_nil
      end
    end
  end

  describe "APPROXIMATE_DATE_ATTRS" do
    it "returns the expected attributes" do
      expect(described_class::APPROXIMATE_DATE_ATTRS).to eq(%i[
        approximate_known_date
        approximate_conviction_date
        approximate_conditional_end_date
        approximate_compensation_payment_date
      ])
    end
  end

  describe "#convictions?" do
    it { expect(calculator.convictions?).to be(true) }

    context "when there are no convictions" do
      let(:disclosure_check) { create(:disclosure_check, :adult_caution, :completed) }

      it { expect(calculator.convictions?).to be(false) }
    end
  end

  describe "#approximate_dates?" do
    it { expect(calculator.approximate_dates?).to be(false) }

    context "when there is an approximate date" do
      described_class::APPROXIMATE_DATE_ATTRS.each do |approximate_date_attr|
        before { disclosure_check.update(approximate_date_attr => true) }

        it { expect(calculator.approximate_dates?).to be(true) }
      end
    end
  end

  describe "#motoring?" do
    it { expect(calculator.motoring?).to be(false) }

    context "when conviction type is adult motoring" do
      before { disclosure_check.update(conviction_subtype: ConvictionType::ADULT_MOTORING_FINE) }

      it { expect(calculator.motoring?).to be(true) }
    end

    context "when conviction type is youth motoring" do
      before { disclosure_check.update(conviction_subtype: ConvictionType::YOUTH_MOTORING_FINE) }

      it { expect(calculator.motoring?).to be(true) }
    end
  end

  describe "#proceedings_size" do
    it "returns the calculator proceedings size" do
      expect(calculator.proceedings_size).to eq(1)
    end
  end

  describe "#orders_size" do
    it "returns the sum of each proceedings size" do
      expect(calculator.orders_size).to eq(1)
    end
  end
end
