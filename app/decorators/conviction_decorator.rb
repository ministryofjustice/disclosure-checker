module ConvictionDecorator
  #
  # Parent conviction types
  #
  def custodial_sentence?
    [
      ConvictionType::CUSTODIAL_SENTENCE,
      ConvictionType::ADULT_CUSTODIAL_SENTENCE,
    ].include?(parent)
  end

  def motoring?
    [
      ConvictionType::YOUTH_MOTORING,
      ConvictionType::ADULT_MOTORING,
    ].include?(parent)
  end

  #
  # Children conviction types
  #
  def compensation?
    [
      ConvictionType::COMPENSATION_TO_A_VICTIM,
      ConvictionType::ADULT_COMPENSATION_TO_A_VICTIM,
    ].include?(self)
  end

  def motoring_penalty_notice?
    ConvictionType::YOUTH_PENALTY_NOTICE.eql?(self) ||
      ConvictionType::ADULT_PENALTY_NOTICE.eql?(self)
  end

  def motoring_penalty_points?
    ConvictionType::YOUTH_PENALTY_POINTS.eql?(self) ||
      ConvictionType::ADULT_PENALTY_POINTS.eql?(self)
  end

  def bailable_offense?
    [
      ConvictionType::DETENTION,
      ConvictionType::DETENTION_TRAINING_ORDER,
      ConvictionType::ADULT_PRISON_SENTENCE,
      ConvictionType::ADULT_SUSPENDED_PRISON_SENTENCE,
    ].include?(self)
  end
end
