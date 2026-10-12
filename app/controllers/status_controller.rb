class StatusController < BareApplicationController
  respond_to :json

  BUILD_ARGS = {
    build_date: ENV["APP_BUILD_DATE"],
    build_tag: ENV["APP_BUILD_TAG"],
    commit_id: ENV["APP_GIT_COMMIT"],
  }.freeze

  before_action :authenticate_deploy_dashboard!, only: :deploy_info

  def index
    check = DisclosureCheckerApp::Status.new
    status_code = check.success? ? :ok : :service_unavailable

    respond_with(check.result, status: status_code)
  end

  def ping
    respond_with({ status: "ok" })
  end

  def deploy_info
    respond_with(BUILD_ARGS)
  end

private

  def authenticate_deploy_dashboard!
    expected_secret = ENV.fetch("DEPLOY_DASHBOARD_SHARED_SECRET", nil)
    provided_secret = request.headers["X-Deploy-Dashboard-Secret"]

    return if expected_secret.present? &&
      provided_secret.present? &&
      ActiveSupport::SecurityUtils.secure_compare(provided_secret, expected_secret)

    head :unauthorized
  end
end
