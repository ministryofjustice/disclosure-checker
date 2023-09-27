module Steps
  module Conviction
    class ConvictionMultipleSentencesController < Steps::ConvictionStepController
      def edit
        @form_object = ConvictionMultipleSentencesForm.new(
          disclosure_check: current_disclosure_check,
          conviction_multiple_sentences: current_disclosure_check.conviction_multiple_sentences,
        )
      end

      def update
        update_and_advance(ConvictionMultipleSentencesForm)
      end
    end
  end
end
