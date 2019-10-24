class CheckRow
  attr_reader :question_answers, :scope

  def initialize(question_answers, scope:)
    @question_answers = question_answers
    @scope = scope
  end

  def to_partial_path
    'check_your_answers/shared/check_row'
  end
end
