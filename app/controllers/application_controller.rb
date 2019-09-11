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

  def current_disclosure_check
    @_current_disclosure_check ||= DisclosureCheck.find_by_id(session[:disclosure_check_id])
  end
  helper_method :current_disclosure_check

  def previous_step_path
    # Second to last element in the array, will be nil for arrays of size 0 or 1
    current_disclosure_check&.navigation_stack&.slice(-2) || root_path
  end
  helper_method :previous_step_path

  private

  def reset_disclosure_check_session
    session.delete(:disclosure_check_id)
    session.delete(:last_seen)

    # ensure we don't have a memoized record anymore
    @_current_disclosure_check = nil
  end

  def initialize_disclosure_check(attributes = {})
    DisclosureCheck.create(attributes).tap do |disclosure_check|
      session[:disclosure_check_id] = disclosure_check.id
    end
  end
end
