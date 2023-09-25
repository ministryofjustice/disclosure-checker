module Calculators
  class SentenceCalculator < BaseCalculator
    UPPER_LIMIT_MONTHS = Float::INFINITY
    BAIL_OFFSET = -1.0

    class Detention < SentenceCalculator
      def rehabilitation_period
        case conviction_length_in_months
        when 0..12
          { months: 6 }
        when 12..48
          { months: 24 }
        else
          { months: 42 }
        end
      end
    end

    class DetentionTraining < Detention
      UPPER_LIMIT_MONTHS = 24
    end

    class Prison < SentenceCalculator
      def rehabilitation_period
        case conviction_length_in_months
        when 0..12
          { years: 1 }
        when 12..48
          { years: 4 }
        else
          { years: 7 }
        end
      end
    end

    class SuspendedPrison < Prison
      UPPER_LIMIT_MONTHS = 24
    end

    def expiry_date
      raise InvalidCalculation unless valid?

      if disclosure_check.never_spent_schedule18
        ResultsVariant::NEVER_SPENT
      else
        conviction_end_date.advance(rehabilitation_period).advance(bail_offset)
      end
    end

    # Used to validate the upper limits, as some convictions can only be given
    # a maximum number of months in the sentence length.
    #
    def valid?
      conviction_length_in_months <= self.class::UPPER_LIMIT_MONTHS
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
