module Backoffice
  class ReportsController < ApplicationController
    RESULTS_LIMIT = 50

    def index
      @reports = if sort_by_sentences?
                   completed_reports.sort_by(&:disclosure_checks_count).reverse.first(limit)
                 else
                   completed_reports.reorder(completed_at: :desc).limit(limit)
                 end
    end

    private

    def limit
      RESULTS_LIMIT
    end

    def completed_reports
      DisclosureReport.completed
    end

    def sort_by_sentences?
      params[:sentences].presence
    end
  end
end
