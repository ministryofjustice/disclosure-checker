module Steps
  module Conviction
    class ConvictionSchedule18Form < BaseForm
      include SingleQuestionForm

      yes_no_attribute :conviction_schedule18
    end
  end
end
