class ResultsPresenter < BasketPresenter
  APPROXIMATE_DATE_ATTRS = [
    :approximate_known_date,
    :approximate_conviction_date,
    :approximate_conditional_end_date,
    :approximate_compensation_payment_date,
  ].freeze

  def convictions?
    conviction_checks.any?
  end

  def approximate_dates?
    APPROXIMATE_DATE_ATTRS.any? do |attr|
      disclosure_report.disclosure_checks.any? do |disclosure_check|
        disclosure_check.try(attr)
      end
    end
  end

  def motoring?
    conviction_checks.map(&:conviction).compact.any?(&:motoring?)
  end

  def time_on_bail?
    conviction_checks.any? do |disclosure_check|
      disclosure_check.conviction_bail_days.to_i.positive?
    end
  end

  def scope
    :results
  end

  # This is how many cautions or convictions are in this report, meaning
  # 1 caution and 1 conviction with 3 sentences will return 2.
  def proceedings_size
    calculator.proceedings.size
  end

  # This is how many individual "checks" are in this report, meaning
  # 1 caution and 1 conviction with 3 sentences will return 4.
  def orders_size
    calculator.proceedings.sum(&:size)
  end

  private

  def conviction_checks
    @_conviction_checks ||= disclosure_report.conviction_checks
  end
end
