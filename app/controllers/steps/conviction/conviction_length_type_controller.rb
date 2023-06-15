module Steps
  module Conviction
    class ConvictionLengthTypeController < Steps::ConvictionStepController
      def edit
        @form_object = ConvictionLengthTypeForm.new(
          disclosure_check: current_disclosure_check,
          conviction_length_type: current_disclosure_check.conviction_length_type,
        )
      end

      def update
        update_and_advance(ConvictionLengthTypeForm)
      end
    end
  end
end
