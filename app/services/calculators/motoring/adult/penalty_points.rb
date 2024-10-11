module Calculators
  module Motoring
    module Adult
      #
      # We always assume an endorsement was received
      # start_date + 3 years
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
