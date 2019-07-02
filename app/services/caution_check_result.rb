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
    return disclosure_check.known_date unless disclosure_check.known_date.nil?

    I18n.t('caution_result')
  end

  def conditional_date
    Calculators::ConditionalCautionCalculator.new(disclosure_check).expiry_date
  end
end
