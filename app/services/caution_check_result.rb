class CautionCheckResult
  attr_reader :disclosure_check

  def initialize(disclosure_check:)
    @disclosure_check = disclosure_check
  end

  def expiry_date
    return conditional_date if caution_type.conditional?

    caution_result
  end

  private

  def caution_type
    @_caution_type ||= CautionType.new(disclosure_check.caution_type)
  end

  def caution_result
    return false if disclosure_check.known_date.nil?

    disclosure_check.known_date
  end

  def conditional_date
    Calculators::ConditionalCautionCalculator.new(disclosure_check).expiry_date
  end
end
