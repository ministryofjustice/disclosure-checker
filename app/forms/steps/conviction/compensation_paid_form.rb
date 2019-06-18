module Steps
  module Conviction
    class CompensationPaidForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :compensation_paid
    end
  end
end
