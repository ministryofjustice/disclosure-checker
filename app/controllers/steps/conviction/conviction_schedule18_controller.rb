module Steps
  module Conviction
    class ConvictionSchedule18Controller < Steps::ConvictionStepController
      def edit
        @form_object = ConvictionSchedule18Form.new(
          disclosure_check: current_disclosure_check,
          conviction_schedule18: current_disclosure_check.conviction_schedule18,
        )
      end

      def update
        update_and_advance(ConvictionSchedule18Form)
      end
    end
  end
end
