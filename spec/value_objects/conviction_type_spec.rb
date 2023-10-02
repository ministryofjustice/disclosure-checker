require "rails_helper"

RSpec.describe ConvictionType do
  describe "YOUTH_PARENT_TYPES" do
    let(:values) do
      described_class::YOUTH_PARENT_TYPES.map(&:to_s)
    end

    it "returns top level youth convictions" do
      expect(values).to eq(%w[
        referral_supervision_yro
        custodial_sentence
        discharge
        youth_motoring
        military
        prevention_reparation
        financial
      ])
    end
  end

  describe "ADULT_PARENT_TYPES" do
    let(:values) do
      described_class::ADULT_PARENT_TYPES.map(&:to_s)
    end

    it "returns top level adult convictions" do
      expect(values).to eq(%w[
        adult_community_reparation
        adult_custodial_sentence
        adult_discharge
        adult_motoring
        adult_military
        adult_financial
      ])
    end
  end

  describe "Conviction subtypes" do
    let(:values) { described_class.new(conviction_type).children.map(&:to_s) }

    context "when Military" do
      let(:conviction_type) { :military }

      it "returns subtypes of this conviction type" do
        expect(values).to eq(%w[
          dismissal
          overseas_community_order
          service_community_order
          service_detention
        ])
      end
    end

    context "when Referral or youth rehabilitation order (YRO)" do
      let(:conviction_type) { :referral_supervision_yro }

      it "returns subtypes of this conviction type" do
        expect(values).to eq(%w[
          referral_order
          supervision_order
          youth_rehabilitation_order
        ])
      end
    end

    context "when Custodial sentence" do
      let(:conviction_type) { :custodial_sentence }

      it "returns subtypes of this conviction type" do
        expect(values).to eq(%w[
          detention_training_order
          detention
          hospital_order
        ])
      end
    end

    context "when Discharge" do
      let(:conviction_type) { :discharge }

      it "returns subtypes of this conviction type" do
        expect(values).to eq(%w[
          bind_over
          absolute_discharge
          conditional_discharge
        ])
      end
    end

    context "when Financial penalty" do
      let(:conviction_type) { :financial }

      it "returns subtypes of this conviction type" do
        expect(values).to eq(%w[
          fine
          compensation_to_a_victim
        ])
      end
    end

    context "when Prevention and reparation orders" do
      let(:conviction_type) { :prevention_reparation }

      it "returns subtypes of this conviction type" do
        expect(values).to eq(%w[
          reparation_order
          restraining_order
          sexual_harm_prevention_order
        ])
      end
    end

    context "when Adult community, prevention and reparation orders" do
      let(:conviction_type) { :adult_community_reparation }

      it "returns subtypes of this conviction type" do
        expect(values).to eq(%w[
          adult_attendance_centre_order
          adult_community_order
          adult_criminal_behaviour
          adult_reparation_order
          adult_restraining_order
          adult_serious_crime_prevention
          adult_sexual_harm_prevention_order
          adult_other_requirement_order
        ])
      end
    end

    context "when Adult Financial penalty" do
      let(:conviction_type) { :adult_financial }

      it "returns subtypes of this conviction type" do
        expect(values).to eq(%w[
          adult_fine
          adult_compensation_to_a_victim
        ])
      end
    end

    context "when Adult military convictions" do
      let(:conviction_type) { :adult_military }

      it "returns subtypes of this conviction type" do
        expect(values).to eq(%w[
          adult_dismissal
          adult_overseas_community_order
          adult_service_community_order
          adult_service_detention
        ])
      end
    end

    context "when Adult motoring convictions" do
      let(:conviction_type) { :adult_motoring }

      it "returns subtypes of this conviction type" do
        expect(values).to eq(%w[
          adult_disqualification
          adult_motoring_fine
          adult_penalty_notice
          adult_penalty_points
        ])
      end
    end

    context "when Adult Discharge" do
      let(:conviction_type) { :adult_discharge }

      it "returns subtypes of this conviction type" do
        expect(values).to eq(%w[
          adult_bind_over
          adult_absolute_discharge
          adult_conditional_discharge
        ])
      end
    end
  end

  describe "ConvictionType attributes" do
    let(:subtype) { "sexual_harm_prevention_order" }
    let(:conviction_type) { described_class.find_constant(subtype) }

    context "when skip_length?" do
      context "when skip_length is false" do
        it { expect(conviction_type.skip_length?).to eq(false) }
      end

      context "when skip_length? is true" do
        let(:subtype) { "absolute_discharge" }

        it { expect(conviction_type.skip_length?).to eq(true) }
      end
    end
  end

  describe "Conviction subtype attributes" do
    let(:conviction_type) { described_class.find_constant(subtype) }

    context "when DISMISSAL" do
      let(:subtype) { "dismissal" }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::StartPlusSixMonths) }
    end

    context "when SERVICE_DETENTION" do
      let(:subtype) { "service_detention" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusSixMonths) }
    end

    context "when SERVICE_COMMUNITY_ORDER" do
      let(:subtype) { "service_community_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusSixMonths) }
    end

    context "when OVERSEAS_COMMUNITY_ORDER" do
      let(:subtype) { "overseas_community_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusSixMonths) }
    end

    context "when REFERRAL_ORDER" do
      let(:subtype) { "referral_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when SUPERVISION_ORDER" do
      let(:subtype) { "supervision_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when YOUTH_REHABILITATION_ORDER" do
      let(:subtype) { "youth_rehabilitation_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when DETENTION_TRAINING_ORDER" do
      let(:subtype) { "detention_training_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::SentenceCalculator::DetentionTraining) }
    end

    context "when DETENTION" do
      let(:subtype) { "detention" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::SentenceCalculator::Detention) }
    end

    context "when DETENTION_SCHEDULE_18" do
      let(:subtype) { "detention_schedule_18" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(true) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::SentenceCalculator::Schedule18Detention) }
    end

    context "when HOSPITAL_ORDER" do
      let(:subtype) { "hospital_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when BIND_OVER" do
      let(:subtype) { "bind_over" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when ABSOLUTE_DISCHARGE" do
      let(:subtype) { "absolute_discharge" }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::ImmediatelyCalculator) }
    end

    context "when CONDITIONAL_DISCHARGE" do
      let(:subtype) { "conditional_discharge" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when FINE" do
      let(:subtype) { "fine" }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::StartPlusSixMonths) }
    end

    context "when COMPENSATION_TO_A_VICTIM" do
      let(:subtype) { "compensation_to_a_victim" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::CompensationCalculator) }
    end

    context "when REPARATION_ORDER" do
      let(:subtype) { "reparation_order" }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(true) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::ImmediatelyCalculator) }
    end

    context "when RESTRAINING_ORDER" do
      let(:subtype) { "restraining_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(true) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when SEXUAL_HARM_PREVENTION_ORDER" do
      let(:subtype) { "sexual_harm_prevention_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(true) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    # ADULT COMMUNITY REPARATION
    #
    context "when ADULT_ATTENDANCE_CENTRE_ORDER" do
      let(:subtype) { "adult_attendance_centre_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when ADULT_COMMUNITY_ORDER" do
      let(:subtype) { "adult_community_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when ADULT_CRIMINAL_BEHAVIOUR" do
      let(:subtype) { "adult_criminal_behaviour" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(true) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when ADULT_REPARATION_ORDER" do
      let(:subtype) { "adult_reparation_order" }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(true) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::ImmediatelyCalculator) }
    end

    context "when ADULT_RESTRAINING_ORDER" do
      let(:subtype) { "adult_restraining_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(true) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when ADULT_SERIOUS_CRIME_PREVENTION" do
      let(:subtype) { "adult_serious_crime_prevention" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(true) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when ADULT_SEXUAL_HARM_PREVENTION_ORDER" do
      let(:subtype) { "adult_sexual_harm_prevention_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(true) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when ADULT_OTHER_REQUIREMENT_ORDER" do
      let(:subtype) { "adult_other_requirement_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    # ADULT FINANCIAL
    #
    context "when ADULT_FINE" do
      let(:subtype) { "adult_fine" }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::StartPlusTwelveMonths) }
    end

    context "when ADULT_COMPENSATION_TO_A_VICTIM" do
      let(:subtype) { "adult_compensation_to_a_victim" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::CompensationCalculator) }
    end

    # ADULT_MILITARY
    #
    context "when ADULT_DISMISSAL" do
      let(:subtype) { "adult_dismissal" }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::StartPlusTwelveMonths) }
    end

    context "when ADULT_OVERSEAS_COMMUNITY_ORDER" do
      let(:subtype) { "adult_overseas_community_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context "when ADULT_SERVICE_COMMUNITY_ORDER" do
      let(:subtype) { "adult_service_community_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context "when ADULT_SERVICE_DETENTION" do
      let(:subtype) { "adult_service_detention" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    # YOUTH_MOTORING
    #
    context "when YOUTH_DISQUALIFICATION" do
      let(:subtype) { "youth_disqualification" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(true) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::DisqualificationCalculator::Youths) }
    end

    context "when YOUTH_MOTORING_FINE" do
      let(:subtype) { "youth_motoring_fine" }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::Motoring::Youth::Fine) }
    end

    context "when YOUTH_PENALTY_NOTICE" do
      let(:subtype) { "youth_penalty_notice" }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::Motoring::Youth::PenaltyNotice) }
    end

    context "when YOUTH_PENALTY_POINTS" do
      let(:subtype) { "youth_penalty_points" }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::Motoring::Youth::PenaltyPoints) }
    end

    # ADULT_MOTORING
    #
    context "when ADULT_DISQUALIFICATION" do
      let(:subtype) { "adult_disqualification" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(true) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::DisqualificationCalculator::Adults) }
    end

    context "when ADULT_MOTORING_FINE" do
      let(:subtype) { "adult_motoring_fine" }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::Motoring::Adult::Fine) }
    end

    context "when ADULT_PENALTY_NOTICE" do
      let(:subtype) { "adult_penalty_notice" }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::Motoring::Adult::PenaltyNotice) }
    end

    context "when ADULT_PENALTY_POINTS" do
      let(:subtype) { "adult_penalty_points" }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::Motoring::Adult::PenaltyPoints) }
    end

    context "when ADULT_BIND_OVER" do
      let(:subtype) { "adult_bind_over" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when ADULT_ABSOLUTE_DISCHARGE" do
      let(:subtype) { "adult_absolute_discharge" }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::ImmediatelyCalculator) }
    end

    context "when ADULT_CONDITIONAL_DISCHARGE" do
      let(:subtype) { "adult_conditional_discharge" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when ADULT_HOSPITAL_ORDER" do
      let(:subtype) { "adult_hospital_order" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(true) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context "when ADULT_SUSPENDED_PRISON_SENTENCE" do
      let(:subtype) { "adult_suspended_prison_sentence" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::SentenceCalculator::SuspendedPrison) }
    end

    context "when ADULT_PRISON_SENTENCE" do
      let(:subtype) { "adult_prison_sentence" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::SentenceCalculator::Prison) }
    end

    context "when ADULT_PRISON_SENTENCE_SCHEDULE_18" do
      let(:subtype) { "adult_prison_sentence_schedule_18" }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.relevant_order?).to eq(false) }
      it { expect(conviction_type.drag_through?).to eq(false) }
      it { expect(conviction_type.schedule_18_offence?).to eq(true) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::SentenceCalculator::Schedule18Prison) }
    end
  end

  describe "#schedule_18_applicable?" do
    subject(:schedule_18_applicable) { described_class.new(value).schedule_18_applicable? }

    context "when adult_prison_sentence" do
      let(:value) { :adult_prison_sentence }

      it { expect(schedule_18_applicable).to eq(true) }
    end

    context "when detention" do
      let(:value) { :detention }

      it { expect(schedule_18_applicable).to eq(true) }
    end

    context "when adult_service_detention" do
      let(:value) { :adult_service_detention }

      it { expect(schedule_18_applicable).to eq(false) }
    end
  end
end
