module Calculators
  module Motoring
    module Youth
      #
      # We always assume an endorsement was received
      # start_date + 2.5 years
      #
      class PenaltyNotice < BaseCalculator
        REHABILITATION = { months: 30 }.freeze

        def expiry_date
          conviction_start_date.advance(REHABILITATION)
        end
      end
    end
  end
end
