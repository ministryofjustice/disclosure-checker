class CheckRow < CheckAnswersPresenter
  attr_reader :number, :name, :question_answers, :scope

  def initialize(number, name, question_answers, scope:)
    @number = number
    @name = name
    @question_answers = question_answers
    @scope = scope
  end

  def to_partial_path
    'check_your_answers/shared/check'
  end
end
