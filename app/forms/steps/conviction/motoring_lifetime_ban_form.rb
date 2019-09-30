module Steps
  module Conviction
    class MotoringLifetimeBanForm < BaseForm
      include SingleQuestionForm

      yes_no_attribute :motoring_lifetime_ban
    end
  end
end
