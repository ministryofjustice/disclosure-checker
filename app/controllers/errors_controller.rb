class ErrorsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def invalid_session
    respond_with_status(:not_found)
  end

  def not_found
    respond_with_status(:not_found)
  end

  def results_not_found
    respond_with_status(:not_found)
  end

  def report_completed
    respond_with_status(:unprocessable_entity)
  end

  def report_not_completed
    respond_with_status(:unprocessable_entity)
  end

  def unhandled
    respond_with_status(:internal_server_error)
  end

  def maintenance
    respond_with_status(:service_unavailable)
  end

private

  def respond_with_status(status)
    render status:
  end
end
