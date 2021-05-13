class ResultsItemPresenter
  attr_reader :disclosure_check, :kind, :scope

  def self.build(disclosure_check, scope:)
    case CheckKind.new(disclosure_check.kind)
    when CheckKind::CAUTION
      CautionResultPresenter.new(disclosure_check, scope: scope)
    when CheckKind::CONVICTION
      ConvictionResultPresenter.new(disclosure_check, scope: scope)
    else
      raise TypeError, 'unknown check kind'
    end
  end

  def initialize(disclosure_check, scope:)
    @disclosure_check = disclosure_check
    @kind = disclosure_check.kind
    @scope = [scope, kind]
  end

  def order_type
    disclosure_check[type_attribute]
  end

  def summary
    question_attributes.map do |item, value|
      QuestionAnswerRow.new(
        item,
        value || format_value(item),
        scope: scope
      )
    end.select(&:show?)
  end

  def expiry_date
    result_service.expiry_date
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
  def type_attribute
    raise NotImplementedError, 'implement in subclasses'
  end

  def question_attributes
    raise NotImplementedError, 'implement in subclasses'
  end
  # :nocov:
end
