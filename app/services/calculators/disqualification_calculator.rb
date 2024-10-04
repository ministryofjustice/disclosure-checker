module Calculators
  class DisqualificationCalculator < BaseCalculator
    ADDED_TIME = { months: 0 }.freeze

    def expiry_date
      return ResultsVariant::INDEFINITE if indefinite_length?

      if disclosure_check.conviction_length?
        conviction_end_date
      else
        conviction_start_date.advance(ADDED_TIME)
      end
    end
  end
end
