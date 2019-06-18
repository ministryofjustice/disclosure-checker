module Steps
  module Conviction
    class CompensationPaymentDateController < Steps::ConvictionStepController
      def edit
        @form_object = CompensationPaymentDateForm.new(
          disclosure_check: current_disclosure_check,
          compensation_payment_date: current_disclosure_check.compensation_payment_date
        )
      end

      def update
        update_and_advance(CompensationPaymentDateForm, as: :compensation_payment_date)
      end
    end
  end
end
