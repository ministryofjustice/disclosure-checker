module ConvictionDecorator
  def compensation?
    [
      ConvictionType::COMPENSATION_TO_A_VICTIM,
      ConvictionType::ADULT_COMPENSATION_TO_A_VICTIM,
    ].include?(self)
  end

  def custodial_sentence?
    [
      ConvictionType::CUSTODIAL_SENTENCE,
      ConvictionType::ADULT_CUSTODIAL_SENTENCE,
    ].include?(self)
  end

  def motoring?
    ConvictionType::ADULT_MOTORING.eql?(self)
  end
end
