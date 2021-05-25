module Steps
  module Caution
    class KnownDateForm < BaseForm
      attribute :known_date, MultiParamDate
      attribute :approximate_known_date, Boolean

      validates_presence_of :known_date
      validates :known_date, sensible_date: true
      validate :before_conditional_date?

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          known_date: known_date,
          approximate_known_date: approximate_known_date
        )
      end

      def before_conditional_date?
        return if known_date.blank? || disclosure_check.conditional_end_date.blank?

        errors.add(:known_date, :before_conditional_date) if known_date > disclosure_check.conditional_end_date
      end
    end
  end
end
