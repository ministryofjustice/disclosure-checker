class CautionResultPresenter < ResultsItemPresenter
  def to_partial_path
    'results/caution'
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
end
