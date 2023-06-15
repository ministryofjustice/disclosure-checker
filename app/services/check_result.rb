class CheckResult
  attr_reader :disclosure_check

  delegate :caution, :conviction, :kind, to: :disclosure_check

  def initialize(disclosure_check:)
    @disclosure_check = disclosure_check
  end

  def expiry_date
    calculator&.expiry_date
  end

  def calculator
    offence_type.calculator_class.new(disclosure_check)
  end

private

  def offence_type
    return caution if kind.inquiry.caution?
    return conviction if kind.inquiry.conviction?

    raise "Unknown or nil check kind"
  end
end
