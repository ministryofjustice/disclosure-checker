require 'rails_helper'

RSpec.describe Calculators::ConditionalCautionCalculator do
  subject { described_class.new(disclosure_check) }
   context '#expiry_date' do
    let(:disclosure_check) { build(:disclosure_check,
                                   known_date: known_date,
                                   conditional_end_date: conditional_end_date) }

    let(:known_date) { Date.new(2019, 1, 31) }
    let(:conditional_end_date) { nil }

    context 'Difference between conditional end date and caution date less than 3 months' do
      let(:conditional_end_date) { Date.new(2019, 3, 30) }

      it 'returns conditional end date' do
        expect(subject.expiry_date.to_s).to eq(conditional_end_date.to_s)
      end
    end

    context 'Difference between conditional end date and caution date greater than 3 months' do
      let(:conditional_end_date) { Date.new(2019, 5, 30) }
      let(:result) { Date.new(2019, 4, 30) }

      it 'returns caution date plus 3 months' do
        expect(subject.expiry_date.to_s).to eq(result.to_s)
      end
    end

    context 'Difference between conditional end date and caution date is 2 months x days' do
      let(:known_date) { Date.new(2001, 12, 4) }
      let(:conditional_end_date) { Date.new(2002, 3, 3) }

      it 'returns conditional end date' do
        expect(subject.expiry_date.to_s).to eq(conditional_end_date.to_s)
      end
    end

    context 'Leap year' do
      context 'Difference between conditional end date and caution date less than 3 months' do
        let(:known_date) { Date.new(2004, 2, 29) }
        let(:conditional_end_date) { Date.new(2004, 5, 28) }

        it 'returns conditional end date' do
          expect(subject.expiry_date.to_s).to eq(conditional_end_date.to_s)
        end
      end

      context 'Difference between conditional end date and caution date greater than 3 months' do
        let(:known_date) { Date.new(2004, 2, 29) }
        let(:conditional_end_date) { Date.new(2004, 6, 13) }
        let(:result) { Date.new(2004, 5, 29) }

        it 'returns caution date plus 3 months' do
          expect(subject.expiry_date.to_s).to eq(result.to_s)
        end
      end
    end

    context 'Future date' do
      let(:known_date) { Date.new(2019, 7, 13) }

      context 'Difference between conditional end date and caution date less than 3 months' do
          let(:conditional_end_date) { Date.new(2019, 9, 11) }
        let(:result) { Date.new(2004, 5, 29) }
        it 'returns conditional end date' do
          expect(subject.expiry_date.to_s).to eq(conditional_end_date.to_s)
        end
      end

      context 'Difference between conditional end date and caution date greater than 3 months' do
        let(:conditional_end_date) { Date.new(2019, 11, 11) }
        let(:result) { Date.new(2019, 10, 13) }

        it 'returns caution date plus 3 months' do
          expect(subject.expiry_date.to_s).to eq(result.to_s)
        end
      end
    end
  end
end
