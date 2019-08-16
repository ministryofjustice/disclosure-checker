# Calculator rules:
# If (conditions end date) - (caution given date) < 3 months: ends on condition end date
# If (conditions end date) - (caution given date) is greater than or equal to 3 months: ends on caution given date + 3 months
module Calculators
  class ConditionalCautionCalculator < BaseCalculator
    CAUTION_EXTRA_SPENT_DURATION = { months: 3 }.freeze

    def expiry_date
      return conditional_end_date if distance_in_months(caution_date, conditional_end_date) < 3

      caution_date.advance(CAUTION_EXTRA_SPENT_DURATION)
    end

    private

    def conditional_end_date
      @conditional_end_date ||= disclosure_check.conditional_end_date
    end

    def caution_date
      @caution_date ||= disclosure_check.known_date
    end
  end
end
