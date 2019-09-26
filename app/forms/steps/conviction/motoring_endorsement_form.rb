module Steps
  module Conviction
    class MotoringEndorsementForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :motoring_endorsement
    end
  end
end
