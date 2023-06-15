class StatusController < BareApplicationController
  respond_to :json

  BUILD_ARGS = {
    build_date: ENV["APP_BUILD_DATE"],
    build_tag: ENV["APP_BUILD_TAG"],
    commit_id: ENV["APP_GIT_COMMIT"],
  }.freeze

  def index
    check = DisclosureCheckerApp::Status.new
    status_code = check.success? ? :ok : :service_unavailable

    respond_with(check.result, status: status_code)
  end

  def ping
    respond_with(BUILD_ARGS)
  end
end
