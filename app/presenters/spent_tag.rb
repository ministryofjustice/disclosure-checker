class SpentTag
  GREEN = "green".freeze
  RED = "red".freeze

  attr_reader :variant

  def initialize(variant:)
    @variant = variant
  end

  def color
    return GREEN if variant.spent?

    RED
  end

  def scope
    "results/spent_tag"
  end
end
