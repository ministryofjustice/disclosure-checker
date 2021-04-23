module Steps
  module Check
    class ResultsController < Steps::CheckStepController
      include CompletionStep

      # TODO: temporary feature-flag, to be removed when not needed
      prepend_before_action :show_check_answers_if_enabled, only: [:show]

      def show
        @presenter = if show_multiple_results?
                       CheckAnswersPresenter.new(current_disclosure_report)
                     else
                       ResultsPresenter.build(current_disclosure_check)
                     end

        render variants: @presenter.variant
      end

      private

      def show_check_answers_if_enabled
        redirect_to steps_check_check_your_answers_path if show_check_answers?
      end

      def show_check_answers?
        continue_to_check_your_answers?
      end

      def show_multiple_results?
        !continue_to_check_your_answers?
      end

      def continue_to_check_your_answers?
        params[:show_results].blank?
      end
    end
  end
end
