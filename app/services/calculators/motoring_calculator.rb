module Calculators
  class MotoringCalculator < BaseCalculator
    ENDORSEMENT_THRESHOLD = 60

    # If a lifetime ban was given:
    #  - never spent
    # If no end_date was given: Start date + 5 years
    #  - Start date + 5 years
    # If an endorsement was received
    #  - If (end_date - start_date) is less than or equal to 5 years: start_date + 5 years
    #  - If (end_date - start_date) is greater than 5 years: end_date

    # If an endorsement was not received
    # If no end_date was given:
    #  - Start date + 2 years
    # with an End date
    #  - End date
    class Disqualification < MotoringCalculator
      FIVE_YEARS_ADDED_TIME = { months: 60 }.freeze
      TWO_YEARS_ADDED_TIME  = { months: 24 }.freeze

      def expiry_date
        return false if GenericYesNo.new(disclosure_check.motoring_lifetime_ban).yes?
        return conviction_start_date.advance(missing_end_date_spent_time) if motoring_disqualification_end_date.nil?

        spent_time
      end

      private

      def spent_time
        return conviction_start_date.advance(FIVE_YEARS_ADDED_TIME) if motoring_endorsement? && distance_in_months(conviction_start_date, motoring_disqualification_end_date) <= ENDORSEMENT_THRESHOLD

        motoring_disqualification_end_date
      end

      def missing_end_date_spent_time
        return FIVE_YEARS_ADDED_TIME if motoring_endorsement?

        TWO_YEARS_ADDED_TIME
      end

      def motoring_disqualification_end_date
        @motoring_disqualification_end_date ||= disclosure_check.motoring_disqualification_end_date
      end
    end

    # If an endorsement was received
    # start_date + 5 years

    # If an endorsement was not received
    # Go to different result page: https://moj-disclosure-checker.herokuapp.com/motoring/v3/fpn-no-conviction
    class PenaltyNotice < MotoringCalculator
      REHABILITATION_1 = { months: 60 }.freeze

      def expiry_date
        return conviction_start_date.advance(REHABILITATION_1) if motoring_endorsement?

        true
      end
    end

    # If an endorsement was received
    # start_date + 5 years
    # If an endorsement was not received
    # start_date + 1 year
    class MotoringFine < MotoringCalculator
      REHABILITATION_1 = { months: 60 }.freeze
      REHABILITATION_2 = { months: 12 }.freeze
    end

    # If an endorsement was received:
    # start_date + 5 years
    # If an endorsement was not received:
    # start_date + 3 years
    class PenaltyPoints < MotoringCalculator
      REHABILITATION_1 = { months: 60 }.freeze
      REHABILITATION_2 = { months: 36 }.freeze
    end

    def expiry_date
      return conviction_start_date.advance(self.class::REHABILITATION_1) if motoring_endorsement?

      conviction_start_date.advance(self.class::REHABILITATION_2)
    end

    def motoring_endorsement?
      GenericYesNo.new(disclosure_check.motoring_endorsement).yes?
    end
  end
end
