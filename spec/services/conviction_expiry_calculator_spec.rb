require 'rails_helper'

RSpec.describe ConvictionExpiryCalculator do
  subject { described_class.new(disclosure_check: disclosure_check, ) }

  context '#expiry_date' do
    let(:disclosure_check) { build(:disclosure_check, :conviction,
                                   conviction_subtype: conviction_subtype,
                                   known_date: known_date,
                                   conviction_length: conviction_length,
                                   conviction_length_type: conviction_length_type) }

    let(:expiry_date) { subject.expiry_date }
    let(:known_date) { nil }
    let(:conviction_length) { nil }
    let(:conviction_length_type) { nil }
    let(:conviction_subtype) { nil }


    context 'TBD' do
      let (:conviction_subtype) { 'absolute_discharge' }
      it 'is not yet implemented' do
        expect(expiry_date).to eq('TBD')
      end
    end

    context 'Rehabilitation finishes at the end of conviction period' do
      let(:conviction_subtype) { 'hospital_order' }
      let(:known_date) { Date.new(2018, 10, 31) }
      let(:conviction_length) { 10 }
      let(:conviction_length_type) { 'months' }

      it 'is not yet implemented' do
        expect(expiry_date.to_s).to eq('2019-08-31')
      end
    end
  end
end
