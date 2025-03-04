require "rails_helper"

RSpec.describe GenericYesNo do
  subject(:generic_yes_no) { described_class.new(value) }

  let(:value) { :foo }

  describe ".values" do
    it "returns all possible values" do
      expect(described_class.values.map(&:to_s)).to eq(%w[yes no])
    end
  end

  describe "#yes?" do
    context "when value is `yes`" do
      let(:value) { :yes }

      it { expect(generic_yes_no.yes?).to be(true) }
    end

    context "when value is not `yes`" do
      let(:value) { :no }

      it { expect(generic_yes_no.yes?).to be(false) }
    end
  end

  describe "#no?" do
    context "when value is `no`" do
      let(:value) { :no }

      it { expect(generic_yes_no.no?).to be(true) }
    end

    context "when value is not `no`" do
      let(:value) { :yes }

      it { expect(generic_yes_no.no?).to be(false) }
    end
  end
end
