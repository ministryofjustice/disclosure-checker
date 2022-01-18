require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
# require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
require "sprockets/railtie"
require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module Disclosure
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 6.1

    # This automatically adds id: :uuid to create_table in all future migrations
    config.generators do |g|
      g.orm :active_record, primary_key_type: :uuid
    end

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.x.session.expires_in_minutes = ENV.fetch('SESSION_EXPIRES_IN_MINUTES', 60).to_i

    config.x.surveys.feedback = 'https://www.research.net/r/QW7JCHL'.freeze

    # Maintain `in_progress` checks for this number of days
    config.x.checks.incomplete_purge_after_days = 7

    # Maintain `completed` checks for this number of days
    config.x.checks.complete_purge_after_days = 60

    # Cookies permission banner
    config.x.cookies_consent_name = 'dc_cookies_consent'.freeze
    config.x.cookies_consent_expiration = 1.year
  end
end
