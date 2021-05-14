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
  #   - Unspent cautions/convictions: will appear on enhanced checks.
  #   - Spent custodial convictions: will appear on enhanced checks.
  #   - Spent youth cautions: will not appear on enhanced checks.
  #   - TODO: other spent convictions: TBD, for now we say 'may appear'.
  #
  def enhanced
    return :will unless spent?
    return :will if custodial_conviction?

    return :will_not if youth_caution?

    :maybe
  end

  def to_partial_path
    'results/shared/dbs_visibility'
  end

  private

  def youth_caution?
    completed_checks.filter_map(&:caution).any?(&:youth?)
  end

  def custodial_conviction?
    completed_checks.filter_map(&:conviction).any?(&:custodial_sentence?)
  end
end
