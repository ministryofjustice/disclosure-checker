class ResultsPresenter < BasketPresenter
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
end
