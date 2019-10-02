class ResultsPresenter
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
        value || disclosure_check[item],
        scope: to_partial_path
      )
    end.select(&:show?)
  end

  def expiry_date
    result_service.expiry_date
  end

  def variant
    tense = if expiry_date.instance_of?(Date)
              expiry_date.past? ? :spent : :not_spent
            else
              expiry_date ? :no_record : :never_spent
            end

    [disclosure_check.kind, tense].join('_')
  end

  private

  def result_service
    @_result_service ||= result_class.new(
      disclosure_check: disclosure_check
    )
  end

  # :nocov:
  def result_class
    raise NotImplementedError, 'implement in subclasses'
  end

  def to_partial_path
    raise NotImplementedError, 'implement in subclasses'
  end

  def question_attributes
    raise NotImplementedError, 'implement in subclasses'
  end
  # :nocov:
end
