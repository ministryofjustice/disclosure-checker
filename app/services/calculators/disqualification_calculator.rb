module Calculators
  #
  # If no disqualification end date is given
  # start_date + 2 years
  #
  class DisqualificationCalculator < BaseCalculator
    REHABILITATION = { years: 2 }.freeze

    def expiry_date
      return ResultsVariant::INDEFINITE if indefinite_length?

      if disclosure_check.conviction_length?
        conviction_end_date
      else
        conviction_start_date.advance(REHABILITATION)
      end
    end
  end
end
