module Steps
  module Conviction
    class ConvictionTypeController < Steps::ConvictionStepController
      def edit
        @form_object = ConvictionTypeForm.new(
          disclosure_check: current_disclosure_check,
          conviction_type: current_disclosure_check.conviction_type
        )
      end

      def update
        update_and_advance(ConvictionTypeForm, as: as_name)
      end

      private

      # TODO: temporary feature-flag, to be removed when no needed
      def as_name
        cookies[:motoring_enabled].present? ? :conviction_type : :bypass_motoring_conviction_type
      end
    end
  end
end
