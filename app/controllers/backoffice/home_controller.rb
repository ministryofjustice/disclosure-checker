module Backoffice
  class HomeController < ApplicationController
    def index
      redirect_to backoffice_reports_path
    end
  end
end
