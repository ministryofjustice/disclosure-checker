require 'rails_helper'

RSpec.describe DisclosureCheck, type: :model do
  subject { described_class.new(attributes) }

  let(:attributes) { {} }

  describe '#conviction' do
    let(:attributes) { { conviction_subtype: 'adult_criminal_behaviour' } }

    it 'returns the ConvictionType value-object' do
      expect(subject.conviction).to eq(ConvictionType::ADULT_CRIMINAL_BEHAVIOUR)
    end

    it 'returns nil for caution' do
      expect(subject.caution).to be_nil
    end
  end

  describe '#caution' do
    let(:attributes) { { caution_type: 'adult_simple_caution' } }

    it 'returns the CautionType value-object' do
      expect(subject.caution).to eq(CautionType::ADULT_SIMPLE_CAUTION)
    end

    it 'returns nil for conviction' do
      expect(subject.conviction).to be_nil
    end
  end

  describe '#drag_through?' do
    it 'delegates to the conviction' do
      expect(subject).to receive(:conviction)
      subject.drag_through?
    end
  end
end
