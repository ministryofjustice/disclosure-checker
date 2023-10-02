module Steps
  module Conviction
    class SingleSentenceLengthForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :single_sentence_length
    end
  end
end
