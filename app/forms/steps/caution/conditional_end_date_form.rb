module Steps
  module Caution
    class ConditionalEndDateForm < BaseForm
      attribute :conditional_end_date, MultiParamDate
      attribute :approximate_conditional_end_date, Boolean

      validates_presence_of :conditional_end_date
      validates :conditional_end_date, sensible_date: { allow_future: true }
      validate :after_caution_date?

    private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          conditional_end_date: conditional_end_date,
          approximate_conditional_end_date: approximate_conditional_end_date
        )
      end

      def after_caution_date?
        return if conditional_end_date.blank? || disclosure_check.known_date.blank?

        errors.add(:conditional_end_date, :after_caution_date) if conditional_end_date < disclosure_check.known_date
      end
    end
  end
end
