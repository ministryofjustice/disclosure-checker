module Calculators
  class SentenceCalculator < BaseCalculator
    NEVER_SPENT_THRESHOLD = 48
    BAIL_OFFSET = -1.0

    class Detention < SentenceCalculator
      UPPER_LIMIT = Float::INFINITY

      def rehabilitation_period
        case conviction_length_in_months
        when 0..12
          { months: 6 }
        when 13..48
          { months: 24 }
        else
          { months: 42 }
        end
      end
    end

    class DetentionTraining < SentenceCalculator
      UPPER_LIMIT = 24

      def rehabilitation_period
        case conviction_length_in_months
        when 0..12
          { months: 6 }
        else
          { months: 24 }
        end
      end
    end

    class Prison < SentenceCalculator
      UPPER_LIMIT = Float::INFINITY

      def rehabilitation_period
        case conviction_length_in_months
        when 0..12
          { months: 12 }
        when 13..48
          { months: 48 }
        else
          { months: 84 }
        end
      end
    end

    class SuspendedPrison < SentenceCalculator
      UPPER_LIMIT = 24

      def rehabilitation_period
        case conviction_length_in_months
        when 0..12
          { months: 12 }
        else
          { months: 48 }
        end
      end
    end

    def expiry_date
      raise InvalidCalculation unless valid?

      conviction_end_date.advance(rehabilitation_period).advance(bail_offset)
    end

    # Used to validate the upper limits, as some convictions can only be given
    # a maximum number of months in the sentence length.
    #
    def valid?
      conviction_length_in_months <= self.class::UPPER_LIMIT
    end

  private

    # The day before the end date, thus we subtract 1 day.
    def conviction_end_date
      super.advance(days: -1)
    end

    # Each full day spent on bail with a tag offsets the value of `BAIL_OFFSET`
    # from the sentence length (after the rehabilitation period has been applied).
    # Attribute can be blank or nil, but `#to_i` makes it safe.
    #
    def bail_offset
      { days: disclosure_check.conviction_bail_days.to_i * BAIL_OFFSET }
    end
  end
end
