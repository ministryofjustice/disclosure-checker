class BaseCalculator
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

  # TODO: this needs more testing as it's a bit of a work around.
  def length_in_months(start_date, end_date)
    (start_date.beginning_of_month...end_date.beginning_of_month).select do |date|
      date.day == 1
    end.size
  end
end
