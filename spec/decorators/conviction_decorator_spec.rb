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
    context 'for a youth custodial conviction type' do
      subject { ConvictionType::DETENTION_TRAINING_ORDER }
      it { expect(subject.custodial_sentence?).to eq(true) }
    end

    context 'for an adult custodial conviction type' do
      subject { ConvictionType::ADULT_PRISON_SENTENCE }
      it { expect(subject.custodial_sentence?).to eq(true) }
    end

    context 'for a non-custodial type' do
      subject { ConvictionType::ABSOLUTE_DISCHARGE }
      it { expect(subject.custodial_sentence?).to eq(false) }
    end
  end

  describe '#motoring?' do
    context 'for an adult motoring conviction type' do
      subject { ConvictionType::ADULT_DISQUALIFICATION }
      it { expect(subject.motoring?).to eq(true) }
    end

    context 'for a youth motoring conviction type' do
      subject { ConvictionType::YOUTH_DISQUALIFICATION }
      it { expect(subject.motoring?).to eq(true) }
    end

    context 'for a non-motoring conviction type' do
      subject { ConvictionType::ADULT_COMMUNITY_ORDER }
      it { expect(subject.motoring?).to eq(false) }
    end
  end

  describe '#motoring_fine?' do
    context 'for an adult `ADULT_MOTORING_FINE` conviction type' do
      subject { ConvictionType::ADULT_MOTORING_FINE }
      it { expect(subject.motoring_fine?).to eq(true) }
    end

    context 'for a youth `YOUTH_MOTORING_FINE` conviction type' do
      subject { ConvictionType::YOUTH_MOTORING_FINE }
      it { expect(subject.motoring_fine?).to eq(true) }
    end
  end

  describe '#bailable_offense?' do
    context 'for a youth `DETENTION` conviction type' do
      subject { ConvictionType::DETENTION }
      it { expect(subject.bailable_offense?).to eq(true) }
    end

    context 'for a youth `DETENTION_TRAINING_ORDER` conviction type' do
      subject { ConvictionType::DETENTION_TRAINING_ORDER }
      it { expect(subject.bailable_offense?).to eq(true) }
    end

    context 'for a youth `HOSPITAL_ORDER` conviction type' do
      subject { ConvictionType::HOSPITAL_ORDER }
      it { expect(subject.bailable_offense?).to eq(false) }
    end

    context 'for an `ADULT_PRISON_SENTENCE` conviction type' do
      subject { ConvictionType::ADULT_PRISON_SENTENCE }
      it { expect(subject.bailable_offense?).to eq(true) }
    end

    context 'for an `ADULT_SUSPENDED_PRISON_SENTENCE` conviction type' do
      subject { ConvictionType::ADULT_SUSPENDED_PRISON_SENTENCE }
      it { expect(subject.bailable_offense?).to eq(true) }
    end

    context 'for an `ADULT_HOSPITAL_ORDER` conviction type' do
      subject { ConvictionType::ADULT_HOSPITAL_ORDER }
      it { expect(subject.bailable_offense?).to eq(false) }
    end
  end
end
