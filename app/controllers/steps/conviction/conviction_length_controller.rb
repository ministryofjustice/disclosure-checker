module Steps
  module Conviction
    class ConvictionLengthController < Steps::ConvictionStepController
      def edit
        @form_object = ConvictionLengthForm.new(
          disclosure_check: current_disclosure_check,
          conviction_length: current_disclosure_check.conviction_length,
        )
      end

      def update
        update_and_advance(ConvictionLengthForm)
      end
    end
  end
end
