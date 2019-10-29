class DisclosureCheck < ApplicationRecord
  belongs_to :check_group, default: -> { create_check_group }
  has_one :disclosure_report, through: :check_group

  enum status: {
    in_progress: 0,
    completed: 10,
  }

  # TODO: once the new data models are in place, we would do the purge
  # through the DisclosureReport model, instead of here, and we will be
  # able to remove this method and spec.
  #
  def self.purge!(date)
    where('created_at <= :date', date: date).where(check_group_id: nil).destroy_all
  end
end
