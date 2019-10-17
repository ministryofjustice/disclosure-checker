module Steps
  module Check
    class CheckYourAnswersController < Steps::CheckStepController
      def show
        @presenter = ResultsPresenter.build(current_disclosure_check)
      end
    end
  end
end
