module Calculators
  class DetentionCalculator < BaseCalculator
    NEVER_SPENT_DURATION = 48
    SIX_MONTHS_LESS_SPENT_DURATION = { months: 18 }.freeze
    THIRTY_MONTHS_LESS_SPENT_DURATION = { months: 24 }.freeze
    FOUR_YEARS_LESS_SPENT_DURATION =  { months: 42 }.freeze

    def expiry_date
      return 'never spent' if conviction_length_in_months >= NEVER_SPENT_DURATION

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

    # TODO: this needs more testing as it's a bit of a work around.
    def conviction_length_in_months
      (conviction_start_date.beginning_of_month...conviction_end_date.beginning_of_month).select do |date|
        date.day == 1
      end.size
    end

    def conviction_start_date
      @conviction_start_date ||= disclosure_check.known_date
    end

    def conviction_end_date
      @conviction_end_date ||= disclosure_check.known_date.advance(conviction_length)
    end
  end
end
