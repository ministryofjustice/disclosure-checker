class ResultsItemPresenter
  include ValueObjectMethods
  attr_reader :disclosure_check

  def self.build(disclosure_check)
    case CheckKind.new(disclosure_check.kind)
    when CheckKind::CAUTION
      CautionResultPresenter.new(disclosure_check)
    when CheckKind::CONVICTION
      ConvictionResultPresenter.new(disclosure_check)
    else
      raise TypeError, 'unknown check kind'
    end
  end

  def initialize(disclosure_check)
    @disclosure_check = disclosure_check
  end

  def summary
    question_attributes.map do |item, value|
      QuestionAnswerRow.new(
        item,
        value || format_value(item),
        scope: to_partial_path
      )
    end.select(&:show?)
  end

  def expiry_date
    result_service.expiry_date
  end

  def time_on_bail?
    disclosure_check.conviction_bail_days.to_i.positive?
  end

  def variant
    tense = if expiry_date.instance_of?(Date)
              expiry_date.past? ? ResultsVariant::SPENT : ResultsVariant::NOT_SPENT
            else
              expiry_date
            end

    # The tense can be any of the values defined in `ResultsVariant`
    [disclosure_check.kind, tense].join('_')
  end

  private

  def result_service
    @_result_service ||= CheckResult.new(
      disclosure_check: disclosure_check
    )
  end

  def format_value(attr)
    value = disclosure_check[attr]
    return value unless value.is_a?(Date)

    approx_attr = ['approximate', attr].join('_').to_sym
    format_type = disclosure_check[approx_attr].present? ? 'approximate' : 'exact'

    I18n.translate!(
      format_type, date: I18n.l(value),
      scope: 'results/shared/date_format'
    )
  end

  # :nocov:
  def to_partial_path
    raise NotImplementedError, 'implement in subclasses'
  end

  def question_attributes
    raise NotImplementedError, 'implement in subclasses'
  end
  # :nocov:
end
