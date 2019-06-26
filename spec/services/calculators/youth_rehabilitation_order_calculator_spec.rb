require 'rails_helper'

RSpec.describe Calculators::YouthRehabilitationOrderCalculator do
  subject { described_class.new(disclosure_check) }

  context '#expiry_date' do
    let(:disclosure_check) { build(:disclosure_check,
                                   known_date: known_date,
                                   conviction_length: conviction_length,
                                   conviction_length_type: conviction_length_type) }

    let(:known_date) { Date.new(2018, 10, 31) }
    let(:conviction_length) { nil }
    let(:conviction_length_type) { nil }

    context 'without a conviction length' do
      it { expect(subject.expiry_date.to_s).to eq('2020-10-31') }
    end

    context 'with a conviction length' do
      let(:conviction_length) { 10 }

      context 'conviction length in months' do
        let(:conviction_length_type) { 'months' }

        it { expect(subject.expiry_date.to_s).to eq('2020-02-29') }
      end

      context 'conviction length in weeks' do
        let(:conviction_length_type) { 'weeks' }

        it { expect(subject.expiry_date.to_s).to eq('2019-07-09') }
      end

      context 'conviction length in years' do
        let(:conviction_length_type) { 'years' }

        it { expect(subject.expiry_date.to_s).to eq('2029-04-30') }
      end
    end
  end
end
