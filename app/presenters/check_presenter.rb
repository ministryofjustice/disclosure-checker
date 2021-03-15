class CheckPresenter
  attr_reader :disclosure_check

  def initialize(disclosure_check)
    @disclosure_check = disclosure_check
  end

  def summary
    CheckRow.new(
      ResultsPresenter.build(disclosure_check).summary,
      scope: to_partial_path
    )
  end

  def type
    CheckTypePresenter.new(disclosure_check).type
  end

  def to_partial_path
    'check_your_answers/shared/check_row'
  end
end
