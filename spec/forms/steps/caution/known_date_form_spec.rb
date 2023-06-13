require "spec_helper"

RSpec.describe Steps::Caution::KnownDateForm do
  it_behaves_like "a date question form", attribute_name: :known_date do
    before do
      allow(subject).to receive(:before_conditional_date?).and_return(true)
    end
  end

  describe "#before_conditional_date? validation" do
    subject { described_class.new(arguments) }

    let(:disclosure_check) { instance_double(DisclosureCheck, conditional_end_date:) }
    let(:known_date) { nil }
    let(:conditional_end_date) { Date.today }
    let(:arguments) do
      {
        disclosure_check:,
        known_date:,
      }
    end

    context "when caution date is after conditional end date" do
      let(:known_date) { Date.tomorrow }

      it "returns false" do
        expect(subject.save).to be(false)
      end

      it "has a validation error on the field" do
        expect(subject).not_to be_valid
        expect(subject.errors.added?(:known_date, :before_conditional_date)).to eq(true)
      end
    end

    context "when caution date is before conditional end date" do
      let(:known_date) { Date.yesterday }

      it "has no validation errors on the field" do
        expect(subject).to be_valid
        expect(subject.errors.added?(:known_date, :before_conditional_date)).to eq(false)
      end
    end
  end
end
