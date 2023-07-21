require "rails_helper"

RSpec.describe Backoffice::ReportsController, type: :controller do
  it "responds with HTTP success" do
    get :index
    expect(response).to be_successful
  end

  it "renders the reports page" do
    get :index
    expect(response).to render_template(:index)
  end

  it "sorts by sentences" do
    get :index, params: { sentences: 1 }
    expect(response).to render_template(:index)
  end

end
