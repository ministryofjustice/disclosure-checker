class CautionResultPresenter < ResultsPresenter
  def to_partial_path
    'results/caution'
  end

  def variant
    return 'caution_simple' if caution_type.simple?

    tense = if expiry_date.instance_of?(Date)
              expiry_date.past? ? :spent : :not_spent
            else
              expiry_date
            end

    # The tense can be one of these values: spent, not_spent, never_spent or no_record
    [disclosure_check.kind, tense].join('_')
  end

  private

  def question_attributes
    [
      :caution_type,
      :under_age,
      :known_date,
      :conditional_end_date,
    ].freeze
  end

  def caution_type
    @caution_type ||= CautionType.find_constant(disclosure_check.caution_type)
  end
end
