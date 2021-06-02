module Calculators
  module Motoring
    module Adult
      #
      # We always assume an endorsement was received
      # start_date + 5 years
      #
      class PenaltyNotice < BaseCalculator
        REHABILITATION = { months: 60 }.freeze

        def expiry_date
          conviction_start_date.advance(REHABILITATION)
        end
      end
    end
  end
end
