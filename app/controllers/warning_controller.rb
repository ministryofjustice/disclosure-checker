class WarningController < ApplicationController
  before_action :check_disclosure_check_presence

  def reset_session; end
end
