# Calculator rules:
# Compensation payment date
module Calculators
  class CompensationCalculator < BaseCalculator
    def expiry_date
      disclosure_check.compensation_payment_date
    end
  end
end
