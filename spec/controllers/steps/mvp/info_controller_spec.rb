require 'rails_helper'

RSpec.describe Steps::Mvp::InfoController, type: :controller do
  let(:participant) { Participant.new }
  let(:reference) { 'test' }

  # Avoid saving to the database
  before do
    allow(Participant).to receive(:find_or_create_by).with(reference: reference).and_return(participant)
    allow(participant).to receive(:save).and_return(true)
  end

  describe '#edit' do
    let(:expected_params) { { id: reference } }

    it 'responds with HTTP success' do
      get :edit, params: expected_params
      expect(response).to be_successful
    end

    it 'raises an error if the reference is not present' do
      expect {
        get :edit
      }.to raise_error(RuntimeError, "Participant reference not found: ''")
    end

    it 'raises an error if the reference is invalid' do
      expect {
        get :edit, params: { id: 'foobar' }
      }.to raise_error(RuntimeError, "Participant reference not found: 'foobar'")
    end
  end
end
