module Calculators
  class MotoringCalculator < BaseCalculator
    THREE_YEARS_ADDED_TIME = { months: 36 }.freeze
    FIVE_YEARS_ADDED_TIME  = { months: 60 }.freeze

    # start date + 36 months
    #
    class StartPlusThreeYears < MotoringCalculator
      def expiry_date
        conviction_start_date.advance(THREE_YEARS_ADDED_TIME)
      end
    end

    # start date + 60 months
    #
    class StartPlusFiveYears < MotoringCalculator
      def expiry_date
        conviction_start_date.advance(FIVE_YEARS_ADDED_TIME)
      end
    end

    def expiry_date
      raise NotImplementedError, 'implement in subclasses'
    end
  end
end
