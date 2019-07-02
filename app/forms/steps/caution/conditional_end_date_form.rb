module Steps
  module Caution
    class ConditionalEndDateForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :conditional_end_date, Date

      acts_as_gov_uk_date :conditional_end_date

      validates_presence_of :conditional_end_date
      validates :conditional_end_date, sensible_date: { allow_future: true }

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          conditional_end_date: conditional_end_date
        )
      end
    end
  end
end
