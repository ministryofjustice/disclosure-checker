require 'rails_helper'

RSpec.describe Calculators::FineCalculator do
  subject { described_class.new(disclosure_check) }

  context '#expiry_date' do
    let(:disclosure_check) { build(:disclosure_check,
                                   known_date: known_date,
                                   conviction_length: conviction_length,
                                   conviction_length_type: conviction_length_type) }

    let(:known_date) { Date.new(2016, 6, 20) }
    let(:conviction_length) { 5 }

    let(:result) { Date.new(2016, 12, 20) }

    context 'conviction length in months' do
      let(:conviction_length_type) { 'months' }
      it { expect(subject.expiry_date.to_s).to eq(result.to_s) }
    end

    context 'conviction length in years' do
      let(:conviction_length_type) { 'years' }
      it { expect(subject.expiry_date.to_s).to eq(result.to_s) }
    end

    context 'conviction length in weeks' do
      let(:conviction_length_type) { 'weeks' }
      it { expect(subject.expiry_date.to_s).to eq(result.to_s) }
    end
  end
end
