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

  def editable_attributes
    {
      known_date: ->(id) { edit_steps_caution_known_date_path(check_id: id, next_step: :cya) },
      conditional_end_date: ->(id) { edit_steps_caution_conditional_end_date_path(check_id: id) },
    }
  end
end
