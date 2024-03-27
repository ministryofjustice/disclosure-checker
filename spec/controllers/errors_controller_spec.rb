require "spec_helper"

RSpec.describe ErrorsController, type: :controller do
  context "when invalid session" do
    it "renders the expected template" do
      get :invalid_session
      expect(response).to render_template(:invalid_session)
    end

    it "uses the expected status" do
      get :invalid_session
      expect(response).to be_not_found
    end
  end

  context "when not found" do
    it "renders the expected template" do
      get :not_found
      expect(response).to render_template(:not_found)
    end

    it "uses the expected status" do
      get :not_found
      expect(response).to be_not_found
    end
  end

  context "when results not found" do
    it "renders the expected template" do
      get :results_not_found
      expect(response).to render_template(:results_not_found)
    end

    it "uses the expected status" do
      get :results_not_found
      expect(response).to be_not_found
    end
  end

  context "when report completed" do
    it "renders the expected template" do
      get :report_completed
      expect(response).to render_template(:report_completed)
    end

    it "uses the expected status" do
      get :report_completed
      expect(response).to be_unprocessable
    end
  end

  context "when report not completed" do
    it "renders the expected template" do
      get :report_not_completed
      expect(response).to render_template(:report_not_completed)
    end

    it "uses the expected status" do
      get :report_not_completed
      expect(response).to be_unprocessable
    end
  end

  context "when unhandled" do
    it "renders the expected template" do
      get :unhandled
      expect(response).to render_template(:unhandled)
    end

    it "uses the expected status" do
      get :unhandled
      expect(response).to be_server_error
    end
  end

  context "when maintenance" do
    it "renders the expected template" do
      get :maintenance
      expect(response).to render_template(:maintenance)
    end

    it "uses the expected status" do
      get :maintenance
      expect(response.status).to eq 503
    end
  end
end
