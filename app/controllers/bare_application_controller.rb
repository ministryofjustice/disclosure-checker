class BareApplicationController < ActionController::Base # rubocop:disable Rails/ApplicationController
  # NOTE: Use this as the superclass for controllers that do not require
  # any special session/cookies handling nor error handling.
  # For any other controller, use `ApplicationController` instead.
  # This is required to get request attributes in to the production logs.
  # See the various lograge configurations in `production.rb`.
  def append_info_to_payload(payload)
    super
    payload[:referrer] = request&.referrer
    payload[:user_agent] = request&.user_agent
  end
end
