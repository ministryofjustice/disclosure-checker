module Steps
  module Conviction
    class ConvictionSubtypeController < Steps::ConvictionStepController
      def edit
        @form_object = ConvictionSubtypeForm.new(
          disclosure_check: current_disclosure_check,
          conviction_subtype: current_disclosure_check.conviction_subtype,
        )
      end

      def update
        update_and_advance(ConvictionSubtypeForm, as: :conviction_subtype)
      end
    end
  end
end
