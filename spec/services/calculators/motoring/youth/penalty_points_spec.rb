require "rails_helper"

RSpec.describe Calculators::Motoring::Youth::PenaltyPoints do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) do
    build(:disclosure_check,
          under_age:,
          known_date:)
  end

  let(:under_age) { GenericYesNo::YES }
  let(:known_date) { Date.new(2018, 10, 31) }

  describe "#expiry_date" do
    context "with a motoring endorsement" do
      it { expect(subject.expiry_date.to_s).to eq((known_date + 36.months).to_s) }
    end
  end
end
