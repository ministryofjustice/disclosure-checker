module Calculators
  module Motoring
    module Adult
      # If an endorsement was received
      # start_date + 5 years

      # If an endorsement was not received
      # Go to different result page: https://moj-disclosure-checker.herokuapp.com/motoring/v3/fpn-no-conviction
      class PenaltyNotice < BaseCalculator
        REHABILITATION_1 = { months: 60 }.freeze

        def expiry_date
          return conviction_start_date.advance(REHABILITATION_1) if motoring_endorsement?

          :no_record
        end
      end
    end
  end
end
