module Calculators
  class SentenceCalculator < BaseCalculator
    NEVER_SPENT_THRESHOLD = 48

    # If conviction length is 6 months or less: start date + length + 18 months
    # If conviction length is over 6 months and less than or equal to 30 months: start date + length + 2 years
    # If conviction length is over 30 months and less than or equal to 4 years: start date + length + 3.5 years
    # If conviction length is over 4 years: never spent
    #
    class Detention < SentenceCalculator
      UPPER_LIMIT = Float::INFINITY

      REHABILITATION_1 = { months: 18 }.freeze
      REHABILITATION_2 = { months: 24 }.freeze
      REHABILITATION_3 = { months: 42 }.freeze
    end

    # If conviction length is 6 months or less: start date + length + 18 months
    # If conviction length is over 6 months and less than or equal to 24 months: start date + length + 2 years
    # If conviction length is over 24 months, it is considered invalid
    #
    class DetentionTraining < SentenceCalculator
      UPPER_LIMIT = 24

      REHABILITATION_1 = { months: 18 }.freeze
      REHABILITATION_2 = { months: 24 }.freeze
    end

    # If conviction length is 6 months or less: start date + length + 2 years
    # If conviction length is over 6 months and less than or equal to 30 months: start date + length + 4 years
    # If conviction length is over 30 months and less than or equal to 4 years: start date + length + 7 years
    # If conviction length is over 4 years: never spent
    #
    class Prison < SentenceCalculator
      UPPER_LIMIT = Float::INFINITY

      REHABILITATION_1 = { months: 24 }.freeze
      REHABILITATION_2 = { months: 48 }.freeze
      REHABILITATION_3 = { months: 84 }.freeze
    end

    # If conviction length is 6 months or less: start date + length + 2 years
    # If conviction length is over 6 months and less than or equal to 24 months: start date + length + 4 years
    # If conviction length is over 24 months, it is considered invalid
    #
    class SuspendedPrison < SentenceCalculator
      UPPER_LIMIT = 24

      REHABILITATION_1 = { months: 24 }.freeze
      REHABILITATION_2 = { months: 48 }.freeze
    end

    def expiry_date
      raise InvalidCalculation unless valid?

      if conviction_length_in_months > NEVER_SPENT_THRESHOLD
        false
      else
        conviction_end_date.advance(spent_time)
      end
    end

    # Used to validate the upper limits, as some convictions can only be given
    # a maximum number of months in the sentence length.
    #
    def valid?
      conviction_length_in_months <= self.class::UPPER_LIMIT
    end

    private

    def spent_time
      case conviction_length_in_months
      when 0..6
        self.class::REHABILITATION_1
      when 7..30
        self.class::REHABILITATION_2
      else
        self.class::REHABILITATION_3
      end
    end

    def conviction_length_in_months
      @_conviction_length_in_months ||= sentence_length_in_months(disclosure_check.conviction_length, disclosure_check.conviction_length_type)
    end

    def conviction_end_date
      super.advance(days: -1)
    end
  end
end
