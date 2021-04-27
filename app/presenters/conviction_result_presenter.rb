class ConvictionResultPresenter < ResultsItemPresenter
  private

  def type_attribute
    :conviction_subtype
  end

  def question_attributes
    [
      :under_age,
      :conviction_bail_days,
      :conviction_date,
      :known_date,
      [:conviction_length, i18n_conviction_length],
      :compensation_payment_date,
      :motoring_endorsement,
    ].freeze
  end

  def i18n_conviction_length
    type = disclosure_check.conviction_length_type
    return unless type

    I18n.translate!(
      "conviction_length.answers.#{type}",
      length: disclosure_check.conviction_length,
      scope: scope
    )
  end
end
