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
      ENDORSEMENT_THRESHOLD = 30

      REHABILITATION_WITH_ENDORSEMENT = { months: 30 }.freeze
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
      ENDORSEMENT_THRESHOLD = 60

      REHABILITATION_WITH_ENDORSEMENT = { months: 60 }.freeze
    end

    def expiry_date
      return ResultsVariant::INDEFINITE if indefinite_length?

      if disclosure_check.conviction_length?
        conviction_start_date.advance(rehabilitation_with_length)
      else
        conviction_start_date.advance(rehabilitation_without_length)
      end
    end

    private

    def rehabilitation_without_length
      self.class::REHABILITATION_WITH_ENDORSEMENT
    end

    def rehabilitation_with_length
      return self.class::REHABILITATION_WITH_ENDORSEMENT if within_endorsement_threshold?

      conviction_length
    end

    def within_endorsement_threshold?
      conviction_length_in_months <= self.class::ENDORSEMENT_THRESHOLD
    end
  end
end
