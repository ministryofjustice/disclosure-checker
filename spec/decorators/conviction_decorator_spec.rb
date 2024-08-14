require "rails_helper"

RSpec.describe ConvictionDecorator do
  describe "youth?" do
    context "when a youth conviction" do
      subject { ConvictionType::YOUTH_REHABILITATION_ORDER.youth? }

      it { is_expected.to be(true) }
    end

    context "when an adult conviction" do
      subject { ConvictionType::ADULT_ABSOLUTE_DISCHARGE.youth? }

      it { is_expected.to be(false) }
    end
  end

  describe "adult?" do
    context "when a youth conviction" do
      subject { ConvictionType::YOUTH_REHABILITATION_ORDER.adult? }

      it { is_expected.to be(false) }
    end

    context "when an adult conviction" do
      subject(:decorator) { ConvictionType::ADULT_ABSOLUTE_DISCHARGE.adult? }

      it { is_expected.to be(true) }
    end
  end

  describe "compensation?" do
    context "when a conviction without compensation" do
      subject { ConvictionType::HOSPITAL_ORDER.compensation? }

      it { is_expected.to be(false) }
    end

    context "when a conviction with compensation" do
      subject { ConvictionType::COMPENSATION_TO_A_VICTIM.compensation? }

      it { is_expected.to be(true) }
    end
  end

  describe "#custodial_sentence?" do
    context "when a youth custodial conviction type" do
      subject { ConvictionType::DETENTION_TRAINING_ORDER.custodial_sentence? }

      it { is_expected.to be(true) }
    end

    context "when an adult custodial conviction type" do
      subject { ConvictionType::ADULT_PRISON_SENTENCE.custodial_sentence? }

      it { is_expected.to be(true) }
    end

    context "when a non-custodial type" do
      subject { ConvictionType::ABSOLUTE_DISCHARGE.custodial_sentence? }

      it { is_expected.to be(false) }
    end
  end

  describe "#motoring?" do
    context "when an adult motoring conviction type" do
      subject { ConvictionType::ADULT_DISQUALIFICATION.motoring? }

      it { is_expected.to be(true) }
    end

    context "when a youth motoring conviction type" do
      subject { ConvictionType::YOUTH_DISQUALIFICATION.motoring? }

      it { is_expected.to be(true) }
    end

    context "when a non-motoring conviction type" do
      subject { ConvictionType::ADULT_COMMUNITY_ORDER.motoring? }

      it { is_expected.to be(false) }
    end
  end

  describe "#motoring_fine?" do
    context "when an adult `ADULT_MOTORING_FINE` conviction type" do
      subject { ConvictionType::ADULT_MOTORING_FINE.motoring_fine? }

      it { is_expected.to be(true) }
    end

    context "when a youth `YOUTH_MOTORING_FINE` conviction type" do
      subject { ConvictionType::YOUTH_MOTORING_FINE.motoring_fine? }

      it { is_expected.to be(true) }
    end
  end
end
