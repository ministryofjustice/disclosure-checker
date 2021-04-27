class BasketPresenter
  attr_reader :disclosure_report

  def initialize(disclosure_report)
    @disclosure_report = disclosure_report
  end

  def summary
    calculator.proceedings.map do |proceeding|
      CheckGroupPresenter.new(
        index(proceeding),
        proceeding.check_group,
        spent_date: calculator.spent_date_for(proceeding),
        scope: scope
      )
    end
  end

  def calculator
    @_calculator ||= Calculators::Multiples::MultipleOffensesCalculator.new(disclosure_report)
  end

  private

  def index(proceeding)
    (@_proceeding_index ||= Hash.new(0))[proceeding.kind] += 1
  end

  # :nocov:
  def scope
    raise NotImplementedError, 'implement in subclasses'
  end
  # :nocov:
end
