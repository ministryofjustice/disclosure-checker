class CheckGroup < ApplicationRecord
  belongs_to :disclosure_report, default: -> { create_disclosure_report }
  has_many :disclosure_checks, dependent: :destroy
  scope :with_completed_checks, -> { joins(:disclosure_checks).where(disclosure_checks: { status: :completed }) }

  has_many :completed_disclosure_checks, -> { completed_check }, class_name: 'DisclosureCheck'
end
