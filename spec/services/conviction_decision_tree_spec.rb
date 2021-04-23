require 'rails_helper'

RSpec.describe ConvictionDecisionTree do
  let(:disclosure_check) do
    instance_double(
      DisclosureCheck,
      conviction_type: conviction_type,
      conviction_subtype: conviction_subtype,
      compensation_paid: compensation_paid,
      motoring_endorsement: motoring_endorsement,
      compensation_payment_over_100: compensation_payment_over_100,
      compensation_receipt_sent: compensation_receipt_sent,
    )
  end

  let(:step_params)        { double('Step') }
  let(:next_step)          { nil }
  let(:as)                 { nil }
  let(:conviction_type)    { nil }
  let(:conviction_subtype) { nil }
  let(:compensation_paid)  { nil }
  let(:motoring_endorsement) { nil }
  let(:compensation_payment_over_100) { nil }
  let(:compensation_receipt_sent) { nil }

  subject { described_class.new(disclosure_check: disclosure_check, step_params: step_params, as: as, next_step: next_step) }

  it_behaves_like 'a decision tree'

  context 'when the step is `conviction_date`' do
    let(:step_params) { { conviction_date: 'date' } }
    it { is_expected.to have_destination(:conviction_type, :edit) }
  end

  context 'when the step is `conviction_type`' do
    let(:step_params) { { conviction_type: 'foobar' } }
    it { is_expected.to have_destination(:conviction_subtype, :edit) }
  end

  context 'when the step is `conviction_subtype`' do
    let(:conviction_type) { :referral_supervision_yro }
    let(:conviction_subtype) { :youth_rehabilitation_order }
    let(:step_params) { { conviction_subtype: conviction_subtype } }

    context 'when subtype equal compensation_to_a_victim' do
      let(:conviction_subtype) { :compensation_to_a_victim }
      it { is_expected.to have_destination(:compensation_paid, :edit) }
    end

    context 'Motoring sub types' do
      let(:conviction_type) { :youth_motoring }

      context 'when subtype equal youth_motoring_fine' do
        let(:conviction_subtype) { :youth_motoring_fine }
        it { is_expected.to have_destination(:motoring_endorsement, :edit) }
      end

      context 'when subtype equal youth_penalty_notice' do
        let(:conviction_subtype) { :youth_penalty_notice }
        it { is_expected.to have_destination(:known_date, :edit) }
      end

      context 'when subtype equal youth_penalty_points' do
        let(:conviction_subtype) { :youth_penalty_points }
        it { is_expected.to have_destination(:known_date, :edit) }
      end
    end

    context 'Motoring adult sub types' do
      let(:conviction_type) { :adult_motoring }

      context 'when subtype equal adult_motoring_fine' do
        let(:conviction_subtype) { :adult_motoring_fine }
        it { is_expected.to have_destination(:motoring_endorsement, :edit) }
      end

      context 'when subtype equal adult_penalty_notice' do
        let(:conviction_subtype) { :adult_penalty_notice }
        it { is_expected.to have_destination(:known_date, :edit) }
      end

      context 'when subtype equal adult_penalty_points' do
        let(:conviction_subtype) { :adult_penalty_points }
        it { is_expected.to have_destination(:known_date, :edit) }
      end
    end

    context 'when subtype is a bailable offence' do
      let(:conviction_subtype) { :detention_training_order }
      it { is_expected.to have_destination(:conviction_bail, :edit) }
    end

    context 'for any other conviction subtypes' do
      it { is_expected.to have_destination(:known_date, :edit) }
    end
  end

  context 'when the step is `known_date` ' do
    let(:step_params) { { known_date: 'anything' } }

    context 'when subtype has length' do
      let(:conviction_subtype) { :detention_training_order }
      it { is_expected.to have_destination(:conviction_length_type, :edit) }
    end

    context 'when subtype does not have length' do
      let(:conviction_subtype) { :fine }
      it { is_expected.to show_check_your_answers_page }
    end
  end

  context 'when the step is `conviction_length_type` ' do
    let(:step_params) { { conviction_length_type: conviction_length_type } }

    context 'and the answer is `no_length`' do
      let(:conviction_length_type) { ConvictionLengthType::NO_LENGTH.to_s }
      it { is_expected.to show_check_your_answers_page }
    end

    context 'and the answer is `indefinite`' do
      let(:conviction_length_type) { ConvictionLengthType::INDEFINITE.to_s }
      it { is_expected.to show_check_your_answers_page }
    end

    context 'and the answer is other than `no_length`' do
      let(:conviction_length_type) { ConvictionLengthType::MONTHS.to_s }
      it { is_expected.to have_destination(:conviction_length, :edit) }
    end
  end

  context 'when the step is `conviction_length`' do
    let(:step_params) { { conviction_length: 'anything' } }
    it { is_expected.to show_check_your_answers_page }
  end

  context 'when the step is `compensation_paid`' do
    context 'when the step is `compensation_paid` equal yes' do
      let(:compensation_paid)  { GenericYesNo::YES }
      let(:step_params) { { compensation_paid:  compensation_paid } }
      it { is_expected.to have_destination(:compensation_paid_amount, :edit) }
    end

    context 'when the step is `compensation_paid` equal no' do
      let(:compensation_paid)  { GenericYesNo::NO }
      let(:step_params) { { compensation_paid: compensation_paid } }
      it { is_expected.to have_destination(:compensation_not_paid, :show) }
    end
  end

  context 'when the step is `compensation_paid_amount`' do
    context 'when the step is `compensation_payment_over_100` equal yes' do
      let(:compensation_payment_over_100)  { GenericYesNo::YES }
      let(:step_params) { { compensation_payment_over_100:  compensation_payment_over_100 } }

      it { is_expected.to have_destination(:compensation_payment_date, :edit) }
    end

    context 'when the step is `compensation_payment_over_100` equal no' do
      let(:compensation_payment_over_100)  { GenericYesNo::NO }
      let(:step_params) { { compensation_payment_over_100:  compensation_payment_over_100 } }

      it { is_expected.to have_destination(:compensation_payment_date, :edit) }
    end
  end

  context 'when the step is `compensation_payment_date`' do
    let(:step_params) { { compensation_payment_date: 'anything' } }

    context 'and the compensation payment was over £100' do
      let(:compensation_payment_over_100) { GenericYesNo::YES }

      it { is_expected.to have_destination(:compensation_payment_receipt, :edit) }
    end

    context 'and the compensation payment was under £100' do
      let(:compensation_payment_over_100) { GenericYesNo::NO }

      it { is_expected.to show_check_your_answers_page }
    end
  end

  context 'when the step is `compensation_receipt_sent`' do
    let(:step_params) { { compensation_receipt_sent: 'anything' } }

    context 'and the receipt was sent' do
      let(:compensation_receipt_sent) { GenericYesNo::YES }
      it { is_expected.to show_check_your_answers_page }
    end

    context 'and the receipt was not sent' do
      let(:compensation_receipt_sent) { GenericYesNo::NO }
      it { is_expected.to have_destination(:compensation_unable_to_tell, :show) }
    end
  end

  context 'when the step is `motoring_endorsement`' do
    let(:motoring_endorsement) {GenericYesNo::YES }
    let(:step_params) { { motoring_endorsement:  motoring_endorsement } }

    context 'when subtype is equal adult_penalty_notice' do
      let(:conviction_subtype) { :adult_penalty_notice }
      context 'with a endorsement' do
        it { is_expected.to have_destination(:known_date, :edit) }
      end

      context ' without a endorsement' do
        let(:motoring_endorsement) {GenericYesNo::NO }
        it { is_expected.to show_check_your_answers_page }
      end
    end

    context 'when subtype is not equal to adult_penalty_notice sub types' do
      let(:conviction_subtype) { :adult_disqualification }

      context 'with a endorsement' do
        it { is_expected.to have_destination(:known_date, :edit) }
      end

      context 'without a endorsement' do
        let(:motoring_endorsement) {GenericYesNo::NO }
        it { is_expected.to have_destination(:known_date, :edit) }
      end
    end
  end

  context 'when the step is `conviction_bail`' do
    let(:step_params) { { conviction_bail: answer } }

    context 'and the answer is yes' do
      let(:answer) { GenericYesNo::YES }
      it { is_expected.to have_destination(:conviction_bail_days, :edit) }
    end

    context 'and the answer is no' do
      let(:answer) { GenericYesNo::NO }
      it { is_expected.to have_destination(:known_date, :edit) }
    end
  end

  context 'when the step is `conviction_bail_days`' do
    let(:step_params) { { conviction_bail_days: 'whatever' } }
    it { is_expected.to have_destination(:known_date, :edit) }
  end
end
