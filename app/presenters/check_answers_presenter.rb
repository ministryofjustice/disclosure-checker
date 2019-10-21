class CheckAnswersPresenter
  attr_reader :disclosure_report

  def initialize(disclosure_report)
    @disclosure_report = disclosure_report
  end

  def summary
    disclosure_report.check_groups.map.with_index(1) do |check_group, i|
      CheckRow.new(
        i,
        check_group_name(check_group),
        display_checks(check_group),
        scope: to_partial_path
      )
    end
  end

  def to_partial_path
    'check_your_answers/check'
  end

  private

  def display_checks(check_group)
    check_group.disclosure_checks.map do |disclosure_check|
      ResultsPresenter.build(disclosure_check).summary
    end.flatten
  end

  def check_group_name(check_group)
    check_group.disclosure_checks.first.kind
  end
end
