class CheckPresenter
  attr_reader :disclosure_check, :scope

  delegate :kind, :order_type, :summary, to: :results_item

  def initialize(disclosure_check, scope:)
    @disclosure_check = disclosure_check
    @scope = scope
  end

  def to_partial_path
    [scope, 'shared', 'check_row'].join('/')
  end

  private

  def results_item
    @_results_item ||= ResultsItemPresenter.build(disclosure_check, scope: scope)
  end
end
