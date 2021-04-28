module Calculators
  module Motoring
    module Adult
      # If an endorsement was received
      # start_date + 5 years
      class PenaltyNotice < BaseCalculator
        REHABILITATION_1 = { months: 60 }.freeze

        def expiry_date
          conviction_start_date.advance(REHABILITATION_1)
        end
      end
    end
  end
end
