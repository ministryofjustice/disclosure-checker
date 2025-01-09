require "rails_helper"

RSpec.describe DisclosureReport, type: :model do
  subject(:report) { described_class.new(attributes) }

  let(:attributes) { {} }

  describe ".purge!" do
    let(:finder_double) { double.as_null_object }

    before do
      travel_to Time.zone.now
    end

    it "picks records equal to or older than the passed-in date" do
      expect(described_class).to receive(:where).with(
        "created_at <= :date", date: 28.days.ago
      ).and_call_original

      described_class.purge!(28.days.ago)
    end

    it "calls #destroy_all on the records it finds" do
      allow(described_class).to receive(:where).and_return(finder_double)
      expect(finder_double).to receive(:destroy_all)

      described_class.purge!(28.days.ago)
    end
  end

  describe "#completed!" do
    before do
      travel_to Time.zone.at(123)
    end

    it "marks the application as completed" do
      # rubocop:disable RSpec/SubjectStub
      expect(
        report,
      ).to receive(:update!).with(
        status: :completed, completed_at: Time.zone.at(123),
      )
      # rubocop:enable RSpec/SubjectStub

      report.completed!
    end
  end

  describe "#disclosure_checks_count" do
    let(:collection_scope) { instance_double("collection") } # rubocop:disable RSpec/VerifiedDoubleReference

    before do
      allow(report).to receive(:disclosure_checks).and_return(collection_scope) # rubocop:disable RSpec/SubjectStub
    end

    it "returns the count of records" do
      expect(collection_scope).to receive(:count)
      report.disclosure_checks_count
    end
  end

  context "when convenience query methods" do
    let(:collection_scope) { instance_double("collection") } # rubocop:disable RSpec/VerifiedDoubleReference

    before do
      allow(report).to receive(:disclosure_checks).and_return(collection_scope) # rubocop:disable RSpec/SubjectStub
    end

    describe "#caution_checks" do
      it "filters by kind caution" do
        expect(collection_scope).to receive(:where).with(kind: "caution")
        report.caution_checks
      end
    end

    describe "#conviction_checks" do
      it "filters by kind conviction" do
        expect(collection_scope).to receive(:where).with(kind: "conviction")
        report.conviction_checks
      end
    end
  end
end
