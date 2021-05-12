class DbsVisibility
  attr_reader :kind, :variant, :completed_checks

  delegate :spent?, to: :variant

  def initialize(kind:, variant:, completed_checks:)
    @kind = kind
    @variant = variant
    @completed_checks = completed_checks
  end

  # Basic check rules:
  #
  #   - If caution/conviction is spent: will not appear on a basic DBS check.
  #   - If caution/conviction is unspent: will appear on a basic DBS check.
  #
  def basic
    return :will_not if spent?

    :will
  end

  # Enhanced check rules:
  #
  #   - Youth cautions will not appear on enhanced checks regardless spent/unspent.
  #   - Unspent cautions/convictions: will appear on enhanced checks.
  #   - TODO: Spent cautions/convictions: TBD, for now we say 'may appear'.
  #
  def enhanced
    return :will_not if youth_caution?
    return :will unless spent?

    :maybe
  end

  def to_partial_path
    'results/shared/dbs_visibility'
  end

  private

  def youth_caution?
    return false unless CheckKind.new(kind).inquiry.caution?

    # `completed_checks` refers to this caution or conviction orders or sentences.
    # For cautions, we always have just one thing, so we pick the first one.
    caution = completed_checks.first

    CautionType.new(caution.caution_type).youth?
  end
end
