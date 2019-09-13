require 'rails_helper'

RSpec.describe Backoffice::ParticipantsController, type: :controller do
  let!(:opted_out_participants) { create(:participant, :opted_out) }
  let!(:opted_in_participants) { create(:participant) }

  it 'responds with HTTP success' do
    get :index
    expect(response).to be_successful
  end

  it 'renders the participants page' do
    get :index
    expect(assigns[:opted_out_participants]).not_to be_nil
    expect(assigns[:opted_in_participants]).not_to be_nil
    expect(response).to render_template(:index)
  end
end
