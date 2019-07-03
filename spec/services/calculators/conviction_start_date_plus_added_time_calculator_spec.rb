require 'rails_helper'

RSpec.describe Calculators::ConvictionStartDatePlusAddedTimeCalculator do
  subject { described_class.new(disclosure_check) }
   context '#expiry_date' do
    let(:disclosure_check) { build(:disclosure_check,
                                   known_date: known_date) }

    let(:known_date) { Date.new(2018, 10, 31) }
    let(:result) { Date.new(2019, 4, 30) }


    it 'returns conviction start date plus spent time months' do
      expect(subject.expiry_date.to_s).to eq(result.to_s)
    end
  end
end
