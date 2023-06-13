module Steps
  class ChecksController < CheckStepController
    after_action :swap_current_disclosure_check_session, only: [:update]

    def edit
      @form_object = Steps::Check::RemoveCheckForm.build(disclosure_check)
    end

    def update
      update_and_advance(Steps::Check::RemoveCheckForm)
    end

  private

    def disclosure_checks
      @disclosure_checks ||= current_disclosure_report.disclosure_checks
    end

    def disclosure_check
      @disclosure_check ||= disclosure_checks.find(params[:id])
    end

    def swap_current_disclosure_check_session
      swap_disclosure_check_session(disclosure_checks.last.id) if disclosure_checks.any?
    end
  end
end
