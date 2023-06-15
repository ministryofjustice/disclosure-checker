require "rails_helper"

RSpec.describe ChecksController, type: :controller do
  describe "#create" do
    context "when there is no disclosure check in the session" do
      it "redirects to the invalid session error page" do
        post :create
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context "when there is a disclosure check in the session" do
      let(:disclosure_check) { create(:disclosure_check, conviction_date:) }
      let(:disclosure_report) { disclosure_check.disclosure_report }
      let(:conviction_date) { Date.new(2018, 10, 25) }

      before do
        allow(controller).to receive(:current_disclosure_check).and_return(disclosure_check)
      end

      context "with a new check in a separate proceeding" do
        it "creates a new disclosure check in a new group inside current disclosure report" do
          expect {
            post :create
          }.to change { disclosure_report.check_groups.count }.by(1)
        end

        it "defaults some attributes" do
          post :create, params: { check_group_id: disclosure_check.check_group_id }

          last_check = DisclosureCheck.last

          # the back link should point to CYA page
          expect(last_check.navigation_stack).to eq([steps_check_check_your_answers_path])
        end

        it "redirects to the caution or conviction question (kind)" do
          post :create
          expect(response).to redirect_to(edit_steps_check_kind_path)
        end
      end

      context "with a new check in an existing proceeding" do
        context "when the group does not exist" do
          it "raises an exception" do
            expect {
              post :create, params: { check_group_id: "123" }
            }.to raise_error(ActiveRecord::RecordNotFound)
          end
        end

        it "creates a new disclosure check in an existing group" do
          expect {
            post :create, params: { check_group_id: disclosure_check.check_group_id }
          }.not_to(change { disclosure_report.check_groups.count })
        end

        it "defaults some attributes" do
          post :create, params: { check_group_id: disclosure_check.check_group_id }

          last_check = DisclosureCheck.last

          # we default to `conviction` kind as only convictions can be added to existing proceedings
          expect(last_check.kind).to eq(CheckKind::CONVICTION.to_s)

          # we default to the age of the first conviction in the group, as all convictions must
          # have happened at the same age
          expect(last_check.under_age).to eq(GenericYesNo::YES.to_s)

          # we default the conviction date, as all sentences in the same conviction share this date
          expect(last_check.conviction_date).to eq(conviction_date)

          # the back link should point to CYA page
          expect(last_check.navigation_stack).to eq([steps_check_check_your_answers_path])
        end

        it "redirects to the conviction type question" do
          post :create, params: { check_group_id: disclosure_check.check_group_id }
          expect(response).to redirect_to(edit_steps_conviction_conviction_type_path)
        end
      end
    end
  end
end
