# Calculator rules:
# If conviction length is less than 6 months: start date + conviction length + 2 years
# If conviction length is greater than or equal to 6 months and less than 30 months: start date + conviction length + 4 years
# If conviction length is greater than or equal to 30 months and less than or equal to 4 years: start date + conviction length + 7 years
# If conviction length is over 4 years: never spent

# TODO: Confirm that `adult_suspended_prison_sentence` requires a new suspended calculator, this is being confirmed with the lawyers
module Calculators
  class PrisonSentenceCalculator < BaseCalculator
    NEVER_SPENT_DURATION = 48

    SIX_MONTHS_LESS_SPENT_DURATION = { months: 24 }.freeze
    THIRTY_MONTHS_LESS_SPENT_DURATION = { months: 48 }.freeze
    FOUR_YEARS_LESS_SPENT_DURATION =  { months: 84 }.freeze

    def expiry_date
      return false if conviction_length_in_months > NEVER_SPENT_DURATION

      conviction_end_date.advance(spent_time)
    end

    private

    def spent_time
      case conviction_length_in_months
      when 0..6
        SIX_MONTHS_LESS_SPENT_DURATION
      when 7..30
        THIRTY_MONTHS_LESS_SPENT_DURATION
      when 31..NEVER_SPENT_DURATION
        FOUR_YEARS_LESS_SPENT_DURATION
      end
    end

    def conviction_length_in_months
      @conviction_length_in_months ||= length_in_months(conviction_start_date, conviction_end_date)
    end
  end
end
