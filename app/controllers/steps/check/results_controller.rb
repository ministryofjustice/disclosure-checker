module Steps
  module Check
    class ResultsController < Steps::CheckStepController
      include CompletionStep

      def show
        if show_check_answers?
          redirect_to steps_check_check_your_answers_path
        else
          @presenter = ResultsPresenter.build(current_disclosure_check)
          render variants: @presenter.variant
        end
      end

      private

      # TODO: temporary feature-flag, to be removed when not needed
      def show_check_answers?
        enable_multiples? && continue_to_check_your_answers?
      end

      def enable_multiples?
        cookies[:multiples_enabled].present?
      end

      def continue_to_check_your_answers?
        params[:show_results].blank?
      end
    end
  end
end
