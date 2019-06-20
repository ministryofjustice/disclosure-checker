require 'rails_helper'

RSpec.describe ConvictionType do
  describe 'PARENT_TYPES' do
    let(:values) { described_class::PARENT_TYPES.map(&:to_s) }

    it 'returns top level conviction' do
      expect(values).to eq(%w(
        community_order
        custodial_sentence
        discharge
        financial
        hospital_guard_order
      ))
    end
  end

  describe 'Conviction subtypes' do
    let(:values) { described_class.new(conviction_type).children.map(&:to_s) }

    context 'Community order' do
      let(:conviction_type) { :community_order }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          alcohol_abstinence
          alcohol_treatment
          behavioural_change_prog
          curfew
          drug_rehabilitation
          exclusion_requirement
          foreign_travel_prohibition
          mental_health_treatment
          prohibition
          referral_order
          rehab_activity_requirement
          reparation_order
          residence_requirement
          sexual_harm_prevention_order
          super_ord_breach_civil_injuc
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

    context 'Hospital or guardianship order' do
      let(:conviction_type) { :hospital_guard_order }

      it 'returns subtypes of this conviction type' do
        expect(values).to eq(%w(
          hospital_order
          guardianship_order
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
end
