class CheckTypePresenter
  attr_reader :disclosure_check

  def initialize(disclosure_check)
    @disclosure_check = disclosure_check
  end

  def type
    kind.humanize
  end

  private

  def kind
    case CheckKind.new(disclosure_check.kind)
    when CheckKind::CAUTION
      disclosure_check.caution_type
    when CheckKind::CONVICTION
      disclosure_check.conviction_subtype
    end
  end
end
