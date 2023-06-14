require "rails_helper"

RSpec.describe CheckResult do
  subject(:check_result) { described_class.new(disclosure_check:) }

  let(:disclosure_check) do
    build(:disclosure_check, kind,
          known_date: Date.new(2018, 10, 31))
  end

  describe "#expiry_date" do
    context "when a caution" do
      let(:kind) { :adult_caution }

      it "will call method on a calculator" do
        expect(check_result.calculator).to receive(:expiry_date)
        check_result.expiry_date
      end

      it { expect(check_result.calculator).to be_an_instance_of(Calculators::CautionCalculator) }
    end

    context "when a conviction" do
      let(:kind) { :dto_conviction }

      it "will call method on a calculator" do
        expect(check_result.calculator).to receive(:expiry_date)
        check_result.expiry_date
      end

      it { expect(check_result.calculator).to be_an_instance_of(Calculators::SentenceCalculator::DetentionTraining) }
    end

    context "when an unknown `kind`" do
      let(:disclosure_check) { DisclosureCheck.new(kind: "foobar") }

      it "raises an exception" do
        expect { check_result.calculator }.to raise_error(RuntimeError)
      end
    end
  end
end
