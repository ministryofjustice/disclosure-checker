# Calculator rules:
#
# For simple cautions:
#   - Spent date is always the caution given date
#
# For conditional cautions:
#   - If (conditions end date) - (caution given date) < 3 months, ends on condition end date
#   - If (conditions end date) - (caution given date) is greater than or equal to 3 months, ends on caution given date + 3 months
#
module Calculators
  class CautionCalculator < BaseCalculator
    CONDITIONAL_ADDED_TIME = { months: 3 }.freeze

    def expiry_date
      return ResultsVariant::SPENT_SIMPLE unless conditional?
      return conditional_end_date if distance_in_months(caution_date, conditional_end_date) < 3

      caution_date.advance(CONDITIONAL_ADDED_TIME)
    end

  private

    def conditional?
      CautionType.new(disclosure_check.caution_type).conditional?
    end

    def conditional_end_date
      disclosure_check.conditional_end_date
    end

    def caution_date
      disclosure_check.known_date
    end
  end
end
