require 'spec_helper'

RSpec.describe Steps::Conviction::ConvictionSubtypeForm do
  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      conviction_subtype: conviction_subtype,
    }
  end

  let(:disclosure_check) {
    instance_double(DisclosureCheck, conviction_type: conviction_type, conviction_subtype: conviction_subtype)
  }

  let(:conviction_type) { 'community_order' } # any conviction with children will do
  let(:conviction_subtype) { nil }

  subject { described_class.new(arguments) }

  describe '#conviction_type' do
    it 'delegates to `disclosure_checker`' do
      expect(disclosure_check).to receive(:conviction_type)
      expect(subject.conviction_type).to eq('community_order')
    end
  end

  describe '#choices' do
    it 'returns the relevant choices (children of the conviction type)' do
      expect(subject.choices).to eq(%w(
        alcohol_abstinence_treatment
        attendance_centre_order
        behavioural_change_prog
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
        sexual_harm_prevention_order
        super_ord_breach_civil_injuc
        unpaid_work
      ))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :conviction_subtype, example_value: 'alcohol_abstinence'

    context 'when form is valid' do
      let(:conviction_subtype) { 'alcohol_abstinence_treatment' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          conviction_subtype: conviction_subtype
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
