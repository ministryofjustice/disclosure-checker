class ConvictionLengthType < ValueObject
  VALUES = [
    WEEKS = new(:weeks),
    MONTHS = new(:months),
    YEARS = new(:years),
  ].freeze

  def self.values
    VALUES
  end
end
