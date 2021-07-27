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
  #   - Spent youth cautions: will not appear on enhanced checks.
  #   - Spent custodial convictions: will appear on enhanced checks.
  #   - Recency rules, refer to `#recent_caution_or_conviction?` method.
  #   - Any other combination: may appear on enhanced checks.
  #
  def enhanced
    return :will unless spent?

    return :will_not if youth_caution?

    return :will if custodial_conviction?
    return :will if recent_caution_or_conviction?

    :maybe
  end

  def to_partial_path
    'results/shared/dbs_visibility'
  end

  private

  def cautions
    @_cautions ||= completed_checks.filter_map(&:caution)
  end

  def convictions
    @_convictions ||= completed_checks.filter_map(&:conviction)
  end

  def youth_caution?
    cautions.any?(&:youth?)
  end

  def adult_caution?
    cautions.any?(&:adult?)
  end

  def youth_conviction?
    convictions.any?(&:youth?)
  end

  def adult_conviction?
    convictions.any?(&:adult?)
  end

  def custodial_conviction?
    convictions.any?(&:custodial_sentence?)
  end

  # Recency rules for spent cautions and convictions:
  #
  #   - Adult cautions given within 6 years of the check: will appear.
  #   - Youth convictions imposed within 5.5 years of the check: will appear.
  #   - Adult convictions imposed within 11 years of the check: will appear.
  #
  # Note: cautions always return just 1 date (`known_date`), but convictions
  # could contain multiple orders or sentences, and these will share the same
  # `conviction_date`, so it is safe to pick one, the first one for example.
  #
  def recent_caution_or_conviction?
    known_date = completed_checks.pluck(:known_date).first # for cautions
    conviction_date = completed_checks.pluck(:conviction_date).first # for convictions

    return true if adult_caution?    && known_date.after?(6.years.ago)
    return true if youth_conviction? && conviction_date.after?(66.months.ago) # 5 and 1/2 years
    return true if adult_conviction? && conviction_date.after?(11.years.ago)

    false
  end
end
