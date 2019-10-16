class SensibleDateValidator < ActiveModel::EachValidator
  DEFAULT_OPTIONS ||= {
    on_or_after_year: 1940,
    allow_future: false,
  }.freeze

  def initialize(options)
    super
    @_year = options[:on_or_after_year] || DEFAULT_OPTIONS[:on_or_after_year]
    @_allow_future = options[:allow_future] || DEFAULT_OPTIONS[:allow_future]
  end

  def validate_each(record, attribute, value)
    return unless value.is_a?(Date)
    return record.errors.add(attribute, :blank) unless positive_year?(value)

    record.errors.add(attribute, :invalid) unless valid_year?(value)
    record.errors.add(attribute, :future)  unless valid_future?(value)
  end

  private

  def positive_year?(date)
    date.year.to_i.positive?
  end

  def valid_year?(date)
    date.year.to_i >= @_year
  end

  def valid_future?(date)
    @_allow_future || Date.today >= date
  end
end
