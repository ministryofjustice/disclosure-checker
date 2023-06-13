require "rails_helper"

RSpec.describe DisclosureCheckerApp::Status do
  let(:status) do
    {
      service_status:,
      dependencies: {
        database_status:,
      },
    }
  end

  let(:check) { described_class.new }

  # Default is everything is fine
  let(:service_status) { "ok" }
  let(:database_status) { "ok" }

  describe "#service_status" do
    before do
      allow(subject).to receive(:database_status).and_return(database_status)
    end

    context 'when database_status is "ok"' do
      let(:database_status) { "ok" }

      it "returns ok" do
        expect(subject.send(:service_status)).to eq("ok")
      end
    end

    context 'when database_status is not "ok"' do
      let(:database_status) { "failed" }

      it "returns failed" do
        expect(subject.send(:service_status)).to eq("failed")
      end
    end
  end

  describe "#success?" do
    context "for a success result" do
      it "returns true" do
        expect(check.success?).to eq(true)
      end
    end
  end

  describe "#result" do
    context "database available" do
      before do
        expect(ActiveRecord::Base).to receive(:connection).and_call_original
      end

      specify { expect(check.result).to eq(status) }
    end

    context "database unavailable" do
      let(:service_status) { "failed" }
      let(:database_status) { "failed" }

      before do
        expect(ActiveRecord::Base).to receive(:connection).and_return(nil)
      end

      specify { expect(check.result).to eq(status) }
    end
  end
end
