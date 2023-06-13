require "rails_helper"

RSpec.describe MultiParamDate do
  subject { described_class.build(described_class) }

  let(:coerced_value) { subject.coerce(value) }

  describe "when value is already a date" do
    let(:value) { Date.yesterday }

    it { expect(coerced_value).to eq(value) }
  end

  describe "when value is `nil`" do
    let(:value) { nil }

    it { expect(coerced_value).to be_nil }
  end

  describe "when value is an array" do
    let(:date) { Date.new(2008, 11, 22) }

    context "and contains all needed parts" do
      let(:value) { [nil, date.year, date.month, date.day] }

      it { expect(coerced_value).to eq(date) }
    end

    context "the parts do not represent a valid date (invalid month)" do
      let(:value) { [nil, date.year, 13, date.day] }

      it { expect(coerced_value).to be_nil }
    end

    context "the parts do not represent a valid date (invalid day)" do
      let(:value) { [nil, date.year, date.month, 32] }

      it { expect(coerced_value).to be_nil }
    end

    context "any part is missing (zero)" do
      let(:value) { [nil, date.year, 0, date.day] }

      it { expect(coerced_value).to be_nil }
    end

    context "any part is missing (nil)" do
      let(:value) { [nil, date.year, date.month, nil] }

      it { expect(coerced_value).to be_nil }
    end
  end
end
