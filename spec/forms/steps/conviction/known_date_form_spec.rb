require "spec_helper"

RSpec.describe Steps::Conviction::KnownDateForm do
  it_behaves_like "a date question form", attribute_name: :known_date do
    before do
      allow(subject).to receive(:after_conviction_date?).and_return(true)
    end
  end

  describe "#i18n_attribute" do
    before do
      allow(subject).to receive(:conviction_subtype).and_return(:foobar)
    end

    it "returns the key that will be used to translate legends and hints" do
      expect(subject.i18n_attribute).to eq(:foobar)
    end
  end

  describe "#after_conviction_date? validation" do
    subject { described_class.new(arguments) }

    let(:disclosure_check) { instance_double(DisclosureCheck, conviction_date:, known_date:) }
    let(:known_date) { nil }
    let(:conviction_date) { nil }
    let(:arguments) do
      {
        disclosure_check:,
        known_date:,
      }
    end

    context "when `known_date` is before the conviction date" do
      let(:conviction_date) { Date.today }
      let(:known_date) { Date.yesterday }

      it "returns false" do
        expect(subject.save).to be(false)
      end

      it "has a validation error on the field" do
        expect(subject).not_to be_valid
        expect(subject.errors.added?(:known_date, :after_conviction_date)).to eq(true)
      end
    end

    context "when `known_date` is after the conviction date" do
      let(:conviction_date) { Date.current - 3.days }
      let(:known_date) { Date.current - 1.day }

      it "has no validation errors on the field" do
        expect(subject).to be_valid
        expect(subject.errors.added?(:known_date, :after_conviction_date)).to eq(false)
      end
    end

    context "when `conviction_date` is `nil`" do
      let(:conviction_date) { nil }
      let(:known_date) { Date.current }

      it "has no validation errors on the field" do
        expect(subject).to be_valid
        expect(subject.errors.added?(:known_date, :after_conviction_date)).to eq(false)
      end
    end

    context "when `known_date` is `nil`" do
      let(:conviction_date) { Date.current }
      let(:known_date) { nil }

      it "has a presence error" do
        expect(subject).not_to be_valid
        expect(subject.errors.added?(:known_date, :after_conviction_date)).to eq(false)
        expect(subject.errors.added?(:known_date, :blank)).to eq(true)
      end
    end
  end
end
