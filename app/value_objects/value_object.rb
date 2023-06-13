class ValueObject
  attr_reader :value

  def initialize(raw_value)
    raise ArgumentError, "Raw value must be symbol or implicitly convertible" unless raw_value.respond_to?(:to_sym)

    @value = raw_value.to_sym
    freeze
  end

  def ==(other)
    other.is_a?(self.class) && other.value == value
  end
  alias_method :===, :==
  alias_method :eql?, :==

  def self.find_constant(raw_value)
    const_get(raw_value.upcase)
  end

  def self.string_values
    values.map(&:to_s)
  end

  def hash
    [ValueObject, self.class, value].hash
  end

  delegate :inquiry, to: :to_s

  delegate :to_s, to: :value

  def to_sym
    value
  end
end
