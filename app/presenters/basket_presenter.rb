class BasketPresenter
  attr_reader :disclosure_report

  def initialize(disclosure_report)
    @disclosure_report = disclosure_report
  end

  def summary
    calculator.proceedings.map.with_index(1) do |proceeding, i|
      CheckGroupPresenter.new(
        i,
        proceeding.check_group,
        spent_date: calculator.spent_date_for(proceeding),
        scope: to_partial_path
      )
    end
  end

  def calculator
    @_calculator ||= Calculators::Multiples::MultipleOffensesCalculator.new(disclosure_report)
  end

  # TODO: this potentially will be different for CYA and for results page
  def to_partial_path
    'check_your_answers/check'
  end
end
