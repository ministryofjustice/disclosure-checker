require "rails_helper"

RSpec.describe YesNo do
  subject { described_class.build(described_class) }

  let(:coerced_value) { subject.coerce(value) }

  describe "when value is `nil`" do
    let(:value) { nil }

    it { expect(coerced_value).to be_nil }
  end

  describe "when value is a symbol" do
    let(:value) { :yes }

    it { expect(coerced_value).to eq(GenericYesNo::YES) }
  end

  describe "when value is a string" do
    let(:value) { "yes" }

    it { expect(coerced_value).to eq(GenericYesNo::YES) }
  end

  describe "when value is already a value-object" do
    let(:value) { GenericYesNo::YES }

    it { expect(coerced_value).to eq(GenericYesNo::YES) }
  end
end
