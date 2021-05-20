module Steps
  class ChecksController < CheckStepController
    def edit
      @form_object = Steps::Check::RemoveCheckForm.build(disclosure_check)
    end

    def update
      update_and_advance(Steps::Check::RemoveCheckForm)
    end

    private

    def disclosure_check
      current_disclosure_report.disclosure_checks.find(params[:id])
    end
  end
end
