module ErrorHandling
  extend ActiveSupport::Concern

  included do
    rescue_from Exception do |exception|
      return if on_error_page?

      case exception
      when Errors::InvalidSession, ActionController::InvalidAuthenticityToken
        redirect_to invalid_session_errors_path
      when Errors::ResultsNotFound
        redirect_to results_not_found_errors_path
      when Errors::ReportCompleted
        redirect_to report_completed_errors_path
      when Errors::ReportNotCompleted
        redirect_to report_not_completed_errors_path
      when ActiveRecord::ConnectionNotEstablished
        Sentry.capture_exception(exception)
        redirect_to maintenance_errors_path
      else
        raise if Rails.application.config.consider_all_requests_local

        Sentry.capture_exception(exception)
        redirect_to unhandled_errors_path
      end
    end
  end

private

  def on_error_page?
    controller_name == "errors"
  end

  def check_disclosure_check_presence
    raise Errors::InvalidSession unless current_disclosure_check
  end

  def check_disclosure_report_not_completed
    raise Errors::ReportCompleted if current_disclosure_report.completed?
  end

  def check_disclosure_report_completed
    raise Errors::ReportNotCompleted unless current_disclosure_report.completed?
  end
end
