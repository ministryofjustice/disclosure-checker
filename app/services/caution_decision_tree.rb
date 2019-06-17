class CautionDecisionTree < BaseDecisionTree
  # rubocop:disable Metrics/CyclomaticComplexity
  def destination
    return next_step if next_step

    case step_name
    when :under_age
      after_under_age
    when :caution_type
      after_caution_type
    when :known_date
      result
    when :conditional_end_date
      result
    when :condition_complied
      after_condition_complied
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def after_under_age
    return edit(:caution_type) if GenericYesNo.new(disclosure_check.under_age).yes?

    show('/steps/check/exit_over18')
  end

  def after_caution_type
    return edit(:condition_complied) if CautionType.new(disclosure_check.caution_type).conditional?

    edit(:known_date)
  end

  def after_condition_complied
    return edit(:conditional_end_date) if GenericYesNo.new(disclosure_check.condition_complied).yes?

    show(:condition_exit)
  end

  def result
    show('/steps/check/results')
  end
end
