class QuestionAnswerRow
  attr_reader :question, :answer, :scope

  def initialize(question, answer, scope:)
    @question = question
    @answer = answer
    @scope = scope
  end

  def show?
    answer.present?
  end

  # For example for a scope of: ['check_your_answers', 'caution']
  # we only need the partial path as: 'check_your_answers/shared/row'
  def to_partial_path
    [scope[0], 'shared', 'row'].join('/')
  end
end
