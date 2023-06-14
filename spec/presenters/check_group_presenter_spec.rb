RSpec.describe CheckGroupPresenter do
  subject(:presenter) do
    described_class.new(
      number,
      disclosure_check.check_group,
      spent_date:,
      scope: "foobar",
    )
  end

  let!(:disclosure_check) { create(:disclosure_check, :conviction, :completed) }
  let(:number) { 1 }
  let(:spent_date) { nil }

  describe "#to_partial_path" do
    it { expect(presenter.to_partial_path).to eq("foobar/shared/check") }
  end

  describe "#summary" do
    let(:summary) { presenter.summary }

    context "when a single youth caution" do
      it "returns CheckPresenter" do
        expect(summary.size).to eq(1)
        expect(summary[0]).to be_an_instance_of(CheckPresenter)
        expect(summary[0].disclosure_check).to eql(disclosure_check)
      end
    end
  end

  describe "#spent_tag" do
    let(:spent_date) { Date.yesterday }

    it "builds a SpentTag instance with the correct attributes" do
      tag = presenter.spent_tag

      expect(tag).to be_an_instance_of(SpentTag)
      expect(tag.color).to eq(SpentTag::GREEN)
      expect(tag.variant).to eq(ResultsVariant::SPENT)
    end
  end

  describe "#spent_date_panel" do
    let(:spent_date) { "date" }

    before do
      allow(presenter).to receive(:first_check_kind).and_return("caution") # rubocop:disable RSpec/SubjectStub
    end

    it "builds a SpentDatePanel instance with the correct attributes" do
      panel = presenter.spent_date_panel

      expect(panel).to be_an_instance_of(SpentDatePanel)
      expect(panel.spent_date).to eq(spent_date)
      expect(panel.kind).to eq("caution")
    end
  end

  describe "#dbs_visibility" do
    let(:spent_date) { Date.yesterday }

    before do
      allow(presenter).to receive(:first_check_kind).and_return("caution") # rubocop:disable RSpec/SubjectStub
    end

    it "builds a DbsVisibility instance with the correct attributes" do
      panel = presenter.dbs_visibility

      expect(panel).to be_an_instance_of(DbsVisibility)
      expect(panel.kind).to eq("caution")
      expect(panel.variant).to eq(ResultsVariant::SPENT)
      expect(panel.completed_checks).to eq([disclosure_check])
    end
  end

  describe "#check_group_kind" do
    context "when a caution" do
      before do
        create(:disclosure_check, :caution, :completed)
      end

      it { expect(presenter.check_group_kind).to eq("caution") }
    end

    context "when a conviction" do
      before do
        create(:disclosure_check, :conviction, :completed)
      end

      it { expect(presenter.check_group_kind).to eq("conviction") }
    end
  end

  describe "#add_another_sentence_button?" do
    context "when a caution" do
      before do
        create(:disclosure_check, :caution, :completed)
      end

      it { expect(presenter.add_another_sentence_button?).to eq(false) }
    end

    context "when a conviction" do
      before do
        create(:disclosure_check, :conviction, :completed)
      end

      it { expect(presenter.add_another_sentence_button?).to eq(true) }
    end
  end
end
