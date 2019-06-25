require 'rails_helper'

RSpec.describe Calculators::ConvictionEndDateCalculator do
  subject { described_class.new(disclosure_check) }

  context '#expiry_date' do
    let(:disclosure_check) { build(:disclosure_check,
                                   known_date: known_date,
                                   conviction_length: conviction_length,
                                   conviction_length_type: conviction_length_type) }

    let(:known_date) { Date.new(2018, 10, 31) }
    let(:conviction_length) { 10 }

    context 'conviction length in months' do
      let(:conviction_length_type) { 'months' }

      it 'returns expiry date 10 months advance' do
        expect(subject.expiry_date.to_s).to eq(Date.new(2019, 8, 31).to_s)
      end
    end

    context 'conviction length in weeks' do
      let(:conviction_length_type) { 'weeks' }

      it 'returns expiry date 10 weeks advance' do
        expect(subject.expiry_date.to_s).to eq(Date.new(2019, 1, 9).to_s)
      end
    end

    context 'conviction length in years' do
      let(:conviction_length_type) { 'years' }

      it 'returns expiry date 10 years advance' do
        expect(subject.expiry_date.to_s).to eq(Date.new(2028, 10, 31).to_s)
      end
    end
  end
end
