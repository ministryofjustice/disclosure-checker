require 'rails_helper'

RSpec.describe Calculators::ImmediatelyCalculator do
  subject { described_class.new(disclosure_check) }

  context '#expiry_date' do
    let(:disclosure_check) { build(:disclosure_check,
                                   known_date: known_date) }

    let(:known_date) { Date.new(2018, 10, 31) }

    it 'returns conviction start date as conviction is spent immediately' do
      expect(subject.expiry_date.to_s).to eq(known_date.to_s)
    end
  end
end
