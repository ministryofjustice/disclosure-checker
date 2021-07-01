module Backoffice
  class ReportsController < ApplicationController
    def index
      @reports = DisclosureReport.completed.reorder(completed_at: :desc).limit(50)
    end
  end
end
