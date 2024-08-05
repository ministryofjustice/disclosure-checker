require_relative "boot"

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
    config.load_defaults 7.0

    # Configuration for the application, engines, and railties goes here.
    #
    # These settings can be overridden in specific environments using the files
    # in config/environments, which are processed later.
    #
    # config.time_zone = "Central Time (US & Canada)"
    # config.eager_load_paths << Rails.root.join("extras")

    # Don't generate system test files.
    config.generators.system_tests = nil

    config.x.session.expires_in_minutes = 60

    config.x.surveys.feedback = "https://www.research.net/r/QW7JCHL".freeze

    # Maintain `in_progress` checks for this number of days
    config.x.checks.incomplete_purge_after_days = 7

    # Maintain `completed` checks for this number of days
    config.x.checks.complete_purge_after_days = 60

    # Cookies permission banner
    config.x.cookies_consent_name = "dc_cookies_consent".freeze
    config.x.cookies_consent_expiration = 1.year

    config.add_autoload_paths_to_load_path = false

    config.sentry_dsn = "https://d82ca719a5b246bf80342c2266fe7550@o345774.ingest.sentry.io/5373163"
  end
end
