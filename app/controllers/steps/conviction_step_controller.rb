module Steps
  class ConvictionStepController < StepController
    before_action :check_for_conviction

    private

    def check_for_conviction
      if current_disclosure_check.kind != "conviction"
        current_disclosure_check.navigation_stack.pop
        current_disclosure_check.save
        redirect_to root_path
      end
    end

    def decision_tree_class
      ConvictionDecisionTree
    end
  end
end
