require 'rails_helper'

RSpec.describe Steps::Mvp::ConfirmationController, type: :controller do
  it 'responds with HTTP success' do
    get :show
    expect(response).to be_successful
  end
end
