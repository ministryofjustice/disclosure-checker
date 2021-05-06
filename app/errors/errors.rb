module Errors
  class ResultsNotFound < StandardError; end

  class InvalidSession < StandardError; end

  class ReportCompleted < StandardError; end

  class ReportNotCompleted < StandardError; end
end
