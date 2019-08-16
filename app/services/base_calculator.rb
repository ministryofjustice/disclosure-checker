class BaseCalculator
  class InvalidCalculation < RuntimeError; end

  WEEKS_IN_A_MONTH = 52 / 12.0
  MONTHS_IN_A_YEAR = 12

  attr_reader :disclosure_check

  def initialize(disclosure_check)
    @disclosure_check = disclosure_check
  end

  private

  def conviction_length
    { disclosure_check.conviction_length_type.to_sym => disclosure_check.conviction_length }
  end

  def conviction_start_date
    @conviction_start_date ||= disclosure_check.known_date
  end

  def conviction_end_date
    @conviction_end_date ||= disclosure_check.known_date.advance(conviction_length)
  end

  def distance_in_months(start_date, end_date)
    (end_date.year - start_date.year) * 12 + end_date.month - start_date.month - (end_date.day >= start_date.day ? 0 : 1)
  end

  def sentence_length_in_months(length, conviction_length_type)
    case conviction_length_type
    when 'weeks'
      length / WEEKS_IN_A_MONTH
    when 'years'
      length * MONTHS_IN_A_YEAR
    when 'months'
      length
    end
  end
end
