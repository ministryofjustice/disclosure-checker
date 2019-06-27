require 'rails_helper'

RSpec.describe ConvictionExpiryCalculator do
  subject { described_class.new(disclosure_check: disclosure_check, ) }


  let(:disclosure_check) { build(:disclosure_check, :conviction,
                                 conviction_subtype: conviction_subtype,
                                 known_date: known_date,
                                 conviction_length: conviction_length,
                                 conviction_length_type: conviction_length_type) }

  let(:expiry_date) { subject.expiry_date }
  let(:known_date) { Date.new(2018, 10, 31) }
  let(:conviction_length) { 10 }
  let(:conviction_length_type) { 'months' }
  let(:conviction_subtype) { nil }

  context '#expiry_date' do
    let(:conviction_subtype) { 'hospital_order' }

    it 'will call a calculator' do
      expect(subject).to receive(:calculator).and_call_original
      subject.expiry_date
    end
  end

  context 'return the correct calculator based on conviction sub type' do
    context 'Calculators::ConvictionEndDateCalculator' do
      let(:klass) { Calculators::ConvictionEndDateCalculator }

      context 'hospital_order' do
        let(:conviction_subtype) { 'hospital_order' }
        it { expect(subject.calculator).to be_a klass }
      end

      context 'guardianship_order' do
        let(:conviction_subtype) { 'guardianship_order' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'super_ord_breach_civil_injuc' do
        let(:conviction_subtype) { 'super_ord_breach_civil_injuc' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'residence_requirement' do
        let(:conviction_subtype) { 'residence_requirement' }
        it { expect(subject.calculator).to be_a klass  }
      end
    end

    context 'Calculators::YouthRehabilitationOrderCalculator' do
      let(:klass) { Calculators::YouthRehabilitationOrderCalculator }

      context 'alcohol_abstinence_treatment' do
        let(:conviction_subtype) { 'alcohol_abstinence_treatment' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'attendance_centre_order' do
        let(:conviction_subtype) { 'attendance_centre_order' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'behavioural_change_prog' do
        let(:conviction_subtype) { 'behavioural_change_prog' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'curfew' do
        let(:conviction_subtype) { 'curfew' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'drug_rehabilitation' do
        let(:conviction_subtype) { 'drug_rehabilitation' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'exclusion_requirement' do
        let(:conviction_subtype) { 'exclusion_requirement' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'intoxicating_substance_treatment' do
        let(:conviction_subtype) { 'intoxicating_substance_treatment' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'mental_health_treatment' do
        let(:conviction_subtype) { 'mental_health_treatment' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'prohibition' do
        let(:conviction_subtype) { 'prohibition' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'referral_order' do
        let(:conviction_subtype) { 'referral_order' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'rehab_activity_requirement' do
        let(:conviction_subtype) { 'rehab_activity_requirement' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'sexual_harm_prevention_order' do
        let(:conviction_subtype) { 'sexual_harm_prevention_order' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'unpaid_work' do
        let(:conviction_subtype) { 'unpaid_work' }
        it { expect(subject.calculator).to be_a klass  }
      end
    end

    context 'Calculators::ImmediatelyCalculator' do
      let(:klass) { Calculators::ImmediatelyCalculator }

      context 'absolute_discharge' do
        let(:conviction_subtype) { 'absolute_discharge' }
        it { expect(subject.calculator).to be_a klass  }
      end
    end

    context 'Calculators::ImmediatelyCalculator' do
      let(:klass) { Calculators::FineCalculator }

      context 'fine' do
        let(:conviction_subtype) { 'fine' }
        it { expect(subject.calculator).to be_a klass  }
      end
    end

    context 'Calculators::CompensationCalculator' do
      let(:klass) { Calculators::CompensationCalculator }

      context 'compensation_to_a_victim' do
        let(:conviction_subtype) { 'compensation_to_a_victim' }
        it { expect(subject.calculator).to be_a klass  }
      end
    end

    context 'Calculators::DetentionCalculator' do
      let(:klass) { Calculators::DetentionCalculator }

      context 'detention_training_order' do
        let(:conviction_subtype) { 'detention_training_order' }
        it { expect(subject.calculator).to be_a klass  }
      end

      context 'detention' do
        let(:conviction_subtype) { 'detention' }
        it { expect(subject.calculator).to be_a klass  }
      end
    end
  end
end
