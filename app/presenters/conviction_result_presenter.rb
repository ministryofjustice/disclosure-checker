class ConvictionResultPresenter < ResultsPresenter
  def to_partial_path
    'results/conviction'
  end

  def motoring?
    disclosure_check.conviction_type.inquiry.adult_motoring?
  end

  private

  def question_attributes
    [
      :kind,
      :conviction_type,
      :conviction_subtype,
      :under_age,
      :known_date,
      [:conviction_length, i18n_conviction_length],
      :compensation_payment_date,
      :motoring_endorsement,
      :motoring_disqualification_end_date,
      :motoring_lifetime_ban,
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
