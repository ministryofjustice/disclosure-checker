require 'rails_helper'

RSpec.describe Backoffice::ReportsController, type: :controller do
  before do
    allow(controller).to receive(:check_http_credentials)
  end

  it 'responds with HTTP success' do
    get :index
    expect(response).to be_successful
  end

  it 'renders the reports page' do
    get :index
    expect(response).to render_template(:index)
  end

  context 'when using credentials' do
    before do
      allow(controller).to receive(:check_http_credentials).and_call_original
    end

    it 'responds with HTTP success' do
      get :index
      expect(response).to have_http_status(:unauthorized)
    end
  end
end
