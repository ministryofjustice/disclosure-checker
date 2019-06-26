# Calculator rules:
# conviction start date + 6 months
module Calculators
  class FineCalculator < BaseCalculator
    SPENT_TIME = { months: 6 }.freeze
    def expiry_date
      conviction_start_date.advance(SPENT_TIME)
    end
  end
end
