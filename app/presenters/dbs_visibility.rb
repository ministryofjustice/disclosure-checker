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

  # Standard or enhanced check rules:
  #
  #   - Unspent cautions/convictions: will appear on standard or enhanced checks.
  #   - Spent youth cautions: will not appear on standard or enhanced checks.
  #   - Spent custodial convictions: will appear on standard or enhanced checks.
  #   - Recency rules, refer to `#recency_rules_outcome` method.
  #   - Any other combination: may appear on standard or enhanced checks.
  #
  def enhanced
    return :will     unless spent?
    return :will_not if youth_caution?
    return :will     if custodial_conviction?

    recency_rules_outcome || :maybe
  end

  def to_partial_path
    "results/shared/dbs_visibility"
  end

private

  # Recency rules for spent cautions or convictions:
  #
  #   - Adult cautions given within 6 years of the check: will appear.
  #   - Adult cautions given 6 years ago or more of the check: will not appear.
  #   - Youth convictions imposed within 5.5 years of the check: will appear.
  #   - Adult convictions imposed within 11 years of the check: will appear.
  #
  def recency_rules_outcome
    if adult_caution?
      return caution_date.after?(6.years.ago) ? :will : :will_not
    end

    return :will if youth_conviction? && conviction_date.after?(66.months.ago) # 5 and 1/2 years
    return :will if adult_conviction? && conviction_date.after?(11.years.ago)

    nil
  end

  def cautions
    @cautions ||= completed_checks.filter_map(&:caution)
  end

  def convictions
    @convictions ||= completed_checks.filter_map(&:conviction)
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

  def caution_date
    completed_checks.pick(:known_date)
  end

  # NOTE: cautions always return just 1 date (`known_date`), but convictions
  # could contain multiple orders or sentences, and these will share the same
  # `conviction_date`, so it is safe to pick one, the first one for example.
  #
  def conviction_date
    completed_checks.pick(:conviction_date)
  end
end
