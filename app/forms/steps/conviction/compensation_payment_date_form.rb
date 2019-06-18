module Steps
  module Conviction
    class CompensationPaymentDateForm < BaseForm
      include GovUkDateFields::ActsAsGovUkDate

      attribute :compensation_payment_date, Date

      acts_as_gov_uk_date :compensation_payment_date

      validates_presence_of :compensation_payment_date
      validates :compensation_payment_date, sensible_date: true

      private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update(
          compensation_payment_date: compensation_payment_date
        )
      end
    end
  end
end
