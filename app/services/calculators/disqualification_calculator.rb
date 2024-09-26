module Calculators
  class DisqualificationCalculator < BaseCalculator

    class Youths < DisqualificationCalculator
      #
      # We always assume an endorsement was received:
      #
      #   - If length is less than or equal to 2.5 years (30 months): start date + 30 months
      #   - If length is greater than 2.5 years (30 months): start date + length
      #   - If no length was given: start date + 30 months
      #   - If an indefinite ban was given: until further order
      #
    end

    class Adults < DisqualificationCalculator
      #
      # We always assume an endorsement was received:
      #
      #   - If length is less than or equal to 5 years (60 months): start date + 60 months
      #   - If length is greater than 5 years (60 months): start date + length
      #   - If no length was given: start date + 60 months
      #   - If an indefinite ban was given: until further order
      #
    end

    def expiry_date
      return ResultsVariant::INDEFINITE if indefinite_length?
      conviction_start_date.advance(conviction_length)
    end
  end
end
