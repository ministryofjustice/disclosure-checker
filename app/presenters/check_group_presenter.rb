class CheckGroupPresenter
  attr_reader :number, :name, :check_group, :scope, :add_another_sentence_button, :checks

  def initialize(number, check_group, scope:)
    @number = number
    @check_group = check_group
    @name = first_check_kind
    @add_another_sentence_button = add_another_sentence_button?
    @scope = scope
  end

  def summary
    completed_checks.map do |disclosure_check|
      CheckPresenter.new(disclosure_check)
    end
  end

  def to_partial_path
    'check_your_answers/shared/check'
  end

  private

  def add_another_sentence_button?
    first_check_kind.inquiry.conviction?
  end

  def first_check_kind
    completed_checks.first.kind
  end

  def completed_checks
    @_completed_checks ||= check_group.disclosure_checks.completed
  end
end
