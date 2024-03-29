class ConvictionResultPresenter < ResultsItemPresenter
private

  def type_attribute
    :conviction_subtype
  end

  def question_attributes
    [
      :under_age,
      :conviction_date,
      :known_date,
      [:conviction_length, i18n_conviction_length],
      :compensation_payment_date,
      :motoring_endorsement,
      :schedule18_over_4_years,
    ].freeze
  end

  def editable_attributes
    {
      known_date: ->(id) { edit_steps_conviction_known_date_path(check_id: id, next_step: :cya) },
      conviction_length: ->(id) { edit_steps_conviction_conviction_length_type_path(check_id: id) },
      compensation_payment_date: ->(id) { edit_steps_conviction_compensation_payment_date_path(check_id: id, next_step: :cya) },
      motoring_endorsement: ->(id) { edit_steps_conviction_motoring_endorsement_path(check_id: id, next_step: :cya) },
      schedule18_over_4_years: ->(id) { edit_steps_conviction_conviction_schedule18_path(check_id: id) },
    }
  end

  def i18n_conviction_length
    type = disclosure_check.conviction_length_type
    return unless type

    I18n.translate!(
      "conviction_length.answers.#{type}",
      length: disclosure_check.conviction_length,
      scope:,
    )
  end
end
