require 'rails_helper'

RSpec.describe ConvictionType do
  describe 'YOUTH_PARENT_TYPES' do
    let(:values) { described_class::YOUTH_PARENT_TYPES.map(&:to_s) }

    it 'returns top level youth convictions' do
      expect(values).to eq(%w(
        community_order
        custodial_sentence
        discharge
        financial
        prevention_and_reparation_order
      ))
    end
  end

  describe 'ADULT_PARENT_TYPES' do
    let(:values) { described_class::ADULT_PARENT_TYPES.map(&:to_s) }

    it 'returns top level adult convictions' do
      expect(values).to eq(%w(
        adult_community_order
        adult_discharge
        adult_financial
        adult_military
        adult_prevention_and_reparation_order
        adult_custodial_sentence
      ))
    end
  end

  describe 'PARENT_TYPES_DISABLED_FOR_MVP' do
    let(:values) { described_class::PARENT_TYPES_DISABLED_FOR_MVP.map(&:to_s) }

    it 'returns top level conviction' do
      expect(values).to eq(%w(
        armed_forces
      ))
    end
  end

  describe 'Conviction subtypes' do
    let(:values) { described_class.new(conviction_type).children.map(&:to_s) }

    context 'Armed forces' do
      let(:conviction_type) { :armed_forces }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          dismissal
          service_detention
          service_community_order
          overseas_community_order
        ))
      end
    end

    context 'Community order' do
      let(:conviction_type) { :community_order }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          referral_order
          supervision_order
          youth_rehabilitation_order
        ))
      end
    end

    context 'Custodial sentence' do
      let(:conviction_type) { :custodial_sentence }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          detention_training_order
          detention
          hospital_order
        ))
      end
    end

    context 'Discharge' do
      let(:conviction_type) { :discharge }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          bind_over
          absolute_discharge
          conditional_discharge
        ))
      end
    end

    context 'Financial penalty' do
      let(:conviction_type) { :financial }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          fine
          compensation_to_a_victim
        ))
      end
    end

    context 'Prevention and reparation orders' do
      let(:conviction_type) { :prevention_and_reparation_order }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          reparation_order
          restraining_order
          sexual_harm_prevention_order
        ))
      end
    end

    context 'Adult Community order' do
      let(:conviction_type) { :adult_community_order }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          adult_alcohol_abstinence_treatment
          adult_behavioural_change_prog
          adult_curfew
          adult_drug_rehabilitation
          adult_electronic_monitoring_req
          adult_exclusion_requirement
          adult_mental_health_treatment
          adult_prohibition
          adult_rehab_activity_requirement
          adult_residence_requirement
          adult_unpaid_work
        ))
      end
    end

    context 'Adult Financial penalty' do
      let(:conviction_type) { :adult_financial }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          adult_fine
          adult_compensation_to_a_victim
        ))
      end
    end

    context 'Adult military convictions' do
      let(:conviction_type) { :adult_military }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          adult_dismissal
          adult_overseas_community_order
          adult_service_community_order
          adult_service_detention
        ))
      end
    end

    context 'Adult prevention and reparation orders' do
      let(:conviction_type) { :adult_prevention_and_reparation_order }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          adult_attendance_centre_order
          adult_reparation_order
          adult_restraining_order
          adult_sexual_harm_prevention_order
          adult_supervision_order
        ))
      end
    end


    context 'Adult Discharge' do
      let(:conviction_type) { :adult_discharge }

       it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          adult_bind_over
          adult_absolute_discharge
          adult_conditional_discharge
        ))
      end
    end

    context 'ConvictionType attributes' do
      let(:subtype) { 'sexual_harm_prevention_order' }
      let(:conviction_type) { described_class.find_constant(subtype) }

      context 'skip_length?' do
        context 'skip_length is false' do
          it { expect(conviction_type.skip_length?).to eq(false) }
        end

        context 'skip_length is true' do
          let(:subtype) { 'absolute_discharge' }
          it { expect(conviction_type.skip_length?).to eq(true) }
        end
      end

      context 'compensation?' do
        context 'compensation is false' do
          it { expect(conviction_type.compensation?).to eq(false) }
        end

        context 'compensation is true' do
          let(:subtype) { 'compensation_to_a_victim' }
          it { expect(conviction_type.compensation?).to eq(true) }
        end
      end
    end
  end

  describe 'Conviction subtype attributes' do
    let(:conviction_type) { described_class.find_constant(subtype) }

    context 'DISMISSAL' do
      let(:subtype) { 'dismissal' }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::StartPlusSixMonths) }
    end

    context 'SERVICE_DETENTION' do
      let(:subtype) { 'service_detention' }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::StartPlusSixMonths) }
    end

    context 'SERVICE_COMMUNITY_ORDER' do
      let(:subtype) { 'service_community_order' }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::StartPlusSixMonths) }
    end

    context 'OVERSEAS_COMMUNITY_ORDER' do
      let(:subtype) { 'overseas_community_order' }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::StartPlusSixMonths) }
    end

    context 'REFERRAL_ORDER' do
      let(:subtype) { 'referral_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'SUPERVISION_ORDER' do
      let(:subtype) { 'supervision_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'YOUTH_REHABILITATION_ORDER' do
      let(:subtype) { 'youth_rehabilitation_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusSixMonths) }
    end

    context 'DETENTION_TRAINING_ORDER' do
      let(:subtype) { 'detention_training_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::DetentionCalculator) }
    end

    context 'DETENTION' do
      let(:subtype) { 'detention' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::DetentionCalculator) }
    end

    context 'HOSPITAL_ORDER' do
      let(:subtype) { 'hospital_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'BIND_OVER' do
      let(:subtype) { 'bind_over' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'ABSOLUTE_DISCHARGE' do
      let(:subtype) { 'absolute_discharge' }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::ImmediatelyCalculator) }
    end

    context 'CONDITIONAL_DISCHARGE' do
      let(:subtype) { 'conditional_discharge' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'FINE' do
      let(:subtype) { 'fine' }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::StartPlusSixMonths) }
    end

    context 'COMPENSATION_TO_A_VICTIM' do
      let(:subtype) { 'compensation_to_a_victim' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(true) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::CompensationCalculator) }
    end

    context 'REPARATION_ORDER' do
      let(:subtype) { 'reparation_order' }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::ImmediatelyCalculator) }
    end

    context 'RESTRAINING_ORDER' do
      let(:subtype) { 'restraining_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'SEXUAL_HARM_PREVENTION_ORDER' do
      let(:subtype) { 'sexual_harm_prevention_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'ADULT_ALCOHOL_ABSTINENCE_TREATMENT' do
      let(:subtype) { 'adult_alcohol_abstinence_treatment' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context 'ADULT_BEHAVIOURAL_CHANGE_PROG' do
      let(:subtype) { 'adult_behavioural_change_prog' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context 'ADULT_CURFEW' do
      let(:subtype) { 'adult_curfew' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context 'ADULT_DRUG_REHABILITATION' do
      let(:subtype) { 'adult_drug_rehabilitation' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context 'ADULT_ELECTRONIC_MONITORING_REQ' do
      let(:subtype) { 'adult_electronic_monitoring_req' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context 'ADULT_EXCLUSION_REQUIREMENT' do
      let(:subtype) { 'adult_exclusion_requirement' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context 'ADULT_MENTAL_HEALTH_TREATMENT' do
      let(:subtype) { 'adult_mental_health_treatment' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context 'ADULT_PROHIBITION' do
      let(:subtype) { 'adult_prohibition' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context 'ADULT_REHAB_ACTIVITY_REQUIREMENT' do
      let(:subtype) { 'adult_rehab_activity_requirement' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context 'ADULT_RESIDENCE_REQUIREMENT' do
      let(:subtype) { 'adult_residence_requirement' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context 'ADULT_UNPAID_WORK' do
      let(:subtype) { 'adult_unpaid_work' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context 'ADULT_FINE' do
      let(:subtype) { 'adult_fine' }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::StartPlusTwelveMonths) }
    end

    context 'ADULT_COMPENSATION_TO_A_VICTIM' do
      let(:subtype) { 'adult_compensation_to_a_victim' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(true) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::CompensationCalculator) }
    end

    # ADULT_MILITARY
    #
    context 'ADULT_DISMISSAL' do
      let(:subtype) { 'adult_dismissal' }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::StartPlusTwelveMonths) }
    end

    context 'ADULT_OVERSEAS_COMMUNITY_ORDER' do
      let(:subtype) { 'adult_overseas_community_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context 'ADULT_SERVICE_COMMUNITY_ORDER' do
      let(:subtype) { 'adult_service_community_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context 'ADULT_SERVICE_DETENTION' do
      let(:subtype) { 'adult_service_detention' }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::StartPlusTwelveMonths) }
    end

    context 'ADULT_ATTENDANCE_CENTRE_ORDER' do
      let(:subtype) { 'adult_attendance_centre_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusTwelveMonths) }
    end

    context 'ADULT_REPARATION_ORDER' do
      let(:subtype) { 'adult_reparation_order' }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::ImmediatelyCalculator) }
    end

    context 'ADULT_RESTRAINING_ORDER' do
      let(:subtype) { 'adult_restraining_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'ADULT_SEXUAL_HARM_PREVENTION_ORDER' do
      let(:subtype) { 'adult_sexual_harm_prevention_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'ADULT_SUPERVISION_ORDER' do
      let(:subtype) { 'adult_supervision_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'ADULT_BIND_OVER' do
      let(:subtype) { 'adult_bind_over' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'ADULT_ABSOLUTE_DISCHARGE' do
      let(:subtype) { 'adult_absolute_discharge' }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::ImmediatelyCalculator) }
    end

    context 'ADULT_CONDITIONAL_DISCHARGE' do
      let(:subtype) { 'adult_conditional_discharge' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'ADULT_HOSPITAL_ORDER' do
      let(:subtype) { 'adult_hospital_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'ADULT_SUSPENDED_PRISON_SENTENCE' do
      let(:subtype) { 'adult_suspended_prison_sentence' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::PrisonSentenceCalculator) }
    end

    context 'ADULT_PRISON_SENTENCE' do
      let(:subtype) { 'adult_prison_sentence' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::PrisonSentenceCalculator) }
    end
  end
end
