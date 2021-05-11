class ResultsVariant < ValueObject
  VALUES = [
    SPENT        = new(:spent),
    NOT_SPENT    = new(:not_spent),
    NEVER_SPENT  = new(:never_spent),
    SPENT_SIMPLE = new(:spent_simple),
    INDEFINITE   = new(:indefinite),
  ].freeze

  # Needed so we are able to do ranges and compare dates with special variants
  def to_date
    case self
    when NEVER_SPENT
      Date::Infinity.new
    when INDEFINITE
      # absurdly in the future, but sooner than "infinity"
      Date.new(2049, 1, 1)
    end
  end

  def spent?
    [
      ResultsVariant::SPENT,
      ResultsVariant::SPENT_SIMPLE,
    ].include?(self)
  end

  def self.values
    VALUES
  end
end
