require "rails_helper"

RSpec.describe Steps::ChecksController, type: :controller do
  describe "#edit" do
    let(:disclosure_check) { DisclosureCheck.create(status: :in_progress) }

    before do
      allow(controller).to receive(:current_disclosure_check).and_return(disclosure_check)
    end

    context "when there is a valid disclosure check" do
      it "render template" do
        get :edit, params: { id: disclosure_check.id }
        expect(response).to render_template(:edit)
      end
    end

    context "when the disclosure report is completed" do
      before do
        disclosure_check.disclosure_report.completed!
      end

      it "redirects to the report completed error page" do
        get :edit, params: { id: disclosure_check.id }
        expect(response).to redirect_to(report_completed_errors_path)
      end
    end
  end

  describe "#update" do
    let(:disclosure_check) { DisclosureCheck.create(status: :in_progress) }
    let(:expected_params) { { steps_check_remove_check_form: { remove_check: } } }

    before do
      allow(controller).to receive(:current_disclosure_check).and_return(disclosure_check)
    end

    context "when the check is not removed" do
      let(:remove_check) { "no" }

      it "redirects to check your answers" do
        put :update, params: expected_params.merge(id: disclosure_check.id)
        expect(response).to redirect_to steps_check_check_your_answers_path
      end
    end

    context "when the check is removed" do
      let(:remove_check) { "yes" }

      it "redirects to start page with warning bypass" do
        put :update, params: expected_params.merge(id: disclosure_check.id)
        expect(response).to redirect_to steps_check_kind_path(new: "y")
      end
    end
  end
end
