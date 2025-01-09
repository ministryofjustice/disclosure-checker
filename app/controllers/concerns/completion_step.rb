# The step including this concern will mark the record as `completed`.
# Some operations can't be done or differ on `completed` records as
# opposite to records with status `in_progress`.
#
module CompletionStep
  extend ActiveSupport::Concern

  included do
    before_action :check_disclosure_check_presence

    before_action :purge_incomplete_checks,
                  :mark_report_completed, unless: :report_completed?
  end

private

  def report_completed?
    current_disclosure_report.completed?
  end

  def mark_report_completed
    current_disclosure_report.completed!
  end

  # remove any incomplete checks as they don't serve any purpose now
  def purge_incomplete_checks
    current_disclosure_report.disclosure_checks.in_progress.destroy_all

    # It could happen the current session was one of the purged
    # incomplete checks, so this ensures we have a valid one again.
    swap_disclosure_check_session(
      current_disclosure_report.disclosure_checks.last.id,
    )
  end
end
