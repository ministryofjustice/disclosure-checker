require 'rails_helper'

RSpec.describe CheckResult do
  subject { described_class.new(disclosure_check: disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check, kind,
                                 known_date: Date.new(2018, 10, 31)) }

  context '#expiry_date' do
    context 'for a caution' do
      let(:kind) { :adult_caution }

      it 'will call a calculator' do
        expect(subject).to receive(:calculator).and_call_original
        subject.expiry_date
      end

      it { expect(subject.calculator).to be_an_instance_of(Calculators::CautionCalculator) }
    end

    context 'for a conviction' do
      let(:kind) { :dto_conviction }

      it 'will call a calculator' do
        expect(subject).to receive(:calculator).and_call_original
        subject.expiry_date
      end

      it { expect(subject.calculator).to be_an_instance_of(Calculators::SentenceCalculator::DetentionTraining) }
    end

    context 'for an unknown `kind`' do
      let(:disclosure_check) { DisclosureCheck.new(kind: 'foobar') }

      it 'should raise an exception' do
        expect { expect(subject.calculator) }.to raise_error
      end
    end
  end
end
