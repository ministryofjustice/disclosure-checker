module Steps
  module Conviction
    class ConvictionMultipleSentencesForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :conviction_multiple_sentences
    end
  end
end
