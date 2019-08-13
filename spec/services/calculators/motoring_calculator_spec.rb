require 'rails_helper'

RSpec.describe Calculators::MotoringCalculator do
  subject { described_class.new(disclosure_check) }

  let(:disclosure_check) { build(:disclosure_check,
                                 known_date: known_date) }
  let(:known_date) { Date.new(2018, 10, 31) }

  it "expiry_date method is implemented in subclass" do
    expect {subject.expiry_date }.to raise_error(NotImplementedError)
  end

  describe Calculators::MotoringCalculator::StartPlusThreeYears do
    context '#expiry_date' do
      it { expect(subject.expiry_date.to_s).to eq('2021-10-31') }
    end
  end

  describe Calculators::MotoringCalculator::StartPlusFiveYears do
    context '#expiry_date' do
      it { expect(subject.expiry_date.to_s).to eq('2023-10-31') }
    end
  end
end
