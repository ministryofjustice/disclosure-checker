class ConvictionDecisionTree < BaseDecisionTree
  # rubocop:disable Metrics/CyclomaticComplexity
  def destination
    return next_step if next_step

    case step_name
    when :under_age
      after_under_age
    when :conviction_type
      after_conviction_type
    when :conviction_subtype
      edit(:known_date)
    when :known_date
      edit(:conviction_length_type)
    when :conviction_length_type
      edit(:conviction_length)
    when :conviction_length
      show('/steps/check/results')
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def after_under_age
    return edit(:conviction_type) if GenericYesNo.new(disclosure_check.under_age).yes?

    show(:exit_over18)
  end

  def after_conviction_type
    return edit(:conviction_subtype) if conviction.children.any?

    edit(:known_date)
  end

  def conviction
    ConvictionType.new(step_value(:conviction_type))
  end
end
