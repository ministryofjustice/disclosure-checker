require "rails_helper"

RSpec.describe CheckDecisionTree do
  subject do
    described_class.new(
      disclosure_check:, step_params:, as:, next_step:,
    )
  end

  let(:disclosure_report) { DisclosureReport.new }

  let(:disclosure_check) do
    build(:disclosure_check, kind:, under_age:, disclosure_report:)
  end

  let(:step_params)      { instance_double("Step") }
  let(:next_step)        { nil }
  let(:as)               { nil }
  let(:kind)             { nil }
  let(:under_age)        { nil }
  let(:remove_check)     { nil }

  it_behaves_like "a decision tree"

  context "when the step is `kind`" do
    let(:step_params) { { kind: "whatever" } }

    it { is_expected.to have_destination(:under_age, :edit) }
  end

  context "when the step is `under_age`" do
    let(:step_params) { { under_age: } }

    context "and answer is `no`" do
      let(:under_age) { GenericYesNo::NO }

      context "when a caution check" do
        let(:kind) { "caution" }

        it { is_expected.to have_destination("/steps/caution/caution_type", :edit) }
      end

      context "when a conviction check" do
        let(:kind) { "conviction" }

        it { is_expected.to have_destination("/steps/conviction/conviction_date", :edit) }
      end
    end

    context "and answer is `yes`" do
      let(:under_age) { GenericYesNo::YES }

      context "when a caution check" do
        let(:kind) { "caution" }

        it { is_expected.to have_destination("/steps/caution/caution_type", :edit) }
      end

      context "when a conviction check" do
        let(:kind) { "conviction" }

        it { is_expected.to have_destination("/steps/conviction/conviction_date", :edit) }
      end
    end
  end

  context "when the step is `remove_check`" do
    let(:step_params) { { remove_check: } }

    context "and the answer is `yes`" do
      let(:remove_check) { GenericYesNo::YES }

      it { is_expected.to have_destination("/steps/check/kind", :edit) }
    end

    context "and whe answer is `no`" do
      let(:remove_check) { GenericYesNo::NO }

      it { is_expected.to have_destination("/steps/check/check_your_answers", :show) }
    end

    context "and there are other disclosure checks in the same disclosure report" do
      let(:remove_check) { GenericYesNo::YES }

      before do
        group = disclosure_report.check_groups.build
        group.disclosure_checks << build(:disclosure_check, :suspended_prison_sentence, :completed)

        group.save!
      end

      it { is_expected.to have_destination("/steps/check/check_your_answers", :show) }
    end
  end
end
