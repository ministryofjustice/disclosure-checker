require 'rails_helper'

RSpec.describe Calculators::Multiples::Proceedings do
  subject { described_class.new(check_group) }

  let(:check_group) { instance_double(CheckGroup, disclosure_checks: disclosure_checks_scope) }
  let(:disclosure_checks_scope) { double('scope', completed: [disclosure_check1, disclosure_check2, disclosure_check3]) }

  let(:disclosure_check1) { instance_double(DisclosureCheck, kind: kind, conviction_date: conviction_date, drag_through?: false) }
  let(:disclosure_check2) { instance_double(DisclosureCheck, kind: kind, drag_through?: false) }
  let(:disclosure_check3) { instance_double(DisclosureCheck, kind: kind, drag_through?: true) }

  let(:check_result1) { instance_double(CheckResult, expiry_date: Date.new(2015, 10, 31)) }
  let(:check_result2) { instance_double(CheckResult, expiry_date: Date.new(2018, 10, 31)) }
  let(:check_result3) { instance_double(CheckResult, expiry_date: Date.new(2016, 10, 31)) }

  let(:check_spent_simple) { instance_double(CheckResult, expiry_date: ResultsVariant::SPENT_SIMPLE) }
  let(:check_never_spent) { instance_double(CheckResult, expiry_date: ResultsVariant::NEVER_SPENT) }
  let(:check_indefinite) { instance_double(CheckResult, expiry_date: ResultsVariant::INDEFINITE) }

  let(:kind) { 'conviction' }
  let(:conviction_date) { Date.new(2018, 1, 1) }

  describe '#size' do
    it { expect(subject.size).to eq(3) }
  end

  describe '#kind' do
    context 'for a caution' do
      let(:kind) { 'caution' }
      it { expect(subject.kind).to eq(CheckKind::CAUTION) }
    end

    context 'for a conviction' do
      let(:kind) { 'conviction' }
      it { expect(subject.kind).to eq(CheckKind::CONVICTION) }
    end
  end

  describe '#conviction?' do
    context 'for a caution' do
      let(:kind) { 'caution' }
      it { expect(subject.conviction?).to eq(false) }
    end

    context 'for a conviction' do
      let(:kind) { 'conviction' }
      it { expect(subject.conviction?).to eq(true) }
    end
  end

  context '#conviction_date' do
    it 'returns the date of the conviction (using the first sentence)' do
      expect(subject.conviction_date).to eq(conviction_date)
    end
  end

  context '#spent_date' do
    context 'when there is only one sentence and is a date' do
      before do
        allow(CheckResult).to receive(:new).and_return(check_result1)
      end

      it 'returns the spent date of the caution or conviction' do
        expect(subject.spent_date).to eq(Date.new(2015, 10, 31))
      end
    end

    context 'when there is only one sentence and is `spent_simple`' do
      before do
        allow(CheckResult).to receive(:new).and_return(check_spent_simple)
      end

      it 'returns the spent date of the caution or conviction' do
        expect(subject.spent_date).to eq(ResultsVariant::SPENT_SIMPLE)
      end
    end

    context 'when there is at least one `never_spent` date' do
      before do
        allow(CheckResult).to receive(:new).and_return(check_result1, check_result2, check_never_spent)
      end

      it 'returns `never_spent`' do
        expect(subject.spent_date).to eq(ResultsVariant::NEVER_SPENT)
      end
    end

    context 'when all individual spent dates are dates' do
      before do
        allow(CheckResult).to receive(:new).and_return(check_result1, check_result2, check_result3)
      end

      it 'picks the latest date' do
        expect(subject.spent_date).to eq(Date.new(2018, 10, 31))
      end
    end

    context 'when there is at least one `indefinite` date' do
      before do
        allow(CheckResult).to receive(:new).and_return(check_result1, check_result2, check_indefinite)
      end

      it 'returns `indefinite`' do
        expect(subject.spent_date).to eq(ResultsVariant::INDEFINITE)
      end
    end
  end

  describe '#spent_date_without_relevant_orders' do
    let(:disclosure_checks_scope) { double('scope', completed: [disclosure_check1, disclosure_check2]) }

    context 'filters our relevant orders' do
      context 'only some are relevant orders' do
        let(:disclosure_check1) { instance_double(DisclosureCheck, drag_through?: true) }
        let(:disclosure_check2) { instance_double(DisclosureCheck, drag_through?: false) }

        it 'calculates the spent_date of the non-relevant orders' do
          expect(subject).not_to receive(:expiry_date_for).with(disclosure_check1)
          expect(subject).to receive(:expiry_date_for).with(disclosure_check2).and_return('date')

          expect(subject.spent_date_without_relevant_orders).to eq('date')
        end
      end

      context 'all are relevant orders' do
        let(:disclosure_check1) { instance_double(DisclosureCheck, drag_through?: true) }
        let(:disclosure_check2) { instance_double(DisclosureCheck, drag_through?: true) }

        it 'returns a nil spent_date' do
          expect(subject).not_to receive(:expiry_date_for).with(disclosure_check1)
          expect(subject).not_to receive(:expiry_date_for).with(disclosure_check2)

          expect(subject.spent_date_without_relevant_orders).to be_nil
        end
      end
    end
  end
end
