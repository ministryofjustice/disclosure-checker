require "rails_helper"

RSpec.describe Calculators::Motoring::Adult::PenaltyPoints do
  subject(:calculator) { described_class.new(disclosure_check) }

  let(:disclosure_check) do
    build(:disclosure_check,
          under_age:,
          known_date:)
  end

  let(:under_age) { GenericYesNo::NO }
  let(:known_date) { Date.new(2018, 10, 31) }

  describe "#expiry_date" do
    context "with a motoring endorsement" do
      it { expect(calculator.expiry_date.to_s).to eq("2023-10-31") }
    end
  end
end
