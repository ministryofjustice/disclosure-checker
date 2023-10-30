require "rails_helper"

RSpec.describe HomeController, type: :controller do
  let!(:existing_disclosure_check) do
    DisclosureCheck.create(navigation_stack:)
  end

  describe "#index" do
    context "when an existing disclosure check in progress exists" do
      let(:status) { :in_progress }
      let(:navigation_stack) { %w[/1 /2 /3] }

      context "but the report is already completed" do
        before do
          existing_disclosure_check.disclosure_report.completed!
        end

        # it "redirects to /steps/check/kind" do
        #   get :index, session: { disclosure_check_id: existing_disclosure_check.id }
        #   expect(response).to redirect_to("/steps/check/kind")
        # end

        it "renders home page" do
          get :index
          expect(response).to render_template(:index)
        end

        it "resets the disclosure_check session data" do
          expect(session).to receive(:delete).with(:disclosure_check_id).ordered
          expect(session).to receive(:delete).with(:last_seen).ordered
          expect(session).to receive(:delete) # any other deletes
          get :index, session: { disclosure_check_id: existing_disclosure_check.id }
        end
      end

      context "with enough steps advanced" do
        context "and user bypass the warning" do
          # it "redirects to /steps/check/kind" do
          #   get :index, session: { disclosure_check_id: existing_disclosure_check.id }, params: { new: "y" }
          #   expect(response).to redirect_to("/steps/check/kind")
          # end

          it "renders home page" do
            get :index
            expect(response).to render_template(:index)
          end

          it "resets the disclosure_check session data" do
            expect(session).to receive(:delete).with(:disclosure_check_id).ordered
            expect(session).to receive(:delete).with(:last_seen).ordered
            expect(session).to receive(:delete) # any other deletes
            get :index, session: { disclosure_check_id: existing_disclosure_check.id }, params: { new: "y" }
          end

          it "resets the memoized `current_disclosure_check`" do
            # simulate memoization
            controller.instance_variable_set(:@current_disclosure_check, existing_disclosure_check)
            expect(controller.current_disclosure_check).not_to be_nil

            get :index, session: { disclosure_check_id: existing_disclosure_check.id }, params: { new: "y" }

            expect(controller.current_disclosure_check).to be_nil
          end
        end

        context "and user do not bypass the warning" do
          it "redirects to the warning page" do
            get :index, session: { disclosure_check_id: existing_disclosure_check.id }
            expect(response).to redirect_to(warning_reset_session_path)
          end

          it "does not reset any application session data" do
            expect(session).not_to receive(:delete).with(:disclosure_check_id).ordered
            expect(session).not_to receive(:delete).with(:last_seen).ordered
            get :index, session: { disclosure_check_id: existing_disclosure_check.id }
          end
        end
      end

      context "with not enough steps advanced" do
        let(:navigation_stack) { ["/1"] }

        before do
          allow(controller.helpers).to receive(:any_completed_checks?).and_return(any_completed_checks)
        end

        context "but at least one completed caution/conviction in the basket" do
          let(:any_completed_checks) { true }

          it "redirects to the warning page" do
            get :index, session: { disclosure_check_id: existing_disclosure_check.id }
            expect(response).to redirect_to(warning_reset_session_path)
          end

          it "does not reset any application session data" do
            expect(session).not_to receive(:delete).with(:disclosure_check_id).ordered
            expect(session).not_to receive(:delete).with(:last_seen).ordered
            get :index, session: { disclosure_check_id: existing_disclosure_check.id }
          end
        end

        context "without any completed caution/conviction in the basket" do
          let(:any_completed_checks) { false }

          # it "redirects to /steps/check/kind" do
          #   get :index, session: { disclosure_check_id: existing_disclosure_check.id }
          #   expect(response).to redirect_to("/steps/check/kind")
          # end

          it "renders home page" do
            get :index
            expect(response).to render_template(:index)
          end

          it "resets the disclosure check session data" do
            expect(session).to receive(:delete).with(:disclosure_check_id).ordered
            expect(session).to receive(:delete).with(:last_seen).ordered
            expect(session).to receive(:delete) # any other deletes
            get :index
          end
        end
      end
    end

    context "when no disclosure check exists in session" do
      let(:navigation_stack) { [] }

      # it "redirects to /steps/check/kind" do
      #   get :index
      #   expect(response).to redirect_to("/steps/check/kind")
      # end

      it "renders home page" do
        get :index
        expect(response).to render_template(:index)
      end

      it "resets the disclosure_checker session data" do
        expect(session).to receive(:delete).with(:disclosure_check_id).ordered
        expect(session).to receive(:delete).with(:last_seen).ordered
        expect(session).to receive(:delete) # any other deletes
        get :index
      end
    end
  end
end
