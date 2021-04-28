module Calculators
  module Motoring
    module Youth
      # If an endorsement was received
      # start_date + 2.5 years
      class PenaltyNotice < BaseCalculator
        REHABILITATION_1 = { months: 30 }.freeze

        def expiry_date
          conviction_start_date.advance(REHABILITATION_1)
        end
      end
    end
  end
end
