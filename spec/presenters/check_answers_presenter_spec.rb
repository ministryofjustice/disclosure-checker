RSpec.describe CheckAnswersPresenter do
  subject(:presenter) { described_class.new(disclosure_report) }

  let(:disclosure_check) { create(:disclosure_check, :dto_conviction, :completed) }
  let(:disclosure_report) { disclosure_check.disclosure_report }

  describe ".initialize" do
    it "processes the check groups (proceedings) for later use" do
      expect(presenter.calculator.proceedings).not_to be_empty
    end
  end

  describe "#scope" do
    it { expect(presenter.scope).to eq(:check_your_answers) }
  end

  describe "#summary" do
    let(:summary) { presenter.summary }
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
        expect(summary[0].spent_date).to eq(Date.new(2019, 7, 1))
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
end
