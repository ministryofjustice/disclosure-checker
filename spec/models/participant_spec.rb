require 'rails_helper'

RSpec.describe Participant, type: :model do
  subject { described_class.new(attributes) }

  let(:attributes) { {} }

  # Avoid saving to the database
  before do
    allow(subject).to receive(:save).and_return(true)
  end

  describe '.valid_reference?' do
    context 'for a valid reference' do
      let(:reference) { 'test' }
      it { expect(described_class.valid_reference?(reference)).to eq(true) }
    end

    context 'for an invalid reference' do
      let(:reference) { 'foobar' }
      it { expect(described_class.valid_reference?(reference)).to eq(false) }
    end

    context 'for a blank reference' do
      let(:reference) { '' }
      it { expect(described_class.valid_reference?(reference)).to eq(false) }
    end
  end

  describe '.touch_or_create_by' do
    # Avoid saving to the database
    before do
      allow(Participant).to receive(:find_or_create_by).with(reference: 'test').and_return(subject)
    end

    it 'delegates to `find_or_create_by`' do
      expect(described_class.touch_or_create_by(reference: 'test')).to eq(subject)
    end

    it 'increments the `access_count` attribute' do
      expect {
        described_class.touch_or_create_by(reference: 'test')
      }.to change { subject.access_count }.by(1)
    end
  end

  describe '#increment_access_count' do
    it 'increments the `access_count` attribute' do
      expect {
        subject.increment_access_count
      }.to change { subject.access_count }.by(1)
    end

    it 'returns the instance' do
      expect(subject.increment_access_count).to eq(subject)
    end
  end

  describe 'scopes' do
    let!(:opted_out_participant) { create(:participant, :opted_out) }
    let!(:opted_in_participant) { create(:participant) }

    context ".opted_in" do
      it "return all opted_in participant" do
        expect(Participant.opted_in).to eq [opted_in_participant]
      end
    end

    context ".opted_out" do
      it "return all opted_ou participant" do
        expect(Participant.opted_out).to eq [opted_out_participant]
      end
    end
  end
end
