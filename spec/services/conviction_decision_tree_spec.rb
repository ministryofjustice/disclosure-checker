require 'rails_helper'

RSpec.describe ConvictionDecisionTree do
  let(:disclosure_check) do
    instance_double(
      DisclosureCheck,
      conviction_type: conviction_type,
      conviction_subtype: conviction_subtype,
      compensation_paid: compensation_paid,
    )
  end

  let(:step_params)        { double('Step') }
  let(:next_step)          { nil }
  let(:as)                 { nil }
  let(:conviction_type)    { nil }
  let(:conviction_subtype) { nil }
  let(:compensation_paid)  { nil }


  subject { described_class.new(disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `known_date` ' do
    let(:step_params) { { known_date: 'anything' } }
    let(:conviction_subtype) { :detention_training_order }

    context 'when subtype not equal fine' do
      it { is_expected.to have_destination(:conviction_length_type, :edit) }
    end

    context 'when subtype equal fine' do
      let(:conviction_subtype) { :fine }
      it { is_expected.to have_destination('/steps/check/results', :show) }
    end
  end

  context 'when the step is `conviction_type`' do
    let(:step_params) { { conviction_type: conviction_type } }
    let(:conviction_type) { 'community_order' }
    it { is_expected.to have_destination(:conviction_subtype, :edit) }
  end

  context 'when the step is `conviction_subtype`' do
    let(:conviction_subtype) { :detention_training_order }
    let(:step_params) { { conviction_subtype: conviction_subtype } }

    context 'when subtype equal compensation_to_a_victim' do
      let(:conviction_subtype) { :compensation_to_a_victim }
      it { is_expected.to have_destination(:compensation_paid, :edit) }
    end

    context 'when subtype is not equal to compensation_to_a_victim' do
      it { is_expected.to have_destination(:known_date, :edit) }
    end
  end

  context 'when the step is `conviction_length_type` ' do
    let(:step_params) { { conviction_length_type: conviction_length_type } }

    context 'and the answer is `no_length`' do
      let(:conviction_length_type) { ConvictionLengthType::NO_LENGTH.to_s }
      it { is_expected.to have_destination('/steps/check/results', :show) }
    end

    context 'and the answer is other than `no_length`' do
      let(:conviction_length_type) { ConvictionLengthType::MONTHS.to_s }
      it { is_expected.to have_destination(:conviction_length, :edit) }
    end
  end

  context 'when the step is `conviction_length`' do
    let(:step_params) { { conviction_length: 'anything' } }
    it { is_expected.to have_destination('/steps/check/results', :show) }
  end

  context 'when the step is `compensation_paid`' do
    context 'when the step is `compensation_paid` equal yes' do
      let(:compensation_paid)  { GenericYesNo::YES }
      let(:step_params) { { compensation_paid:  compensation_paid } }
      it { is_expected.to have_destination(:compensation_payment_date, :edit) }
    end

    context 'when the step is `compensation_paid` equal no' do
      let(:compensation_paid)  { GenericYesNo::NO }
      let(:step_params) { { compensation_paid: compensation_paid } }
      it { is_expected.to have_destination(:compensation_not_paid, :show) }
    end
  end

  context 'when the step is `compensation_payment_date`' do
    let(:step_params) { { compensation_payment_date: 'anything' } }
    it { is_expected.to have_destination('/steps/check/results', :show) }
  end
end
