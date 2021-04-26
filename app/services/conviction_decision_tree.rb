class ConvictionDecisionTree < BaseDecisionTree
  include ValueObjectMethods

  # rubocop:disable Metrics/CyclomaticComplexity
  # rubocop:disable Metrics/MethodLength
  # rubocop:disable Metrics/AbcSize
  def destination
    return next_step if next_step

    case step_name
    when :conviction_date
      edit(:conviction_type)
    when :conviction_type
      edit(:conviction_subtype)
    when :conviction_subtype
      after_conviction_subtype
    when :conviction_bail_days
      known_date_question
    when :motoring_endorsement
      after_motoring_endorsement
    when :conviction_bail
      after_conviction_bail
    when :known_date
      after_known_date
    when :conviction_length_type
      after_conviction_length_type
    when :compensation_paid
      after_compensation_paid
    when :compensation_payment_over_100
      edit(:compensation_payment_date)
    when :compensation_payment_date
      after_compensation_payment_date
    when :compensation_receipt_sent
      after_compensation_receipt_sent
    when :conviction_length
      check_your_answers
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end
  # rubocop:enable Metrics/AbcSize
  # rubocop:enable Metrics/MethodLength
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def after_conviction_subtype
    return edit(:conviction_bail)    if conviction_subtype.bailable_offense?
    return edit(:compensation_paid)  if conviction_subtype.compensation?
    return after_motoring_conviction if conviction_type.motoring?

    known_date_question
  end

  def after_motoring_conviction
    if conviction_subtype.motoring_penalty_points? || conviction_subtype.motoring_penalty_notice?
      known_date_question
    else
      edit(:motoring_endorsement)
    end
  end

  def after_known_date
    return check_your_answers if conviction_subtype.skip_length?

    edit(:conviction_length_type)
  end

  def after_conviction_length_type
    return check_your_answers if ConvictionLengthType.new(step_value(:conviction_length_type)).without_length?

    edit(:conviction_length)
  end

  def after_compensation_paid
    return edit(:compensation_paid_amount) if GenericYesNo.new(disclosure_check.compensation_paid).yes?

    show(:compensation_not_paid)
  end

  def after_compensation_payment_date
    return edit(:compensation_payment_receipt) if GenericYesNo.new(disclosure_check.compensation_payment_over_100).yes?

    check_your_answers
  end

  def after_compensation_receipt_sent
    return show(:compensation_unable_to_tell) if GenericYesNo.new(disclosure_check.compensation_receipt_sent).no?

    check_your_answers
  end

  def after_motoring_endorsement
    return check_your_answers if penalty_notice_without_endorsement?

    known_date_question
  end

  def after_conviction_bail
    return edit(:conviction_bail_days) if step_value(:conviction_bail).inquiry.yes?

    known_date_question
  end

  def penalty_notice_without_endorsement?
    conviction_subtype.motoring_penalty_notice? && GenericYesNo.new(disclosure_check.motoring_endorsement).no?
  end

  def known_date_question
    edit(:known_date)
  end
end
