class CheckDecisionTree < BaseDecisionTree
  def destination
    return next_step if next_step

    case step_name
    when :kind
      edit(:under_age)
    when :under_age
      after_under_age
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end

  private

  def after_under_age
    case CheckKind.new(disclosure_check.kind)
    when CheckKind::CAUTION
      edit('/steps/caution/caution_type')
    when CheckKind::CONVICTION
      edit('/steps/conviction/conviction_type')
    end
  end
end
