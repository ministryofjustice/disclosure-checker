module Steps
  module Conviction
    class CompensationPaidController < Steps::ConvictionStepController
      def edit
        @form_object = CompensationPaidForm.new(
          disclosure_check: current_disclosure_check,
          compensation_paid: current_disclosure_check.compensation_paid,
        )
      end

      def update
        update_and_advance(CompensationPaidForm)
      end
    end
  end
end
