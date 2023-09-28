module Steps
  module Conviction
    class SingleSentenceLengthController < Steps::ConvictionStepController
      def edit
        @form_object = SingleSentenceLengthForm.new(
          disclosure_check: current_disclosure_check,
          single_sentence_length: current_disclosure_check.single_sentence_length
        )
      end

      def update
        update_and_advance(SingleSentenceLengthForm)
      end
    end
  end
end
