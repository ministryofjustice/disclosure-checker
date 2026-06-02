require "rails_helper"

RSpec.describe ApplicationController do
  controller do
    def my_url = true
    def invalid_session = raise(Errors::InvalidSession)
    def results_not_found = raise(Errors::ResultsNotFound)
    def report_completed = raise(Errors::ReportCompleted)
    def report_not_completed = raise(Errors::ReportNotCompleted)
    def maintenance = raise(ActiveRecord::ConnectionNotEstablished)
    def another_exception = raise(StandardError)
  end

  before do
    # Stub the value on the REAL config object instead of replacing the config object with a double
    allow(Rails.application.config).to receive(:consider_all_requests_local).and_return(false)

    # Similarly, avoid message_chain here by stubbing on the real nested object
    allow(Rails.configuration.x.session).to receive(:expires_in_minutes).and_return(1)
  end

  describe "Exceptions handling" do
    context "when Errors::InvalidSession" do
      it "does not report the exception, and redirect to the error page" do
        routes.draw { get "invalid_session" => "anonymous#invalid_session" }

        expect(Sentry).not_to receive(:capture_exception)

        get :invalid_session
        expect(response).to redirect_to(invalid_session_errors_path)
      end
    end

    context "when Errors::ResultsNotFound" do
      it "does not report the exception, and redirect to the error page" do
        routes.draw { get "results_not_found" => "anonymous#results_not_found" }

        expect(Sentry).not_to receive(:capture_exception)

        get :results_not_found
        expect(response).to redirect_to(results_not_found_errors_path)
      end
    end

    context "when Errors::ReportCompleted" do
      it "does not report the exception, and redirect to the error page" do
        routes.draw { get "report_completed" => "anonymous#report_completed" }

        expect(Sentry).not_to receive(:capture_exception)

        get :report_completed
        expect(response).to redirect_to(report_completed_errors_path)
      end
    end

    context "when Errors::ReportNotCompleted" do
      it "does not report the exception, and redirect to the error page" do
        routes.draw { get "report_not_completed" => "anonymous#report_not_completed" }

        expect(Sentry).not_to receive(:capture_exception)

        get :report_not_completed
        expect(response).to redirect_to(report_not_completed_errors_path)
      end
    end

    context "when ActiveRecord::ConnectionNotEstablished" do
      it "reports the exception, and redirect to the error page" do
        routes.draw { get "maintenance" => "anonymous#maintenance" }

        expect(Sentry).to receive(:capture_exception)

        get :maintenance
        expect(response).to redirect_to(maintenance_errors_path)
      end
    end

    context "when other exceptions" do
      it "reports the exception, and redirect to the error page" do
        routes.draw { get "another_exception" => "anonymous#another_exception" }

        expect(Sentry).to receive(:capture_exception)

        get :another_exception
        expect(response).to redirect_to(unhandled_errors_path)
      end
    end
  end
end
