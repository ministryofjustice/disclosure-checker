class CautionType < ValueObject
  VALUES = [
    YOUTH_TYPES = [
      YOUTH_SIMPLE_CAUTION = new(:youth_simple_caution),
      YOUTH_CONDITIONAL_CAUTION = new(:youth_conditional_caution),
    ].freeze,

    ADULT_TYPES = [
      ADULT_SIMPLE_CAUTION = new(:adult_simple_caution),
      ADULT_CONDITIONAL_CAUTION = new(:adult_conditional_caution),
    ].freeze
  ].flatten.freeze

  def conditional?
    [
      ADULT_CONDITIONAL_CAUTION,
      YOUTH_CONDITIONAL_CAUTION
    ].include?(self)
  end

  def youth?
    YOUTH_TYPES.include?(self)
  end

  def adult?
    ADULT_TYPES.include?(self)
  end

  def calculator_class
    Calculators::CautionCalculator
  end

  def self.values
    VALUES
  end
end
