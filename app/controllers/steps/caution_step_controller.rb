module Steps
  class CautionStepController < StepController
    before_action :redirect_to_root, if: :invalid_kind?

  private

    def invalid_kind?
      current_disclosure_check.kind != CheckKind::CAUTION.to_s
    end

    def decision_tree_class
      CautionDecisionTree
    end
  end
end
