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
      ))
    end
  end

  describe 'ADULT_PARENT_TYPES' do
    let(:values) { described_class::ADULT_PARENT_TYPES.map(&:to_s) }

    it 'returns top level adult convictions' do
      expect(values).to eq(%w(
        adult_community_order
        adult_financial
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
          alcohol_abstinence_treatment
          attendance_centre_order
          behavioural_change_prog
          bind_over
          curfew
          drug_rehabilitation
          exclusion_requirement
          intoxicating_substance_treatment
          mental_health_treatment
          prohibition
          referral_order
          rehab_activity_requirement
          reparation_order
          residence_requirement
          restraining_order
          sexual_harm_prevention_order
          supervision_order
          unpaid_work
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

    context 'ConvictionType attributes' do
      let(:subtype) { 'curfew' }
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

    context 'ALCOHOL_ABSTINENCE_TREATMENT' do
      let(:subtype) { 'alcohol_abstinence_treatment' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusSixMonths) }
    end

    context 'ATTENDANCE_CENTRE_ORDER' do
      let(:subtype) { 'attendance_centre_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusSixMonths) }
    end

    context 'BEHAVIOURAL_CHANGE_PROG' do
      let(:subtype) { 'behavioural_change_prog' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusSixMonths) }
    end

    context 'BIND_OVER' do
      let(:subtype) { 'bind_over' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'CURFEW' do
      let(:subtype) { 'curfew' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusSixMonths) }
    end

    context 'DRUG_REHABILITATION' do
      let(:subtype) { 'drug_rehabilitation' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusSixMonths) }
    end

    context 'EXCLUSION_REQUIREMENT' do
      let(:subtype) { 'exclusion_requirement' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusSixMonths) }
    end

    context 'MENTAL_HEALTH_TREATMENT' do
      let(:subtype) { 'mental_health_treatment' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusSixMonths) }
    end

    context 'PROHIBITION' do
      let(:subtype) { 'prohibition' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusSixMonths) }
    end

    context 'REFERRAL_ORDER' do
      let(:subtype) { 'referral_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'REHAB_ACTIVITY_REQUIREMENT' do
      let(:subtype) { 'rehab_activity_requirement' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusSixMonths) }
    end

    context 'REPARATION_ORDER' do
      let(:subtype) { 'reparation_order' }

      it { expect(conviction_type.skip_length?).to eq(true) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::ImmediatelyCalculator) }
    end

    context 'RESIDENCE_REQUIREMENT' do
      let(:subtype) { 'residence_requirement' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
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

    context 'SUPERVISION_ORDER' do
      let(:subtype) { 'supervision_order' }

      it { expect(conviction_type.skip_length?).to eq(false) }
      it { expect(conviction_type.compensation?).to eq(false) }
      it { expect(conviction_type.calculator_class).to eq(Calculators::AdditionCalculator::PlusZeroMonths) }
    end

    context 'UNPAID_WORK' do
      let(:subtype) { 'unpaid_work' }

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
  end
end
