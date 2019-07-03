# Calculator rules:
# conviction start date + 6 months
module Calculators
  class ConvictionStartDatePlusAddedTimeCalculator < BaseCalculator
    ADDED_TIME = { months: 6 }.freeze
    def expiry_date
      conviction_start_date.advance(ADDED_TIME)
    end
  end
end
