class ReportsController < ApplicationController
  include CompletionStep

  def finish
    redirect_to steps_check_results_path
  end
end
