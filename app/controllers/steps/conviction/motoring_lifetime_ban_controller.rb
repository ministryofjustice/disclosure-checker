module Steps
  module Conviction
    class MotoringLifetimeBanController < Steps::ConvictionStepController
      def edit
        @form_object = MotoringLifetimeBanForm.new(
          disclosure_check: current_disclosure_check,
          motoring_lifetime_ban: current_disclosure_check.motoring_lifetime_ban
        )
      end

      def update
        update_and_advance(MotoringLifetimeBanForm)
      end
    end
  end
end
