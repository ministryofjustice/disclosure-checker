module Steps
  module Check
    class ResultsController < Steps::CheckStepController
      include CompletionStep

      def show
        @presenter = ResultsPresenter.new(current_disclosure_report)
      end
    end
  end
end
