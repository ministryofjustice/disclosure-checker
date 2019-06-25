class ConvictionExpiryCalculator
  attr_reader :disclosure_check

  def initialize(disclosure_check:)
    @disclosure_check = disclosure_check
  end

  def expiry_date
    return 'TBD' unless conviction_subtype.calculator_class?

    conviction_subtype.calculator_class.new(disclosure_check).expiry_date
  end

  private

  def conviction_subtype
    ConvictionType.find_constant(disclosure_check.conviction_subtype)
  end
end
