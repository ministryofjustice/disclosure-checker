class CheckGroupPresenter
  attr_reader :number, :check_group, :spent_date, :scope

  def initialize(number, check_group, spent_date:, scope:)
    @number = number
    @check_group = check_group
    @spent_date = spent_date
    @scope = scope
  end

  def summary
    completed_checks.map do |disclosure_check|
      CheckPresenter.new(disclosure_check, scope: scope)
    end
  end

  def spent_tag
    SpentTag.new(
      spent_date: spent_date
    )
  end

  def spent_date_panel
    SpentDatePanel.new(
      kind: first_check_kind,
      spent_date: spent_date
    )
  end

  def to_partial_path
    [scope, 'shared', 'check'].join('/')
  end

  def add_another_sentence_button?
    check_group.disclosure_report.in_progress? &&
      first_check_kind.inquiry.conviction?
  end

  def check_group_kind
    first_check_kind
  end

  private

  def first_check_kind
    @_first_check_kind ||= completed_checks.first.kind
  end

  def completed_checks
    @_completed_checks ||= check_group.disclosure_checks.completed
  end
end
