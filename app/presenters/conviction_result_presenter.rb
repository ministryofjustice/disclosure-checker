class ConvictionResultPresenter < ResultsPresenter
  def to_partial_path
    'results/conviction'
  end

  def question_attributes
    [
      :kind,
      :conviction_type,
      :conviction_subtype,
      :under_age,
      :known_date,
      :conviction_length,
      :conviction_length_type,
      :compensation_payment_date,
    ].freeze
  end

  private

  def result_class
    ConvictionCheckResult
  end
end
