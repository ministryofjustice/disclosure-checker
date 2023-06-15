require "rails_helper"

RSpec.describe WarningController, type: :controller do
  before do
    allow(controller).to receive(:current_disclosure_check).and_return(existing_disclosure_check)
  end

  describe "#reset_session" do
    context "when an existing check exists in session" do
      let(:existing_disclosure_check) { DisclosureCheck.create(navigation_stack: []) }

      it "responds with HTTP success" do
        get :reset_session, session: { disclosure_check_id: existing_disclosure_check.id }
        expect(response).to render_template(:reset_session)
      end
    end

    context "when no check exists in session" do
      let(:existing_disclosure_check) { nil }

      it "redirects to the invalid session error page" do
        get :reset_session
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end
  end
end
