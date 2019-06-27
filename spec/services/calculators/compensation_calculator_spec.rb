require 'rails_helper'

RSpec.describe Calculators::CompensationCalculator do
  subject { described_class.new(disclosure_check) }
   context '#expiry_date' do
    let(:disclosure_check) { build(:disclosure_check,
                                   known_date: known_date,
                                   compensation_payment_date: compensation_payment_date) }

    let(:known_date) { Date.new(2018, 10, 31) }
    let(:compensation_payment_date) { Date.new(2019, 4, 30) }

    it 'returns compensation payment date' do
      expect(subject.expiry_date.to_s).to eq(compensation_payment_date.to_s)
    end
  end
end
