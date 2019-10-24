class CheckGroupPresenter
  attr_reader :number, :name, :check_group, :scope, :add_another_sentence_button, :checks

  def initialize(number, check_group, scope:)
    @number = number
    @check_group = check_group
    @name = check_group_name
    @add_another_sentence_button = add_another_sentence_button?
    @scope = scope
  end

  def summary
    check_group.completed_disclosure_checks.map do |disclosure_check|
      CheckPresenter.new(disclosure_check)
    end
  end

  def to_partial_path
    'check_your_answers/shared/check'
  end

  private

  def check_group_name
    check_group.completed_disclosure_checks.first.kind
  end

  def add_another_sentence_button?
    return false unless check_group.completed_disclosure_checks.present?

    check_group.completed_disclosure_checks.first.kind == 'conviction'
  end
end
