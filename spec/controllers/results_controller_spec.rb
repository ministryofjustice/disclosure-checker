require 'rails_helper'

RSpec.describe ResultsController, type: :controller do
  describe '#show' do
   context 'when the disclosure report does not exist' do
      it 'redirects to the results not found error page' do
        get :show, params: { report_id: '123' }
        expect(response).to redirect_to(results_not_found_errors_path)
      end
    end

    context 'when the disclosure report exists' do
      let(:disclosure_check)  { create(:disclosure_check, status: :completed) }
      let(:disclosure_report) { disclosure_check.disclosure_report }

      before do
        allow(controller).to receive(:disclosure_report).and_return(disclosure_report)
      end

      it 'assigns the disclosure check to the current session' do
        expect(session[:disclosure_check_id]).to be_nil
        get :show, params: { report_id: disclosure_report.id }
        expect(session[:disclosure_check_id]).to eq(disclosure_check.id)
      end

      it 'redirects to the results page' do
        get :show, params: { report_id: disclosure_report.id }
        expect(response).to redirect_to('/steps/check/results')
      end
    end
  end
end
