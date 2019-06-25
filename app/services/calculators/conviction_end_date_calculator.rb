module Calculators
  class ConvictionEndDateCalculator < BaseCalculator
    def expiry_date
      disclosure_check.known_date.advance(conviction_length)
    end
  end
end
