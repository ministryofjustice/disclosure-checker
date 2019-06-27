class ConvictionExpiryCalculator
  include ValueObjectMethods
  attr_reader :disclosure_check

  def initialize(disclosure_check:)
    @disclosure_check = disclosure_check
  end

  def expiry_date
    calculator.expiry_date
  end

  def calculator
    conviction_subtype.calculator_class.new(disclosure_check)
  end
end
