ENV["RAILS_ENV"] ||= "test"
require File.expand_path("../config/environment", __dir__)
abort("The Rails environment is running in production mode!") if Rails.env.production?
require "spec_helper"
require "rspec/rails"
require_relative "../spec/support/view_spec_helpers"

ActiveRecord::Migration.maintain_test_schema!

RSpec::Expectations.configuration.on_potential_false_positives = :nothing

RSpec.configure do |config|
  config.infer_spec_type_from_file_location!

  config.filter_rails_from_backtrace!

  config.include(ActiveSupport::Testing::TimeHelpers)

  config.include(ViewSpecHelpers, type: :helper)

  config.before(:each, type: :helper) { initialize_view_helpers(helper) }

  config.before(:each, :js) do
    page.driver.browser.url_whitelist = %w[127.0.0.1 localhost]
  end

  config.include FactoryBot::Syntax::Methods

  config.use_transactional_fixtures = true
end

RSpec::Matchers.define_negated_matcher :not_change, :change
