class ConvictionDecisionTree < BaseDecisionTree
  include ValueObjectMethods

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  def destination
    return next_step if next_step

    case step_name
    when :conviction_type
      edit(:conviction_subtype)
    when :conviction_subtype
      after_conviction_subtype
    when :motoring_endorsement
      edit(:known_date)
    when :known_date
      after_known_date
    when :conviction_length_type
      after_conviction_length_type
    when :compensation_paid
      after_compensation_paid
    when :motoring_lifetime_ban
      after_motoring_lifetime_ban
    when :conviction_length, :compensation_payment_date, :motoring_disqualification_end_date
      results
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def after_conviction_subtype
    return edit(:compensation_paid) if conviction_subtype.compensation?
    return after_adult_motoring if conviction_subtype.parent.inquiry.adult_motoring?

    edit(:known_date)
  end

  def after_adult_motoring
    return edit(:motoring_lifetime_ban) if conviction_subtype.inquiry.adult_disqualification?

    edit(:motoring_endorsement)
  end

  def after_motoring_lifetime_ban
    return results if GenericYesNo.new(disclosure_check.motoring_lifetime_ban).yes?

    edit(:motoring_endorsement)
  end

  def after_known_date
    return results if conviction_subtype.skip_length?
    return edit(:motoring_disqualification_end_date) if conviction_subtype.inquiry.adult_disqualification?

    edit(:conviction_length_type)
  end

  def after_conviction_length_type
    return results if step_value(:conviction_length_type).inquiry.no_length?

    edit(:conviction_length)
  end

  def after_compensation_paid
    return edit(:compensation_payment_date) if GenericYesNo.new(disclosure_check.compensation_paid).yes?

    show(:compensation_not_paid)
  end
end
