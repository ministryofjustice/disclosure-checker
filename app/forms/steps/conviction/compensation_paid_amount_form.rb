module Steps
  module Conviction
    class CompensationPaidAmountForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :compensation_payment_over_100
    end
  end
end
