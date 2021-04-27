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
        scope: scope
      )
    end
  end

  def calculator
    @_calculator ||= Calculators::Multiples::MultipleOffensesCalculator.new(disclosure_report)
  end

  # :nocov:
  def scope
    raise NotImplementedError, 'implement in subclasses'
  end
  # :nocov:
end
