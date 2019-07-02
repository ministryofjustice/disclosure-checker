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
      let(:result) { Date.new(2019, 4, 30)}

      it 'returns caution date plus 3 months' do
        expect(subject.expiry_date.to_s).to eq(result.to_s)
      end
    end

  end
end
