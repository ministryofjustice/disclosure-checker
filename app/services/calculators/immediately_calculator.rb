module Calculators
  class ImmediatelyCalculator < BaseCalculator
    def expiry_date
      conviction_start_date
    end
  end
end
