class CheckGroupPresenter
  attr_reader :number, :check_group, :scope

  def initialize(number, check_group, scope:)
    @number = number
    @check_group = check_group
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

  def add_another_sentence_button?
    first_check_kind.inquiry.conviction?
  end

  def check_group_name
    first_check_kind
  end

  private

  def first_check_kind
    completed_checks.first.kind
  end

  def completed_checks
    @_completed_checks ||= check_group.disclosure_checks.completed
  end
end
