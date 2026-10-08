module Steps
  module Conviction
    class CompensationPaymentDateForm < BaseForm
      attribute :compensation_payment_date, :multi_param_date
      attribute :approximate_compensation_payment_date, :boolean

      validates_presence_of :compensation_payment_date
      validates :compensation_payment_date, sensible_date: true

    private

      def persist!
        raise DisclosureCheckNotFound unless disclosure_check

        disclosure_check.update!(
          compensation_payment_date:,
          approximate_compensation_payment_date:,
        )
      end
    end
  end
end
