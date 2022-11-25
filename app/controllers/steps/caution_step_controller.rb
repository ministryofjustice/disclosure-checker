module Steps
  class CautionStepController < StepController
    before_action :check_for_caution

    private

    def check_for_caution
      if current_disclosure_check.kind != "caution"
        current_disclosure_check.navigation_stack.pop
        current_disclosure_check.save
        redirect_to root_path
      end
    end

    def decision_tree_class
      CautionDecisionTree
    end
  end
end
