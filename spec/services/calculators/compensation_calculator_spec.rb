require "rails_helper"

RSpec.describe Calculators::CompensationCalculator do
  subject(:calculator) { described_class.new(disclosure_check) }

  describe "#expiry_date" do
    let(:disclosure_check) do
      build(:disclosure_check,
            known_date:,
            compensation_payment_date:)
    end

    let(:known_date) { Date.new(2018, 10, 31) }
    let(:compensation_payment_date) { Date.new(2019, 4, 30) }

    it "returns compensation payment date" do
      expect(calculator.expiry_date.to_s).to eq(compensation_payment_date.to_s)
    end
  end
end
