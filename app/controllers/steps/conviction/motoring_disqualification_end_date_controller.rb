module Steps
  module Conviction
    class MotoringDisqualificationEndDateController < Steps::ConvictionStepController
      def edit
        @form_object = MotoringDisqualificationEndDateForm.new(
          disclosure_check: current_disclosure_check,
          motoring_disqualification_end_date: current_disclosure_check.motoring_disqualification_end_date
        )
      end

      def update
        update_and_advance(MotoringDisqualificationEndDateForm, as: :motoring_disqualification_end_date)
      end
    end
  end
end
