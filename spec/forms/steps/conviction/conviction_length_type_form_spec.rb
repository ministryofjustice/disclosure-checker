require 'spec_helper'

RSpec.describe Steps::Conviction::ConvictionLengthTypeForm do
  let(:arguments) { {
    disclosure_check: disclosure_check,
    conviction_length_type: conviction_length_type
  } }
  let(:disclosure_check) { instance_double(DisclosureCheck) }
  let(:conviction_length_type) { 'weeks' }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        weeks
        months
        years
      ))
    end
  end

  describe '#save' do
    context 'when form is valid' do
      let(:conviction_length_type) { 'weeks' }
      it_behaves_like 'a value object form', attribute_name: :conviction_length_type, example_value: 'weeks'

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          conviction_length_type: conviction_length_type
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end

    context 'Validation' do
      context 'when conviction_length_type is not given' do
        let(:conviction_length_type) { nil }

        it 'returns false' do
          expect(subject.save).to be(false)
        end

        it 'has a validation error on the field' do
          expect(subject).to_not be_valid
          expect(subject.errors.include?(:conviction_length_type)).to eq(true)
        end
      end
    end
  end
end
