module Steps
  module Caution
    class ConditionalEndDateForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :conditional_end_date, Date

      acts_as_gov_uk_date :conditional_end_date

      validates_presence_of :conditional_end_date
      validates :conditional_end_date, sensible_date: { allow_future: true }
      validate :after_caution_date?

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          conditional_end_date: conditional_end_date
        )
      end

      def after_caution_date?
        return if conditional_end_date.blank? || disclosure_check.known_date.blank?

        errors.add(:conditional_end_date, :after_caution_date) if conditional_end_date < disclosure_check.known_date
      end
    end
  end
end
