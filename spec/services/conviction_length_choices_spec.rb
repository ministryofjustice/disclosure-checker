require 'rails_helper'

RSpec.describe ConvictionLengthChoices do
  subject { described_class.choices(conviction_subtype: conviction_subtype) }

  let(:all_choices) {
    [
      ConvictionLengthType::WEEKS,
      ConvictionLengthType::MONTHS,
      ConvictionLengthType::YEARS,
      ConvictionLengthType::INDEFINITE,
      ConvictionLengthType::NO_LENGTH,
    ]
  }

  let(:all_choices_except_no_length) {
    [
      ConvictionLengthType::WEEKS,
      ConvictionLengthType::MONTHS,
      ConvictionLengthType::YEARS,
    ]
  }

  describe 'SUBTYPES_HIDE_NO_LENGTH_CHOICE' do
    it {
      expect(
        described_class::SUBTYPES_HIDE_NO_LENGTH_CHOICE
      ).to eq([
        ConvictionType::DETENTION,
        ConvictionType::DETENTION_TRAINING_ORDER,
        ConvictionType::ADULT_PRISON_SENTENCE,
        ConvictionType::ADULT_SUSPENDED_PRISON_SENTENCE,
        ConvictionType::ADULT_ATTENDANCE_CENTRE_ORDER,
      ])
    }
  end

  # If this test fails it means we've added or removed convictions,
  # and we should double check if some of those convictions need to
  # be also added or removed to `SUBTYPES_HIDE_NO_LENGTH_CHOICE`.
  #
  describe 'smoke test to detect conviction mismatches' do
    let(:total) {
      ConvictionType.values.size - described_class::SUBTYPES_HIDE_NO_LENGTH_CHOICE.size
    }

    it { expect(total).to eq(54) }
  end

  describe '.choices' do
    context 'youth custodial sentence detention' do
      let(:conviction_subtype) { ConvictionType::DETENTION }

      it 'excludes `no_length` and `indefinite` in the choices' do
        expect(subject).to eq(all_choices_except_no_length)
      end
    end

    context 'youth custodial sentence detention training order' do
      let(:conviction_subtype) { ConvictionType::DETENTION_TRAINING_ORDER }

      it 'excludes `no_length` and `indefinite` in the choices' do
        expect(subject).to eq(all_choices_except_no_length)
      end
    end

    context 'adult custodial prison sentence' do
      let(:conviction_subtype) { ConvictionType::ADULT_PRISON_SENTENCE }

      it 'excludes `no_length` and `indefinite` in the choices' do
        expect(subject).to eq(all_choices_except_no_length)
      end
    end

    context 'adult custodial suspended prison sentence' do
      let(:conviction_subtype) { ConvictionType::ADULT_SUSPENDED_PRISON_SENTENCE }

      it 'excludes `no_length` and `indefinite` in the choices' do
        expect(subject).to eq(all_choices_except_no_length)
      end
    end

    # just a few, no need to test all of them
    #
    context 'youth prevention and reparation orders' do
      let(:conviction_subtype) { ConvictionType::SEXUAL_HARM_PREVENTION_ORDER }

      it 'includes `no_length` and `indefinite` in the choices' do
        expect(subject).to eq(all_choices)
      end
    end

    context 'bind over convictions' do
      let(:conviction_subtype) { ConvictionType::BIND_OVER }

      it 'includes `no_length` and `indefinite` in the choices' do
        expect(subject).to eq(all_choices)
      end
    end

    context 'adult bind over convictions' do
      let(:conviction_subtype) { ConvictionType::ADULT_BIND_OVER }

      it 'includes `no_length` and `indefinite` in the choices' do
        expect(subject).to eq(all_choices)
      end
    end
  end
end
