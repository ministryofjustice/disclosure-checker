require 'rails_helper'

RSpec.describe Calculators::AdditionCalculator do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check,
                                 known_date: known_date,
                                 conviction_length: conviction_length,
                                 conviction_length_type: conviction_length_type) }

  let(:known_date) { Date.new(2018, 10, 31) }

  let(:conviction_length) { nil }
  let(:conviction_length_type) { nil }

  describe Calculators::AdditionCalculator::PlusZeroMonths do
    context '#expiry_date' do
      context 'without a conviction length' do
        it { expect(subject.expiry_date.to_s).to eq('2020-10-31') }
      end

      context 'with a conviction length' do
        let(:conviction_length) { 5 }
        let(:conviction_length_type) { 'years' }

        it { expect(subject.expiry_date.to_s).to eq('2023-10-31') }
      end
    end
  end

  describe Calculators::AdditionCalculator::PlusSixMonths do
    context '#expiry_date' do
      context 'without a conviction length' do
        it { expect(subject.expiry_date.to_s).to eq('2020-10-31') }
      end

      context 'with a conviction length' do
        let(:conviction_length) { 5 }
        let(:conviction_length_type) { 'years' }

        it { expect(subject.expiry_date.to_s).to eq('2024-04-30') }
      end
    end
  end

  describe Calculators::AdditionCalculator::StartPlusSixMonths do
    context '#expiry_date' do
      it { expect(subject.expiry_date.to_s).to eq('2019-04-30') }
    end
  end

  describe Calculators::AdditionCalculator::StartPlusTwelveMonths do
    context '#expiry_date' do
      it { expect(subject.expiry_date.to_s).to eq('2019-10-31') }
    end
  end
end
