require "rails_helper"

RSpec.describe ReportsController, type: :controller do
  describe "#finish" do
    let(:current_disclosure_check)  { create(:disclosure_check, status: :completed) }
    let(:current_disclosure_report) { current_disclosure_check.disclosure_report }

    def perform_call
      put :finish, params: { report_id: :current }, session: { disclosure_check_id: "123" }
    end

    context "when no disclosure check exists in the session" do
      before do
        # Needed because some specs that include these examples stub current_disclosure_check,
        # which is undesirable for this particular test
        allow(controller).to receive(:current_disclosure_check).and_return(nil)
      end

      it "redirects to the invalid session error page" do
        put :finish, params: { report_id: :current }
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    describe "marking as completed" do
      before do
        allow(controller).to receive_messages(current_disclosure_check:, current_disclosure_report:)
      end

      context "when the report is not already marked as `completed`" do
        it "calls the `purge_incomplete_checks` method" do
          expect(controller).to receive(:mark_report_completed)
          expect(controller).to receive(:purge_incomplete_checks)

          perform_call
        end

        it "ensures there is a disclosure check in the session" do
          expect(
            controller,
          ).to receive(:swap_disclosure_check_session).with(
            current_disclosure_check.id,
          )

          perform_call
        end

        it "sets the flash to track transactions" do
          perform_call
          expect(controller.request.flash[:ga_track_completion]).to be(true)
        end

        it "calls the `completed!` method" do
          expect(current_disclosure_report).to receive(:completed!)
          perform_call
        end
      end

      context "when the report is already marked as `completed`" do
        before do
          current_disclosure_report.completed!
        end

        it "does not call the `purge_incomplete_checks` method" do
          expect(controller).not_to receive(:purge_incomplete_checks)
          perform_call
        end

        it "does not set the flash" do
          perform_call
          expect(controller.request.flash[:ga_track_completion]).to be_nil
        end

        it "does not call the `completed!` method" do
          expect(current_disclosure_report).not_to receive(:completed!)
          perform_call
        end
      end
    end
  end
end
