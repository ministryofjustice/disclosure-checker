class CautionResultPresenter < ResultsItemPresenter
  private

  def type_attribute
    :caution_type
  end

  def question_attributes
    [
      :under_age,
      :known_date,
      :conditional_end_date,
    ].freeze
  end
end
