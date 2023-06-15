class SentenceLengthValidator < ActiveModel::EachValidator
  DEFAULT_OPTIONS = {
    only: [
      ConvictionType::DETENTION_TRAINING_ORDER,
      ConvictionType::ADULT_SUSPENDED_PRISON_SENTENCE,
    ],
  }.freeze

  def initialize(options)
    super
    @_conviction_subtypes = options[:only] || DEFAULT_OPTIONS[:only]
  end

  def validate_each(record, attribute, value)
    return unless value.present? &&
      @_conviction_subtypes.include?(record.conviction_subtype)

    record.errors.add(attribute, :invalid_sentence) unless valid_calculation?(record, value)
  end

private

  def valid_calculation?(record, length)
    calculator = record.conviction_subtype.calculator_class
    disclosure_check = record.disclosure_check

    # We set the new length value, otherwise a stale, previous length prevail
    disclosure_check.conviction_length = length

    calculator.new(disclosure_check).valid?
  end
end
