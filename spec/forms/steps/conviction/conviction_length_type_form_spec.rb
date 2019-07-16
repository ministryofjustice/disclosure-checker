require 'spec_helper'

RSpec.describe Steps::Conviction::ConvictionLengthTypeForm do
  let(:arguments) { {
    disclosure_check: disclosure_check,
    conviction_length_type: conviction_length_type
  } }

  let(:disclosure_check) { instance_double(DisclosureCheck, conviction_type: conviction_type, conviction_subtype: conviction_subtype, conviction_length_type: nil) }
  let(:conviction_type) { ConvictionType::COMMUNITY_ORDER.to_s }
  let(:conviction_subtype) { ConvictionType::CONDITIONAL_DISCHARGE.to_s }
  let(:conviction_length_type) { 'weeks' }

  subject { described_class.new(arguments) }

  describe '#choices' do
    context 'for a community order' do
      it 'the choices include `no_length`' do
        expect(subject.choices).to eq(%w(
          weeks
          months
          years
          no_length
        ))
      end
    end

    context 'for a hospital order' do
      let(:conviction_type) { ConvictionType::CUSTODIAL_SENTENCE.to_s }
      let(:conviction_subtype) { ConvictionType::HOSPITAL_ORDER.to_s }
      it 'the choices include `no_length`' do
        expect(subject.choices).to eq(%w(
          weeks
          months
          years
          no_length
        ))
      end
    end

    context 'for an order, other than community order' do
      let(:conviction_type) { ConvictionType::DISCHARGE.to_s }

      it 'the choices does not include `no_length`' do
        expect(subject.choices).to eq(%w(
          weeks
          months
          years
        ))
      end
    end
  end

  describe '#save' do
    context 'when form is valid' do
      let(:conviction_length_type) { 'weeks' }
      it_behaves_like 'a value object form', attribute_name: :conviction_length_type, example_value: 'weeks'

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          conviction_length_type: conviction_length_type,
          # Dependent attributes to be reset
          conviction_length: nil
        ).and_return(true)

        expect(subject.save).to be(true)
      end

      context 'when conviction_subtype is already the same on the model' do
        let(:disclosure_check) {
          instance_double(DisclosureCheck, conviction_type: conviction_type, conviction_length_type: conviction_length_type)
        }
        let(:conviction_length_type) { 'months' }

        it 'does not save the record but returns true' do
          expect(disclosure_check).to_not receive(:update)
          expect(subject.save).to be(true)
        end
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
