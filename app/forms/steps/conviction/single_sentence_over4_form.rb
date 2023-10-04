module Steps
  module Conviction
    class SingleSentenceOver4Form < BaseForm
      include SingleQuestionForm

      yes_no_attribute :single_sentence_over4
    end
  end
end
