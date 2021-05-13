class CautionDecisionTree < BaseDecisionTree
  def destination
    return next_step if next_step

    case step_name
    when :caution_type
      edit(:known_date)
    when :known_date
      after_known_date
    when :conditional_end_date
      check_your_answers
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end

  private

  def after_known_date
    return edit(:conditional_end_date) if caution.conditional?

    check_your_answers
  end
end
