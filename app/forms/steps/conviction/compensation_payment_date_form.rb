module Steps
  module Conviction
    class CompensationPaymentDateForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :compensation_payment_date, Date
      attribute :approximate_compensation_payment_date, Boolean

      acts_as_gov_uk_date :compensation_payment_date, error_clash_behaviour: :omit_gov_uk_date_field_error

      validates_presence_of :compensation_payment_date
      validates :compensation_payment_date, sensible_date: true

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          compensation_payment_date: compensation_payment_date,
          approximate_compensation_payment_date: approximate_compensation_payment_date
        )
      end
    end
  end
end
