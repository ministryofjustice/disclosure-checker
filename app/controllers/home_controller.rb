class HomeController < ApplicationController
  before_action :existing_disclosure_check_warning, :reset_disclosure_check_session

  def index
    # redirect_to steps_check_kind_path
  end

private

  def in_progress_enough?
    current_disclosure_report&.in_progress? &&
      (current_disclosure_check.navigation_stack.size > 1 || helpers.any_completed_checks?)
  end

  def existing_disclosure_check_warning
    return unless in_progress_enough? && !params.key?(:new)

    redirect_to warning_reset_session_path
  end
end
