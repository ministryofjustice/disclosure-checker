class ResultsController < ApplicationController
  before_action :setup_session

  def show
    redirect_to steps_check_results_path
  end

  private

  def disclosure_report
    @_disclosure_report ||= DisclosureReport.completed.find_by(
      id: params[:report_id]
    ) || (raise Errors::ResultsNotFound)
  end

  def setup_session
    # We pick a `check` from the report, any check will do
    session[:disclosure_check_id] = disclosure_report.disclosure_checks.last.id
  end
end
