require 'spec_helper'

RSpec.describe Steps::Conviction::ConvictionTypeForm do
  let(:arguments) do
    {
      disclosure_check: disclosure_check,
      conviction_type: conviction_type
    }
  end

  let(:under_age) { true }
  let(:disclosure_check) { instance_double(DisclosureCheck, conviction_type: conviction_type, under_age: under_age) }
  let(:conviction_type) { nil }

  subject { described_class.new(arguments) }

  describe '.choices' do
    it 'returns the relevant choices' do
      expect(described_class.choices).to eq(%w(
        community_order
        custodial_sentence
        discharge
        financial
        hospital_guard_order
      ))
    end
  end

  describe '#save' do
    it_behaves_like 'a value object form', attribute_name: :conviction_type, example_value: 'discharge'

    context 'when form is valid' do
      let(:conviction_type) { 'discharge' }

      it 'saves the record' do
        expect(disclosure_check).to receive(:update).with(
          conviction_type: 'discharge'
        ).and_return(true)

        expect(subject.save).to be(true)
      end
    end
  end
end
