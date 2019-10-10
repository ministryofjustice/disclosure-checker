class CheckDecisionTree < BaseDecisionTree
  def destination
    return next_step if next_step

    case step_name
    when :kind
      edit(:under_age)
    when :under_age, :bypass_under_age
      after_under_age
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end

  private

  def after_under_age
    return show(:exit_over18) unless under_age_or_bypass?

    case CheckKind.new(disclosure_check.kind)
    when CheckKind::CAUTION
      edit('/steps/caution/caution_type')
    when CheckKind::CONVICTION
      edit('/steps/conviction/conviction_type')
    end
  end

  # TODO: temporary feature-flag, to be removed when not needed
  def under_age_or_bypass?
    GenericYesNo.new(disclosure_check.under_age).yes? || step_name.eql?(:bypass_under_age)
  end
end
