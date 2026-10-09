require "rails_helper"

RSpec.describe StatusController, type: :controller do
  # This is very-happy-path to ensure the controller responds.  The bulk of the
  # status is tested in spec/services/status_spec.rb.
  describe "#index" do
    let(:status) { instance_double(DisclosureCheckerApp::Status, result:, success?: success) }

    let(:result) do
      {
        service_status: "ok",
        dependencies: {
          database_status: "ok",
          courtfinder_status: "ok",
        },
      }.to_json
    end

    before do
      allow(DisclosureCheckerApp::Status).to receive(:new).and_return(status)
    end

    context "when a healthy service" do
      let(:success) { true }

      it "has a 200 response code" do
        get :index, format: :json
        expect(response.status).to eq(200)
      end

      it "returns json" do
        get :index, format: :json
        expect(response.body).to eq(result)
      end
    end

    context "when a non healthy service" do
      let(:success) { false }

      it "has a 503 response code" do
        get :index, format: :json
        expect(response.status).to eq(503)
      end

      it "returns json" do
        get :index, format: :json
        expect(response.body).to eq(result)
      end
    end
  end

  describe "#ping" do
    it "has a 200 response code" do
      get :ping, format: :json
      expect(response.status).to eq(200)
    end

    it "returns a minimal status with no build detail" do
      get :ping, format: :json
      expect(JSON.parse(response.body)).to eq("status" => "ok")
    end
  end

  describe "#deploy_info" do
    before do
      allow(ENV).to receive(:fetch).and_call_original
      allow(ENV).to receive(:fetch).with("DEPLOY_DASHBOARD_SHARED_SECRET", nil).and_return("test-secret")
    end

    context "with a valid shared secret" do
      before { request.headers["X-Deploy-Dashboard-Secret"] = "test-secret" }

      it "returns the expected payload" do
        get :deploy_info, format: :json
        expect(
          JSON.parse(response.body).keys,
        ).to eq(%w[build_date build_tag commit_id])
      end
    end

    context "with an invalid shared secret" do
      before { request.headers["X-Deploy-Dashboard-Secret"] = "wrong-secret" }

      it "returns unauthorized" do
        get :deploy_info, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end

    context "without a shared secret header" do
      it "returns unauthorized" do
        get :deploy_info, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end
