class ExperimentsController < ApplicationController
  before_action :check_permissions, :reset_disclosure_check_session

  # :nocov:
  def enable_adults
    cookies.permanent[:adults_enabled] = 1
    redirect_to root_path
  end

  def disable_adults
    cookies.delete :adults_enabled
    redirect_to root_path
  end

  def enable_motoring
    cookies.permanent[:motoring_enabled] = 1
    redirect_to root_path
  end

  def disable_motoring
    cookies.delete :motoring_enabled
    redirect_to root_path
  end
  # :nocov:

  private

  def check_permissions
    raise 'For development use only' unless helpers.dev_tools_enabled?
  end
end
