class DisclosureCheck < ApplicationRecord
  belongs_to :check_group, default: -> { create_check_group }
  has_one :disclosure_report, through: :check_group

  delegate :drag_through?, to: :conviction, allow_nil: true

  enum status: {
    in_progress: 0,
    completed: 10,
  }

  composed_of :conviction, allow_nil: true, constructor: :find_constant,
                           mapping: [%i[conviction_subtype value]], class_name: "ConvictionType"

  composed_of :caution, allow_nil: true, constructor: :find_constant,
                        mapping: [%i[caution_type value]], class_name: "CautionType"
end
