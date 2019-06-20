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
      after_conviction_subtype
    when :known_date
      after_known_date
    when :conviction_length_type
      edit(:conviction_length)
    when :compensation_paid
      after_compensation_paid
    when :conviction_length, :compensation_payment_date
      results
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def after_under_age
    return edit(:conviction_type) if GenericYesNo.new(disclosure_check.under_age).yes?

    show('/steps/check/exit_over18')
  end

  def after_conviction_type
    return edit(:conviction_subtype) if conviction.children.any?

    edit(:known_date)
  end

  def after_conviction_subtype
    return edit(:compensation_paid) if conviction_subtype.compensation?

    edit(:known_date)
  end

  def after_known_date
    return results if conviction_subtype.skip_length?

    edit(:conviction_length_type)
  end

  def after_compensation_paid
    return edit(:compensation_payment_date) if GenericYesNo.new(disclosure_check.compensation_paid).yes?

    # TODO: waiting on new exit page
    show('/steps/check/exit_over18')
  end

  def results
    show('/steps/check/results')
  end

  def conviction
    ConvictionType.find_constant(step_value(:conviction_type))
  end

  def conviction_subtype
    ConvictionType.find_constant(disclosure_check.conviction_subtype)
  end
end
