module Steps
  module Conviction
    class ConvictionSchedule18Form < BaseForm
      include SingleQuestionForm

      yes_no_attribute :conviction_schedule18

      def i18n_attribute
        "conviction_schedule18_text"
      end
    end
  end
end
