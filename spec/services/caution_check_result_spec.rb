require 'rails_helper'

RSpec.describe CautionCheckResult do
  subject { described_class.new(disclosure_check: disclosure_check) }

  context '#expiry_date' do
    let(:expiry_date) { subject.expiry_date }

    context 'for a simple caution' do
      let(:disclosure_check) { build(:disclosure_check) }

      it 'returns `known_date` (end date is the date of the caution)' do
        expect(expiry_date).to eq(disclosure_check.known_date)
      end

      context 'unknown caution date' do
        let(:disclosure_check) { build(:disclosure_check, known_date: nil) }

        it 'return false' do
          expect(expiry_date).to eql(false)
        end
      end
    end

    context 'for a conditional caution' do
      let(:disclosure_check) { build(:disclosure_check, :conditional_caution) }

      it 'returns `conditional_end_date` (end date is the conditional date)' do
        expect(expiry_date).to eq(disclosure_check.conditional_end_date)
      end
    end
  end
end
