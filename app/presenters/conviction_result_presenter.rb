class ConvictionResultPresenter < ResultsItemPresenter
  def to_partial_path
    'results/conviction'
  end

  private

  def question_attributes
    [
      :conviction_subtype,
      :under_age,
      :conviction_bail_days,
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
      scope: to_partial_path
    )
  end
end
