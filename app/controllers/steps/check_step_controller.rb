module Steps
  class CheckStepController < StepController
  private

    def decision_tree_class
      CheckDecisionTree
    end
  end
end
