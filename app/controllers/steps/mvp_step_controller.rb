module Steps
  class MvpStepController < StepController
    skip_before_action :check_disclosure_check_presence,
                       :check_disclosure_check_not_completed
  end
end
