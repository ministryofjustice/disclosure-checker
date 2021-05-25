class QuestionAnswerRow
  attr_reader :question, :answer, :scope, :change_path

  def initialize(question, answer, scope:, change_path:)
    @question = question
    @answer = answer
    @scope = scope
    @change_path = change_path
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
