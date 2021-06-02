require 'rails_helper'

RSpec.describe Calculators::DisqualificationCalculator do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check,
                                 under_age: under_age,
                                 known_date: known_date,
                                 conviction_length: conviction_length,
                                 conviction_length_type: conviction_length_type) }

  let(:known_date) { Date.new(2018, 10, 31) }
  let(:conviction_length) { nil }
  let(:conviction_length_type) { nil }

  describe Calculators::DisqualificationCalculator::Youths do
    let(:under_age) { GenericYesNo::YES }

    context '#expiry_date' do
      context 'with a length' do
        context 'less than or equal to 2.5 years' do
          let(:conviction_length) { 2 }
          let(:conviction_length_type) { 'years' }

          it { expect(subject.expiry_date.to_s).to eq((known_date + 30.months).to_s) }
        end

        context 'greater than 2.5 years' do
          let(:conviction_length) { 3 }
          let(:conviction_length_type) { 'years' }

          it { expect(subject.expiry_date.to_s).to eq((known_date + 36.months).to_s) }
        end
      end

      context 'without a length' do
        let(:conviction_length) { 'no_length' }
        it { expect(subject.expiry_date.to_s).to eq('2021-04-30') }
      end

      context 'with an indefinite length' do
        let(:conviction_length_type) { 'indefinite' }
        it { expect(subject.expiry_date).to eq(ResultsVariant::INDEFINITE) }
      end
    end
  end

  describe Calculators::DisqualificationCalculator::Adults do
    let(:under_age) { GenericYesNo::NO }

    context '#expiry_date' do
      context 'with a length' do
        context 'less than or equal to 5 years' do
          let(:conviction_length) { 4 }
          let(:conviction_length_type) { 'years' }

          it { expect(subject.expiry_date.to_s).to eq((known_date + 60.months).to_s) }
        end

        context 'greater than 5 years' do
          let(:conviction_length) { 6 }
          let(:conviction_length_type) { 'years' }

          it { expect(subject.expiry_date.to_s).to eq((known_date + 72.months).to_s) }
        end
      end

      context 'without a length' do
        let(:conviction_length) { 'no_length' }
        it { expect(subject.expiry_date.to_s).to eq('2023-10-31') }
      end

      context 'with an indefinite length' do
        let(:conviction_length_type) { 'indefinite' }
        it { expect(subject.expiry_date).to eq(ResultsVariant::INDEFINITE) }
      end
    end
  end
end
