module Steps
  class ConvictionStepController < StepController
    before_action :redirect_to_root, if: :invalid_kind?

    private

    def invalid_kind?
      current_disclosure_check.kind != 'conviction'
    end

    def decision_tree_class
      ConvictionDecisionTree
    end
  end
end
