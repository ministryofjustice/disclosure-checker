class SpentTag
  GREEN = 'green'.freeze
  RED = 'red'.freeze

  COLORS = {
    ResultsVariant::SPENT => GREEN,
    ResultsVariant::NOT_SPENT => RED,
    ResultsVariant::NEVER_SPENT => RED,
    ResultsVariant::SPENT_SIMPLE => GREEN,
    ResultsVariant::INDEFINITE => RED,
  }.freeze

  attr_reader :spent_date

  def initialize(spent_date:)
    @spent_date = spent_date
  end

  def color
    COLORS[variant]
  end

  def variant
    if spent_date.instance_of?(Date)
      spent_date.past? ? ResultsVariant::SPENT : ResultsVariant::NOT_SPENT
    else
      spent_date
    end
  end

  def scope
    'results/spent_tag'
  end
end
