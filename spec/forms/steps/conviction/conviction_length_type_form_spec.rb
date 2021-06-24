require 'spec_helper'

RSpec.describe Steps::Conviction::ConvictionLengthTypeForm do
  let(:arguments) { {
    disclosure_check: disclosure_check,
    conviction_length_type: conviction_length_type
  } }

  let(:disclosure_check) { instance_double(DisclosureCheck, conviction_type: conviction_type, conviction_subtype: conviction_subtype, conviction_length_type: nil) }
  let(:conviction_type) { ConvictionType::REFERRAL_SUPERVISION_YRO.to_s }
  let(:conviction_subtype) { ConvictionType::YOUTH_REHABILITATION_ORDER.to_s }
  let(:conviction_length_type) { 'weeks' }

  subject { described_class.new(arguments) }

  describe '#i18n_attribute' do
    it 'returns the key that will be used to translate legends and hints' do
      expect(subject.i18n_attribute).to eq(ConvictionType.new(:youth_rehabilitation_order))
    end
  end

  # Note: no need to test all combinations here, we do that already in
  # the spec `spec/services/conviction_length_choices_spec.rb`
  #
  describe '#values' do
    context 'for a `Youth rehabilitation order`' do
      it 'includes `no_length` in the values' do
        expect(ConvictionLengthChoices).to receive(:choices).with(
          conviction_subtype: ConvictionType::YOUTH_REHABILITATION_ORDER
        ).and_call_original

        expect(subject.values).to eq(
          [
            ConvictionLengthType.new(:days),
            ConvictionLengthType.new(:weeks),
            ConvictionLengthType.new(:months),
            ConvictionLengthType.new(:years),
            ConvictionLengthType.new(:no_length)
          ]
        )
      end
    end

    context 'for a `Youth referral order`' do
      let(:conviction_subtype) { ConvictionType::REFERRAL_ORDER.to_s }

      it 'includes `no_length` and `indefinite` in the values' do
        expect(ConvictionLengthChoices).to receive(:choices).with(
          conviction_subtype: ConvictionType::REFERRAL_ORDER
        ).and_call_original

        expect(subject.values).to eq(
          [

            ConvictionLengthType.new(:days),
            ConvictionLengthType.new(:weeks),
            ConvictionLengthType.new(:months),
            ConvictionLengthType.new(:years),
            ConvictionLengthType.new(:indefinite),
            ConvictionLengthType.new(:no_length),
          ]
        )
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

      context 'when conviction_length_type is already the same on the model' do
        let(:disclosure_check) {
          instance_double(
            DisclosureCheck,
            conviction_type: conviction_type,
            conviction_subtype: conviction_subtype,
            conviction_length_type: conviction_length_type
          )
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
