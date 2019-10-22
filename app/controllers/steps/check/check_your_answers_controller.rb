module Steps
  module Check
    class CheckYourAnswersController < Steps::CheckStepController
      def show
        @presenter = CheckAnswersPresenter.new(current_disclosure_report)
      end
    end
  end
end
