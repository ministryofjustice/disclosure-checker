class DisclosureCheck < ApplicationRecord
  belongs_to :check_group, default: -> { create_check_group }
  has_one :disclosure_report, through: :check_group

  delegate :no_drag_through?, to: :conviction, allow_nil: true

  enum :status, {
    in_progress: 0,
    completed: 10,
  }

  composed_of :conviction, allow_nil: true, constructor: :find_constant,
                           mapping: [%i[conviction_subtype value]], class_name: "ConvictionType"

  composed_of :caution, allow_nil: true, constructor: :find_constant,
                        mapping: [%i[caution_type value]], class_name: "CautionType"

  def conviction_length_in_years(conviction_length)
    if conviction_length_type == ConvictionLengthType::MONTHS.to_s
      conviction_length.months.in_years
    elsif conviction_length_type == ConvictionLengthType::DAYS.to_s
      conviction_length.days.in_years
    elsif conviction_length_type == ConvictionLengthType::WEEKS.to_s
      conviction_length.weeks.in_years
    elsif conviction_length_type == ConvictionLengthType::YEARS.to_s
      conviction_length.years.in_years
    end
  end

  def schedule18_over_4_years
    return nil if conviction_schedule18.blank?

    if conviction_schedule18.inquiry.yes? && (conviction_multiple_sentences.inquiry.no? || single_sentence_over4.inquiry.yes?)
      "yes"
    else
      "no"
    end
  end

  def schedule18_over_4_years?
    schedule18_over_4_years == "yes"
  end
end
