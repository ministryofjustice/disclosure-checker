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
end
