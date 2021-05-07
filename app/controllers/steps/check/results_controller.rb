module Steps
  module Check
    class ResultsController < Steps::CheckStepController
      before_action :check_disclosure_report_completed

      def show
        @presenter = ResultsPresenter.new(current_disclosure_report)
      end
    end
  end
end
