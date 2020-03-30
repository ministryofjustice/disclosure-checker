module Steps
  module Conviction
    class CompensationPaidAmountController < Steps::ConvictionStepController
      def edit
        @form_object = CompensationPaidAmountForm.build(current_disclosure_check)
      end

      def update
        update_and_advance(CompensationPaidAmountForm)
      end
    end
  end
end
