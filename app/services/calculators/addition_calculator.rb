module Calculators
  class AdditionCalculator < BaseCalculator
    ADDED_TIME_IF_NO_LENGTH = { months: 24 }.freeze
    #
    # If length is given: conviction end date
    #
    class PlusZeroMonths < AdditionCalculator
      def added_time
        {}
      end
    end

    # If length is given: conviction end date + 6 months
    # If no length is given: conviction start date + 24 months
    #
    class PlusSixMonths < AdditionCalculator
      def added_time
        { months: 6 }
      end
    end

    # If length is given: conviction end date + 12 months
    # If no length is given: conviction start date + 24 months
    #
    class PlusTwelveMonths < AdditionCalculator
      def added_time
        { months: 12 }
      end
    end

    # Only a possibility: start date + 6 months
    #
    class StartPlusSixMonths < AdditionCalculator
      def added_time
        { months: 6 }
      end

      def expiry_date
        conviction_start_date.advance(added_time)
      end
    end

    # Only a possibility: start date + 12 months
    #
    class StartPlusTwelveMonths < AdditionCalculator
      def added_time
        { months: 12 }
      end

      def expiry_date
        conviction_start_date.advance(added_time)
      end
    end

    def expiry_date
      return ResultsVariant::INDEFINITE if indefinite_length?

      if disclosure_check.conviction_length?
        conviction_end_date.advance(added_time)
      else
        conviction_start_date.advance(ADDED_TIME_IF_NO_LENGTH)
      end
    end
  end
end
