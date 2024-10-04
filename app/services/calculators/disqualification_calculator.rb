module Calculators
  class DisqualificationCalculator < BaseCalculator
    class StartPlusZeroMonths < DisqualificationCalculator
      def added_time
        { months: 0 }
      end

      def expiry_date
        conviction_start_date.advance(added_time)
      end
    end

    def expiry_date
      conviction_start_date.advance(conviction_length)
    end
  end
end
