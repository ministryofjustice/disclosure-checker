# Calculator rules:
# If conviction length is 6 months or less: conviction start date + conviction length + 18 months
# If conviction length is over 6 months and less than or equal to 30 months: conviction start date + conviction length + 2 years
# If conviction length is over 30 months and less than 4 years: conviction start date + conviction length + 3.5 years
# If conviction length is 4 years or over: never spent
module Calculators
  class DetentionCalculator < BaseCalculator
    NEVER_SPENT_DURATION = 48
    SIX_MONTHS_LESS_SPENT_DURATION = { months: 18 }.freeze
    THIRTY_MONTHS_LESS_SPENT_DURATION = { months: 24 }.freeze
    FOUR_YEARS_LESS_SPENT_DURATION =  { months: 42 }.freeze

    def expiry_date
      return false if conviction_length_in_months >= NEVER_SPENT_DURATION

      conviction_end_date.advance(spent_time)
    end

    private

    def spent_time
      case conviction_length_in_months
      when 0..6
        SIX_MONTHS_LESS_SPENT_DURATION
      when 7..30
        THIRTY_MONTHS_LESS_SPENT_DURATION
      when 31..47
        FOUR_YEARS_LESS_SPENT_DURATION
      end
    end

    def conviction_length_in_months
      @conviction_length_in_months ||= length_in_months(conviction_start_date, conviction_end_date)
    end
  end
end
