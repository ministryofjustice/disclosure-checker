module Steps
  module Conviction
    class ConvictionSchedule18Form < BaseForm
      include SingleQuestionForm

      yes_no_attribute :conviction_schedule18

      # As we reuse this form object in multiple views, this is the attribute
      # that will be used to choose the locales for legends and hints.
      def i18n_attribute
        conviction_subtype
      end
    end
  end
end
