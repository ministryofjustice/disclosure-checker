class SpentDatePanel
  attr_reader :kind, :spent_date, :conviction_date

  def initialize(kind:, spent_date:, conviction_date:)
    @kind = kind
    @spent_date = spent_date
    @conviction_date = conviction_date
  end

  def to_partial_path
    'results/shared/spent_date_panel'
  end

  def scope
    [to_partial_path, tense]
  end

  def date
    I18n.l(spent_date) if spent_date.instance_of?(Date)
  end

  def given_date
    I18n.l(conviction_date) if conviction_date.instance_of?(Date)
  end

  private

  def tense
    if spent_date.instance_of?(Date)
      spent_date.past? ? ResultsVariant::SPENT : ResultsVariant::NOT_SPENT
    else
      spent_date
    end
  end
end
