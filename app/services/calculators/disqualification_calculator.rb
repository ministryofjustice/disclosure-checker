module Calculators
  class DisqualificationCalculator < BaseCalculator
    class Youths < DisqualificationCalculator
      #
      #   - If no length was given: start date is spent date
      #   - If an indefinite ban was given: until further order
      #
    end

    class Adults < DisqualificationCalculator
      #
      #   - If no length was given: start date is spent date
      #   - If an indefinite ban was given: until further order
      #
    end

    def expiry_date
      return ResultsVariant::INDEFINITE if indefinite_length?
      return ResultsVariant::NO_LENGTH if no_length?
      conviction_start_date.advance(conviction_length)
    end
  end
end
      #
