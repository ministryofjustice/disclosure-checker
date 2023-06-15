class SpentDatePanel
  attr_reader :kind, :variant, :spent_date

  def initialize(kind:, variant:, spent_date:)
    @kind = kind
    @variant = variant
    @spent_date = spent_date
  end

  def to_partial_path
    "results/shared/spent_date_panel"
  end

  def scope
    [to_partial_path, variant]
  end

  def date
    I18n.l(spent_date) if spent_date.instance_of?(Date)
  end
end
