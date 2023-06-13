RSpec.describe SpentTag do
  subject { described_class.new(variant:) }

  let(:variant) { nil }

  describe "#color" do
    context "when variant is SPENT" do
      let(:variant) { ResultsVariant::SPENT }

      it { expect(subject.color).to eq(SpentTag::GREEN) }
    end

    context "when variant is NOT_SPENT" do
      let(:variant) { ResultsVariant::NOT_SPENT }

      it { expect(subject.color).to eq(SpentTag::RED) }
    end

    context "when variant is NEVER_SPENT" do
      let(:variant) { ResultsVariant::NEVER_SPENT }

      it { expect(subject.color).to eq(SpentTag::RED) }
    end

    context "when variant is SPENT_SIMPLE" do
      let(:variant) { ResultsVariant::SPENT_SIMPLE }

      it { expect(subject.color).to eq(SpentTag::GREEN) }
    end

    context "when variant is INDEFINITE" do
      let(:variant) { ResultsVariant::INDEFINITE }

      it { expect(subject.color).to eq(SpentTag::RED) }
    end
  end

  describe "#scope" do
    it { expect(subject.scope).to eq("results/spent_tag") }
  end
end
