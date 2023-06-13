require "rails_helper"

RSpec.describe Calculators::Motoring::Adult::PenaltyNotice do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) do
    build(:disclosure_check,
          under_age:,
          known_date:,
          motoring_endorsement: GenericYesNo::YES)
  end

  let(:under_age) { GenericYesNo::NO }
  let(:known_date) { Date.new(2018, 10, 31) }

  describe "#expiry_date" do
    it { expect(subject.expiry_date.to_s).to eq("2023-10-31") }
  end
end
