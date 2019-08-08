require 'spec_helper'

RSpec.describe Steps::Conviction::ConvictionLengthForm do
  let(:arguments) { {
    disclosure_check: disclosure_check,
    conviction_length: conviction_length
  } }
  let(:disclosure_check) { instance_double(DisclosureCheck, conviction_length_type: 'months') }
  let(:conviction_length) { '3' }

  subject { described_class.new(arguments) }

  describe '#conviction_length_type' do
    it 'delegates to `disclosure_checker`' do
      expect(disclosure_check).to receive(:conviction_length_type)
      expect(subject.conviction_length_type).to eq('months')
    end
  end

  describe '#save' do
    context 'when form is valid' do

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          conviction_length: conviction_length
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end

    context 'Validation' do
      context 'when conviction_length is invalid' do
        let(:conviction_length) { 'sss' }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors.include?(:conviction_length)).to eq(true)
        end
      end
    end
  end
end
