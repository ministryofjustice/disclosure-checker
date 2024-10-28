class DisclosureReport < ApplicationRecord
  has_many :check_groups, dependent: :destroy
  has_many :disclosure_checks, through: :check_groups

  enum :status, {
    in_progress: 0,
    completed: 10,
  }

  def self.purge!(date)
    where("created_at <= :date", date:).destroy_all
  end

  def completed!
    update!(status: :completed, completed_at: Time.current)
  end

  delegate :count, to: :disclosure_checks, prefix: true

  # Convenience methods to return collections of just one kind
  #
  def caution_checks
    disclosure_checks.where(kind: CheckKind::CAUTION.to_s)
  end

  def conviction_checks
    disclosure_checks.where(kind: CheckKind::CONVICTION.to_s)
  end
end
