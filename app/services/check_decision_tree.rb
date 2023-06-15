class CheckDecisionTree < BaseDecisionTree
  def destination
    return next_step if next_step

    case step_name
    when :kind
      edit(:under_age)
    when :under_age
      after_under_age
    when :remove_check
      after_remove_check
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end

private

  def after_under_age
    case CheckKind.new(disclosure_check.kind)
    when CheckKind::CAUTION
      edit("/steps/caution/caution_type")
    when CheckKind::CONVICTION
      edit("/steps/conviction/conviction_date")
    end
  end

  def after_remove_check
    return check_your_answers if GenericYesNo.new(step_params[:remove_check]).no?
    return check_your_answers if disclosure_check.disclosure_report.disclosure_checks.completed.any?

    # restart fresh
    edit("/steps/check/kind", { new: "y" })
  end
end
