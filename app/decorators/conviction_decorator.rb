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
    [
      ConvictionType::ADULT_DISQUALIFICATION,
      ConvictionType::ADULT_MOTORING_FINE,
      ConvictionType::ADULT_PENALTY_NOTICE,
      ConvictionType::ADULT_PENALTY_POINTS
    ].include?(self)
  end
end
