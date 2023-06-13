module DisclosureCheckerApp
  class Status
    def result
      {
        service_status:,
        dependencies: {
          database_status:,
        },
      }
    end

    def success?
      service_status.eql?("ok")
    end

  private

    def database_status
      # This will only catch high-level failures.  PG::ConnectionBad gets
      # raised too early in the stack to rescue here.
      @database_status ||= (ActiveRecord::Base.connection ? "ok" : "failed")
    end

    def service_status
      if database_alive
        "ok"
      else
        "failed"
      end
    end

    def database_alive
      database_status == "ok"
    end
  end
end
