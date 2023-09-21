require "rails_helper"

RSpec.describe ConvictionDecisionTree do
  subject { described_class.new(disclosure_check:, step_params:, as:, next_step:) }

  let(:disclosure_check) do
    DisclosureCheck.new(
      conviction_type:,
      conviction_subtype:,
      compensation_paid:,
      motoring_endorsement:,
      conviction_length:,
    )
  end

  let(:step_params)        { instance_double("Step") }
  let(:next_step)          { nil }
  let(:as)                 { nil }
  let(:conviction_type)    { nil }
  let(:conviction_subtype) { nil }
  let(:compensation_paid)  { nil }
  let(:motoring_endorsement) { nil }

  it_behaves_like "a decision tree"

  context "when the step is `conviction_date`" do
    let(:step_params) { { conviction_date: "date" } }

    it { is_expected.to have_destination(:conviction_type, :edit) }
  end

  context "when the step is `conviction_type`" do
    let(:step_params) { { conviction_type: "foobar" } }

    it { is_expected.to have_destination(:conviction_subtype, :edit) }
  end

  context "when the step is `conviction_subtype`" do
    let(:conviction_type) { :referral_supervision_yro }
    let(:conviction_subtype) { :youth_rehabilitation_order }
    let(:step_params) { { conviction_subtype: } }

    context "when subtype equal compensation_to_a_victim" do
      let(:conviction_subtype) { :compensation_to_a_victim }

      it { is_expected.to have_destination(:compensation_paid, :edit) }
    end

    context "when Motoring sub types" do
      let(:conviction_type) { :youth_motoring }

      context "when subtype equal youth_motoring_fine" do
        let(:conviction_subtype) { :youth_motoring_fine }

        it { is_expected.to have_destination(:motoring_endorsement, :edit) }
      end

      context "when subtype equal youth_penalty_notice" do
        let(:conviction_subtype) { :youth_penalty_notice }

        it { is_expected.to have_destination(:known_date, :edit) }
      end

      context "when subtype equal youth_penalty_points" do
        let(:conviction_subtype) { :youth_penalty_points }

        it { is_expected.to have_destination(:known_date, :edit) }
      end
    end

    context "when Motoring adult sub types" do
      let(:conviction_type) { :adult_motoring }

      context "when subtype equal adult_motoring_fine" do
        let(:conviction_subtype) { :adult_motoring_fine }

        it { is_expected.to have_destination(:motoring_endorsement, :edit) }
      end

      context "when subtype equal youth_motoring_fine" do
        let(:conviction_subtype) { :youth_motoring_fine }

        it { is_expected.to have_destination(:motoring_endorsement, :edit) }
      end

      context "when subtype is any other motoring conviction" do
        let(:conviction_subtype) { :adult_disqualification }

        it { is_expected.to have_destination(:known_date, :edit) }
      end
    end

    context "when subtype is a bailable offence" do
      let(:conviction_subtype) { :detention_training_order }

      it { is_expected.to have_destination(:conviction_bail, :edit) }
    end

    context "when any other conviction subtypes" do
      it { is_expected.to have_destination(:known_date, :edit) }
    end
  end

  context "when the step is `known_date` " do
    let(:step_params) { { known_date: "anything" } }

    context "when subtype has length" do
      let(:conviction_subtype) { :detention_training_order }

      it { is_expected.to have_destination(:conviction_length_type, :edit) }
    end

    context "when subtype does not have length" do
      let(:conviction_subtype) { :fine }

      it { is_expected.to show_check_your_answers_page }
    end
  end

  context "when the step is `conviction_length_type` " do
    let(:step_params) { { conviction_length_type: } }

    context "and the answer is `no_length`" do
      let(:conviction_length_type) { ConvictionLengthType::NO_LENGTH.to_s }

      it { is_expected.to show_check_your_answers_page }
    end

    context "and the answer is `indefinite`" do
      let(:conviction_length_type) { ConvictionLengthType::INDEFINITE.to_s }

      it { is_expected.to show_check_your_answers_page }
    end

    context "and the answer is other than `no_length`" do
      let(:conviction_length_type) { ConvictionLengthType::MONTHS.to_s }

      it { is_expected.to have_destination(:conviction_length, :edit) }
    end
  end

  context "when the step is `conviction_length`" do
    let(:step_params) { { conviction_length: "anything" } }

    context "when `conviction_length` is less than 4 years" do
    let(:conviction_length) { 3 }

        it { is_expected.to show_check_your_answers_page }
    end

    context "when `conviction_length` is greater or equal to 4 years" do
    let(:conviction_length) { 4 }

        it { is_expected.to have_destination(:conviction_schedule18, :edit) }
    end
  end

  context "when the step is `compensation_paid`" do
    context "when the step is `compensation_paid` equal yes" do
      let(:compensation_paid) { GenericYesNo::YES }
      let(:step_params) { { compensation_paid: } }

      it { is_expected.to have_destination(:compensation_payment_date, :edit) }
    end

    context "when the step is `compensation_paid` equal no" do
      let(:compensation_paid) { GenericYesNo::NO }
      let(:step_params) { { compensation_paid: } }

      it { is_expected.to have_destination(:compensation_not_paid, :show) }
    end
  end

  context "when the step is `compensation_payment_date`" do
    let(:step_params) { { compensation_payment_date: "anything" } }

    it { is_expected.to show_check_your_answers_page }
  end

  context "when the step is `motoring_endorsement`" do
    let(:step_params) { { motoring_endorsement: GenericYesNo::YES } }

    it { is_expected.to have_destination(:known_date, :edit) }
  end

  context "when the step is `conviction_bail`" do
    let(:step_params) { { conviction_bail: answer } }

    context "and the answer is yes" do
      let(:answer) { GenericYesNo::YES }

      it { is_expected.to have_destination(:conviction_bail_days, :edit) }
    end

    context "and the answer is no" do
      let(:answer) { GenericYesNo::NO }

      it { is_expected.to have_destination(:known_date, :edit) }
    end
  end

  context "when the step is `conviction_bail_days`" do
    let(:step_params) { { conviction_bail_days: "whatever" } }

    it { is_expected.to have_destination(:known_date, :edit) }
  end
end
