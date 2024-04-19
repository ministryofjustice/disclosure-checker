module Steps
  module Conviction
    class ConvictionBailDaysController < Steps::ConvictionStepController
      def edit
        @form_object = ConvictionBailDaysForm.new(
          disclosure_check: current_disclosure_check,
          conviction_bail_days: current_disclosure_check.conviction_bail_days,
        )
      end

      def update
        update_and_advance(ConvictionBailDaysForm)
      end
    end
  end
end
