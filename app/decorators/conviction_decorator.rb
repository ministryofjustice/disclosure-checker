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

  def youth?
    ConvictionType::YOUTH_PARENT_TYPES.include?(parent)
  end

  def adult?
    ConvictionType::ADULT_PARENT_TYPES.include?(parent)
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

  def motoring_fine?
    [
      ConvictionType::YOUTH_MOTORING_FINE,
      ConvictionType::ADULT_MOTORING_FINE,
    ].include?(self)
  end
end
