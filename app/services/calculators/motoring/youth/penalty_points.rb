module Calculators
  module Motoring
    module Youth
      #
      # We always assume an endorsement was received
      # start_date + 3 years
      #
      # Because the Youth endorsement is 2.5 years and penalty points are 3 years,
      # the penalty points have a longer duration hence being 3 years always.
      #
      class PenaltyPoints < BaseCalculator
        REHABILITATION = { months: 36 }.freeze

        def expiry_date
          conviction_start_date.advance(REHABILITATION)
        end
      end
    end
  end
end
