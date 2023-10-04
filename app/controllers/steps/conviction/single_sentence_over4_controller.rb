module Steps
  module Conviction
    class SingleSentenceOver4Controller < Steps::ConvictionStepController
      def edit
        @form_object = SingleSentenceOver4Form.new(
          disclosure_check: current_disclosure_check,
          single_sentence_over4: current_disclosure_check.single_sentence_over4,
        )
      end

      def update
        update_and_advance(SingleSentenceOver4Form)
      end
    end
  end
end
