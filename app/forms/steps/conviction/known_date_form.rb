module Steps
  module Conviction
    class KnownDateForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :known_date, Date

      acts_as_gov_uk_date :known_date, error_clash_behaviour: :omit_gov_uk_date_field_error

      validates_presence_of :known_date
      validates :known_date, sensible_date: true

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          known_date: known_date
        )
      end
    end
  end
end
