module Calculators
  class DisqualificationCalculator < BaseCalculator
    def expiry_date
      return ResultsVariant::INDEFINITE if indefinite_length?

      if disclosure_check.conviction_length?
        conviction_end_date
      else
        conviction_start_date
      end
    end
  end
end
