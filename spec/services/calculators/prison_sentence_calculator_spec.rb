require 'rails_helper'

RSpec.describe Calculators::PrisonSentenceCalculator do
  subject { described_class.new(disclosure_check) }

  context '#expiry_date' do
    let(:disclosure_check) { build(:disclosure_check,
                                   known_date: known_date,
                                   conviction_length: conviction_length,
                                   conviction_length_type: conviction_length_type) }

    let(:known_date) { Date.new(2016, 10, 20) }
    let(:conviction_length) { nil }

    context 'never spent for conviction length over 4 years' do
      let(:result) { false }
      context 'conviction length in weeks' do
        let(:conviction_length_type) { 'weeks' }
        let(:conviction_length) { 212 }
        it { expect(subject.expiry_date).to eq(result) }
      end

      context 'conviction length in months' do
        let(:conviction_length_type) { 'months' }
        let(:conviction_length) { 49 }
        it { expect(subject.expiry_date).to eq(result) }
      end

      context 'conviction length in years' do
        let(:conviction_length_type) { 'years' }
        let(:conviction_length) { 5 }
        it { expect(subject.expiry_date).to eq(result) }
      end
    end

    context 'Spent duration for conviction length of 6 months or less' do
      context 'conviction length in weeks' do
        let(:conviction_length_type) { 'weeks' }
        let(:conviction_length) { 27 }
        it { expect(subject.expiry_date.to_s).to eq('2019-04-27') }
      end

      context 'conviction length in months' do
        let(:conviction_length_type) { 'months' }
        let(:conviction_length) { 5 }
        it { expect(subject.expiry_date.to_s).to eq('2019-03-20') }
      end

      context 'conviction length in years' do
        let(:conviction_length_type) { 'years' }
        let(:conviction_length) { 0 }
        it { expect(subject.expiry_date.to_s).to eq('2018-10-20') }
      end
    end

    context 'Spent duration for conviction length of 7 to 30 months' do
      context 'conviction length in weeks' do
        let(:conviction_length_type) { 'weeks' }
        let(:conviction_length) { 29 }
        it { expect(subject.expiry_date.to_s).to eq('2021-05-11') }
      end

      context 'conviction length in months' do
        let(:conviction_length_type) { 'months' }
        let(:conviction_length) { 29 }
        it { expect(subject.expiry_date.to_s).to eq('2023-03-20') }
      end

      context 'conviction length in years' do
        let(:conviction_length_type) { 'years' }
        let(:conviction_length) { 2 }
        it { expect(subject.expiry_date.to_s).to eq('2022-10-20') }
      end
    end

    context 'Spent duration for conviction length of over 30 months and up to 4 years' do
      context 'conviction length in weeks' do
        let(:conviction_length_type) { 'weeks' }
        let(:conviction_length) { 190 }
        it { expect(subject.expiry_date.to_s).to eq('2027-06-11') }
      end

      context 'conviction length in months' do
        let(:conviction_length_type) { 'months' }
        let(:conviction_length) { 48 }
        it { expect(subject.expiry_date.to_s).to eq('2027-10-20') }
      end

      context 'conviction length in years' do
        let(:conviction_length_type) { 'years' }
        let(:conviction_length) { 4 }
        it { expect(subject.expiry_date.to_s).to eq('2027-10-20') }
      end
    end
  end
end

