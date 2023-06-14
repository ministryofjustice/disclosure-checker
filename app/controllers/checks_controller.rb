class ChecksController < ApplicationController
  before_action :check_disclosure_check_presence

  def create
    if check_group_id
      # add another sentence to an existing conviction (same proceedings)
      initialize_disclosure_check(
        navigation_stack:,
        kind: CheckKind::CONVICTION.value,
        under_age: first_check_in_group.under_age,
        conviction_date: first_check_in_group.conviction_date,
        check_group:,
      )

      redirect_to edit_steps_conviction_conviction_type_path
    else
      # add a new caution or conviction (separate proceedings)
      initialize_disclosure_check(
        navigation_stack:,
        disclosure_report: current_disclosure_report,
      )

      redirect_to edit_steps_check_kind_path
    end
  end

private

  def check_group_id
    params[:check_group_id]
  end

  def check_group
    @check_group ||= current_disclosure_report.check_groups.find(check_group_id)
  end

  def first_check_in_group
    @first_check_in_group ||= check_group.disclosure_checks.first
  end

  # New checks created through this controller will start
  # with the following paths in the stack.
  def navigation_stack
    [steps_check_check_your_answers_path]
  end
end
