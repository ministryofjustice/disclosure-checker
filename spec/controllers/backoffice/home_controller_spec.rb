require "rails_helper"

RSpec.describe Backoffice::HomeController, type: :controller do
  it "responds with redirect" do
    get :index
    expect(response).to be_redirect
  end
end
