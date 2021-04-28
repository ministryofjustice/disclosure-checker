require 'rails_helper'

RSpec.describe Calculators::Motoring::Youth::PenaltyNotice do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check,
                                 under_age: under_age,
                                 known_date: known_date,
                                 motoring_endorsement: GenericYesNo::YES) }

  let(:under_age) { GenericYesNo::YES }
  let(:known_date) { Date.new(2020, 1, 1) }

  describe '#expiry_date' do
    it { expect(subject.expiry_date.to_s).to eq('2022-07-01') }
  end
end
