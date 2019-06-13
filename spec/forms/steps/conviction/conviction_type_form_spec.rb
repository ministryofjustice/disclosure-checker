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
    context 'under age conviction type' do
      it 'returns the relevant choices' do
        expect(subject.choices).to eq(%w(
          community_order
          custodial_sentence
          discharge
          financial
          hospital_guard_order
        ))
      end
    end


    context 'All conviction type' do
      let(:under_age) { false }

      it 'returns the relevant choices' do
        expect(subject.choices).to eq(%w(
          community_order
          custodial_sentence
          discharge
          financial
          motoring
          hospital_guard_order
        ))
      end
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
