class ConvictionDecisionTree < BaseDecisionTree
  def destination
    return next_step if next_step

    case step_name
    when :conviction_date
      edit(:conviction_type)
    when :conviction_type
      edit(:conviction_subtype)
    when :conviction_subtype
      after_conviction_subtype
    when :motoring_endorsement
      known_date_question
    when :known_date
      after_known_date
    when :conviction_length_type
      after_conviction_length_type
    when :compensation_paid
      after_compensation_paid
    when :conviction_length
      after_conviction_length
    when :conviction_schedule18
      after_conviction_schedule18
    when :conviction_multiple_sentences
      after_conviction_multiple_sentences
    when :single_sentence_over4
      check_your_answers
    when :compensation_payment_date
      check_your_answers
    else
      raise InvalidStep, "Invalid step '#{as || step_params}'"
    end
  end

private

  def after_conviction_multiple_sentences
    return edit(:single_sentence_over4) if step_value(:conviction_multiple_sentences).inquiry.yes?

    check_your_answers
  end

  def after_conviction_schedule18
    return edit(:conviction_multiple_sentences) if step_value(:conviction_schedule18).inquiry.yes?

    check_your_answers
  end

  def after_conviction_length
    conviction_length = disclosure_check.conviction_length_in_years(step_value(:conviction_length).to_i)
    schedule_18_applicable = ConvictionType.new(disclosure_check.conviction_subtype).schedule_18_applicable?

    return check_your_answers if conviction_length <= 4 || !schedule_18_applicable

    edit(:conviction_schedule18)
  end

  def after_conviction_subtype
    return edit(:compensation_paid)    if conviction.compensation?
    return edit(:motoring_endorsement) if conviction.motoring_fine?

    known_date_question
  end

  def after_known_date
    return check_your_answers if conviction.skip_length?

    edit(:conviction_length_type)
  end

  def after_conviction_length_type
    return check_your_answers if ConvictionLengthType.new(step_value(:conviction_length_type)).without_length?

    edit(:conviction_length)
  end

  def after_compensation_paid
    return edit(:compensation_payment_date) if GenericYesNo.new(disclosure_check.compensation_paid).yes?

    show(:compensation_not_paid)
  end

  def known_date_question
    edit(:known_date)
  end
end
