class BaseCalculator
  class InvalidCalculation < RuntimeError; end

  attr_reader :disclosure_check

  def initialize(disclosure_check)
    @disclosure_check = disclosure_check
  end

  private

  def motoring_endorsement?
    GenericYesNo.new(disclosure_check.motoring_endorsement).yes?
  end

  def indefinite_length?
    ConvictionLengthType.new(disclosure_check.conviction_length_type.to_s).inquiry.indefinite?
  end

  def conviction_length
    { disclosure_check.conviction_length_type.to_sym => disclosure_check.conviction_length }
  end

  def conviction_length_in_months
    sentence_length_in_months(
      disclosure_check.conviction_length,
      disclosure_check.conviction_length_type
    )
  end

  def conviction_start_date
    @conviction_start_date ||= disclosure_check.known_date
  end

  def conviction_end_date
    @conviction_end_date ||= disclosure_check.known_date.advance(conviction_length)
  end

  def distance_in_months(start_date, end_date)
    ((end_date.year - start_date.year) * 12) + end_date.month - start_date.month - (end_date.day >= start_date.day ? 0 : 1)
  end

  def sentence_length_in_months(length, length_unit)
    case length_unit
    when 'days'
      length.days.in_months
    when 'weeks'
      length.weeks.in_months
    when 'years'
      length.years.in_months
    when 'months'
      length
    end
  end
end
