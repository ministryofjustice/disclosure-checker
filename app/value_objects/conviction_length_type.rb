class ConvictionLengthType < ValueObject
  VALUES = [
    DAYS = new(:days),
    WEEKS = new(:weeks),
    MONTHS = new(:months),
    YEARS = new(:years),
    INDEFINITE = new(:indefinite),
    NO_LENGTH = new(:no_length),
  ].freeze

  def without_length?
    [NO_LENGTH, INDEFINITE].include?(self)
  end

  def self.values
    VALUES
  end
end
