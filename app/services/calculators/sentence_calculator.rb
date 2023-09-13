module Calculators
  class SentenceCalculator < BaseCalculator
    NEVER_SPENT_THRESHOLD = 48
    BAIL_OFFSET = -1.0

    # If conviction length is 12 months or less: start date + length + 6 months
    # If conviction length is over 12 months and less than or equal to 4 years: start date + length + 2 years
    # If conviction length is over 4 years: start date + length + 3.5 years
    #
    class Detention < SentenceCalculator
      UPPER_LIMIT = Float::INFINITY

      REHABILITATION_1 = { months: 6 }.freeze
      REHABILITATION_2 = { months: 24 }.freeze
      REHABILITATION_3 = { months: 42 }.freeze
    end

    # If conviction length is 12 months or less: start date + length + 6 months
    # If conviction length is over 12 months and less than or equal to 2 years: start date + length + 2 years
    # If conviction length is over 2 years, it is considered invalid
    #
    class DetentionTraining < SentenceCalculator
      UPPER_LIMIT = 24

      REHABILITATION_1 = { months: 6 }.freeze
      REHABILITATION_2 = { months: 24 }.freeze
    end

    # If conviction length is 12 months or less: start date + length + 1 year
    # If conviction length is over 12 months and less than or equal to 4 years: start date + length + 4 years
    # If conviction length is over 4 years: start date + length + 7 years
    #
    class Prison < SentenceCalculator
      UPPER_LIMIT = Float::INFINITY

      REHABILITATION_1 = { months: 12 }.freeze
      REHABILITATION_2 = { months: 48 }.freeze
      REHABILITATION_3 = { months: 84 }.freeze
    end

    # If conviction length is 12 months or less: start date + length + 1 year
    # If conviction length is over 12 months and less than or equal to 2 years: start date + length + 4 years
    # If conviction length is over 2 years, it is considered invalid
    #
    class SuspendedPrison < SentenceCalculator
      UPPER_LIMIT = 24

      REHABILITATION_1 = { months: 12 }.freeze
      REHABILITATION_2 = { months: 48 }.freeze
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

    def rehabilitation_period
      case conviction_length_in_months
      when 0..12
        self.class::REHABILITATION_1
      when 12..48
        self.class::REHABILITATION_2
      else
        self.class::REHABILITATION_3
      end
    end

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
