module Steps
  module Conviction
    class ConvictionTypeController < Steps::ConvictionStepController
      def edit
        @form_object = ConvictionTypeForm.new(
          disclosure_check: current_disclosure_check,
          conviction_type: current_disclosure_check.conviction_type,
        )
      end

      def update
        update_and_advance(ConvictionTypeForm)
      end
    end
  end
end
