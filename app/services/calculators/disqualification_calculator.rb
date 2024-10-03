module Calculators
  class DisqualificationCalculator < BaseCalculator
    #
    # If disqualification and no length is given: conviction start date is spent date
    #
    class StartPlusZeroMonths < AdditionCalculator
      def added_time
        { months: 0 }
      end

      def conviction_length
        { (disclosure_check.conviction_length_type || "no_length").to_sym => disclosure_check.conviction_length }
      end

      def expiry_date
        return ResultsVariant::INDEFINITE if indefinite_length?

        super
        conviction_end_date.advance(added_time)
      end
    end
  end
end
