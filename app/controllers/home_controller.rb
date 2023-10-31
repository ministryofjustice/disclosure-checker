class HomeController < ApplicationController
  before_action :existing_disclosure_check_warning

  def index
    if params[:new] == "y"
      redirect_to steps_check_kind_path
    else
      @continue_link ||= edit_steps_check_kind_path # rubocop:disable Naming/MemoizedInstanceVariableName
    end
  end

private

  def in_progress_enough?
    current_disclosure_report&.in_progress? &&
      (current_disclosure_check.navigation_stack.size > 1 || helpers.any_completed_checks?)
  end

  def existing_disclosure_check_warning
    if in_progress_enough? && !params.key?(:new)
      @continue_link = warning_reset_session_path
    else
      reset_disclosure_check_session
    end
  end
end
