module Steps
  module Conviction
    class ConvictionBailForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :conviction_bail, reset_when_no: [:conviction_bail_days]
    end
  end
end
