class CheckAnswersPresenter
  attr_reader :disclosure_report

  def initialize(disclosure_report)
    @disclosure_report = disclosure_report
  end

  def summary
    completed_checks.map.with_index(1) do |check_group, i|
      CheckGroupPresenter.new(
        i,
        check_group,
        scope: to_partial_path
      )
    end
  end

  def to_partial_path
    'check_your_answers/check'
  end

  private

  def completed_checks
    disclosure_report.check_groups.with_completed_checks.group('check_groups.id')
  end
end
