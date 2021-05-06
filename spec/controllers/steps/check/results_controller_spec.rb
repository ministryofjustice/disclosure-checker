require 'rails_helper'

RSpec.describe Steps::Check::ResultsController, type: :controller do
  describe '#show' do
    let(:disclosure_check) { build(:disclosure_check) }

    before do
      allow(controller).to receive(:current_disclosure_check).and_return(disclosure_check)
    end

    context 'when there is no disclosure check in the session' do
      before do
        allow(controller).to receive(:current_disclosure_check).and_return(nil)
      end

      it 'redirects to the invalid session error page' do
        get :show
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'when there is a disclosure report in the session' do
      let(:disclosure_check) { DisclosureCheck.create(status: :in_progress) }

      context 'when the disclosure report is completed' do
        before do
          disclosure_check.disclosure_report.completed!
        end

        it 'does not return an error, and renders the template' do
          get :show, session: { disclosure_check_id: disclosure_check.id }
          expect(response).to render_template(:show)
        end
      end

      context 'when the disclosure report is not yet completed' do
        it 'does redirects to the error page' do
          get :show, session: { disclosure_check_id: disclosure_check.id }
          expect(response).to redirect_to(report_not_completed_errors_path)
        end
      end
    end
  end
end
