require 'rails_helper'

RSpec.describe ConvictionDecorator do
  context 'compensation?' do
    context 'for a conviction without compensation' do
      subject { ConvictionType::HOSPITAL_ORDER }
      it { expect(subject.compensation?).to eq(false) }
    end

    context 'for a conviction with compensation' do
      subject { ConvictionType::COMPENSATION_TO_A_VICTIM }
      it { expect(subject.compensation?).to eq(true) }
    end
  end

  describe '#custodial_sentence?' do
    context 'for a youth `CUSTODIAL_SENTENCE` conviction type' do
      subject { ConvictionType::CUSTODIAL_SENTENCE }
      it { expect(subject.custodial_sentence?).to eq(true) }
    end

    context 'for an adult `ADULT_CUSTODIAL_SENTENCE` conviction type' do
      subject { ConvictionType::ADULT_CUSTODIAL_SENTENCE }
      it { expect(subject.custodial_sentence?).to eq(true) }
    end

    context 'for a `DISCHARGE` conviction type' do
      subject { ConvictionType::DISCHARGE }
      it { expect(subject.custodial_sentence?).to eq(false) }
    end
  end

  describe '#motoring?' do
    context 'for a `ADULT_DISQUALIFICATION` conviction type' do
      subject { ConvictionType::ADULT_DISQUALIFICATION }
      it { expect(subject.motoring?).to eq(true) }
    end

    context 'for a `ADULT_MOTORING_FINE` conviction type' do
      subject { ConvictionType::ADULT_MOTORING_FINE }
      it { expect(subject.motoring?).to eq(true) }
    end

    context 'for a `ADULT_PENALTY_NOTICE` conviction type' do
      subject { ConvictionType::ADULT_PENALTY_NOTICE }
      it { expect(subject.motoring?).to eq(true) }
    end

    context 'for a `ADULT_PENALTY_POINTS` conviction type' do
      subject { ConvictionType::ADULT_PENALTY_POINTS }
      it { expect(subject.motoring?).to eq(true) }
    end

    context 'for a `DISCHARGE` conviction type' do
      subject { ConvictionType::DISCHARGE }
      it { expect(subject.custodial_sentence?).to eq(false) }
    end
  end
end
