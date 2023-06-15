module StartingPointStep
  extend ActiveSupport::Concern

private

  def current_disclosure_check
    # Only the step including this concern should create a disclosure check
    # if there isn't one in the session - because it's the first
    super || initialize_disclosure_check
  end
end
