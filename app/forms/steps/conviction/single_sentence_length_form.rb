module Steps
  module Conviction
    class SingleSentenceLengthForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :single_sentence_length

      def i18n_attribute
        "single_sentence_text"
      end
    end
  end
end
