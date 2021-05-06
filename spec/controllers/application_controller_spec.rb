require 'rails_helper'

RSpec.describe ApplicationController do
  controller do
    def my_url; true; end
    def invalid_session; raise Errors::InvalidSession; end
    def results_not_found; raise Errors::ResultsNotFound; end
    def report_completed; raise Errors::ReportCompleted; end
    def report_not_completed; raise Errors::ReportNotCompleted; end
    def another_exception; raise Exception; end
  end

  before do
    allow(Rails.application).to receive_message_chain(:config, :consider_all_requests_local).and_return(false)
    allow(Rails.configuration).to receive_message_chain(:x, :session, :expires_in_minutes).and_return(1)
  end

  context 'Exceptions handling' do
    context 'Errors::InvalidSession' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'invalid_session' => 'anonymous#invalid_session' }

        expect(Raven).not_to receive(:capture_exception)

        get :invalid_session
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context 'Errors::ResultsNotFound' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'results_not_found' => 'anonymous#results_not_found' }

        expect(Raven).not_to receive(:capture_exception)

        get :results_not_found
        expect(response).to redirect_to(results_not_found_errors_path)
      end
    end

    context 'Errors::ReportCompleted' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'report_completed' => 'anonymous#report_completed' }

        expect(Raven).not_to receive(:capture_exception)

        get :report_completed
        expect(response).to redirect_to(report_completed_errors_path)
      end
    end

    context 'Errors::ReportNotCompleted' do
      it 'should not report the exception, and redirect to the error page' do
        routes.draw { get 'report_not_completed' => 'anonymous#report_not_completed' }

        expect(Raven).not_to receive(:capture_exception)

        get :report_not_completed
        expect(response).to redirect_to(report_not_completed_errors_path)
      end
    end

    context 'Other exceptions' do
      it 'should report the exception, and redirect to the error page' do
        routes.draw { get 'another_exception' => 'anonymous#another_exception' }

        expect(Raven).to receive(:capture_exception)

        get :another_exception
        expect(response).to redirect_to(unhandled_errors_path)
      end
    end
  end
end
