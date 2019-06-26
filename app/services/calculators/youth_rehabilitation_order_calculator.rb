# Calculator rules:
# If conviction length is given: conviction start date + conviction length + 6 months
# If no conviction length is given: conviction start date + 24 months
module Calculators
  class YouthRehabilitationOrderCalculator < BaseCalculator
    SPENT_DURATION_WITH_LENGTH = { months: 6 }.freeze
    SPENT_DURATION_WITH_NO_LENGTH = { months: 24 }.freeze

    def expiry_date
      # TODO: Update when no length option is added
      return conviction_start_date.advance(SPENT_DURATION_WITH_NO_LENGTH) if no_length?

      conviction_end_date.advance(SPENT_DURATION_WITH_LENGTH)
    end

    private

    def no_length?
      disclosure_check.conviction_length.nil?
    end
  end
end
