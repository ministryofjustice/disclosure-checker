# The step including this concern will mark the record as `completed`.
# Some operations can't be done or differ on `completed` records as
# opposite to records with status `in_progress`.
#
module CompletionStep
  extend ActiveSupport::Concern

  included do
    before_action :check_disclosure_check_presence

    before_action :purge_incomplete_checks,
                  :allow_ga_transactions,
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

  # Because transactions can be triggered more than once for the same report,
  # we try to limit this by only triggering GA transactions for the report
  # just completed, but not on reloads, etc.
  #
  # This is specially important in the results page as it can be reloaded
  # multiple times or accessed to "replay" the results at a later date.
  #
  def allow_ga_transactions
    flash[:ga_track_completion] = true
  end
end
