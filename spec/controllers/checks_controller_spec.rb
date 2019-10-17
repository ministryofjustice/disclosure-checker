require 'rails_helper'

RSpec.describe ChecksController, type: :controller do
  describe '#create' do
    context 'when there is no disclosure check in the session' do
      it 'redirects to the invalid session error page' do
        post :create
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when there is a disclosure check in the session' do
      let(:disclosure_check) { create(:disclosure_check) }
      let(:disclosure_report) { disclosure_check.disclosure_report }

      before do
        allow(controller).to receive(:current_disclosure_check).and_return(disclosure_check)
      end

      context 'for a new check in a separate proceeding' do
        it 'creates a new disclosure check in a new group inside current disclosure report' do
          expect {
            post :create
          }.to change { disclosure_report.check_groups.count }.by(1)
        end

        it 'redirects to the caution or conviction question (kind)' do
          post :create
          expect(response).to redirect_to(edit_steps_check_kind_path)
        end
      end

      context 'for a new check in an existing proceeding' do
        context 'when the group does not exist' do
          it 'raises an exception' do
            expect {
              post :create, params: { check_group_id: '123' }
            }.to raise_error
          end
        end

        it 'creates a new disclosure check in an existing group' do
          expect {
            post :create, params: { check_group_id: disclosure_check.check_group_id }
          }.not_to change { disclosure_report.check_groups.count }

          # we default to `conviction` kind as only conviction can be added to existing proceedings
          last_check = DisclosureCheck.last
          expect(last_check.kind).to eq(CheckKind::CONVICTION.to_s)
        end

        it 'redirects to the under age question' do
          post :create, params: { check_group_id: disclosure_check.check_group_id }
          expect(response).to redirect_to(edit_steps_check_under_age_path)
        end
      end
    end
  end
end
