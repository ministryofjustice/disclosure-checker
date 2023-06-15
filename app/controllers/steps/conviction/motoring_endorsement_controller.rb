module Steps
  module Conviction
    class MotoringEndorsementController < Steps::ConvictionStepController
      def edit
        @form_object = MotoringEndorsementForm.new(
          disclosure_check: current_disclosure_check,
          motoring_endorsement: current_disclosure_check.motoring_endorsement,
        )
      end

      def update
        update_and_advance(MotoringEndorsementForm)
      end
    end
  end
end
