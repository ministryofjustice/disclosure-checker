module Steps
  module Conviction
    class ConvictionBailController < Steps::ConvictionStepController
      def edit
        @form_object = ConvictionBailForm.new(
          disclosure_check: current_disclosure_check,
          conviction_bail: current_disclosure_check.conviction_bail,
        )
      end

      def update
        update_and_advance(ConvictionBailForm)
      end
    end
  end
end
