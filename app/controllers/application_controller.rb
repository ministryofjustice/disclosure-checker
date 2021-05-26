class ApplicationController < ActionController::Base
  include SecurityHandling
  include ErrorHandling

  # This is required to get request attributes in to the production logs.
  # See the various lograge configurations in `production.rb`.
  def append_info_to_payload(payload)
    super
    payload[:referrer] = request&.referrer
    payload[:session_id] = request&.session&.id
    payload[:user_agent] = request&.user_agent
  end

  # With the ability to remove disclosure_check records we now look for
  # a disclosure_report when we can't find the last created disclosure_check.
  # This guarantees that any other disclosure_check records added by the user,
  # will be available to that user.
  def current_disclosure_check
    @_current_disclosure_check ||=
      DisclosureCheck.find_by_id(session[:disclosure_check_id]) ||
      DisclosureReport.find_by_id(session[:disclosure_report_id])&.disclosure_checks&.last
  end
  helper_method :current_disclosure_check

  def current_disclosure_report
    @_current_disclosure_report ||= current_disclosure_check&.disclosure_report
  end
  helper_method :current_disclosure_report

  def previous_step_path
    # Second to last element in the array, will be nil for arrays of size 0 or 1
    current_disclosure_check&.navigation_stack&.slice(-2) || root_path
  end
  helper_method :previous_step_path

  private

  def swap_disclosure_check_session(other_check_id)
    session[:disclosure_check_id] = current_disclosure_report.disclosure_checks.find_by!(id: other_check_id).id

    # ensure we don't have a memoized record anymore
    @_current_disclosure_check = nil
  end

  def reset_disclosure_check_session
    session.delete(:disclosure_report_id)
    session.delete(:disclosure_check_id)
    session.delete(:last_seen)

    # ensure we don't have a memoized record anymore
    @_current_disclosure_check = nil
  end

  def initialize_disclosure_check(attributes = {})
    DisclosureCheck.create(attributes).tap do |disclosure_check|
      session[:disclosure_check_id] = disclosure_check.id
      session[:disclosure_report_id] = disclosure_check.disclosure_report.id
    end
  end
end
