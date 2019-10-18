module Steps
  module Check
    class CheckYourAnswersController < Steps::CheckStepController
      def show
        @presenters = current_disclosure_report.check_groups.map do |check_group|
          check_group.disclosure_checks.map do |disclosure_check|
            ResultsPresenter.build(disclosure_check)
          end
        end.flatten
      end
    end
  end
end
