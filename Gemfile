source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem "govuk-components", "~> 6.0.0"
gem "govuk_design_system_formbuilder", ">= 6.2.0"
gem "jquery-rails"
gem "ostruct"
gem "pg"
gem "puma"
gem "rails", "~> 8.1.4.0"
gem "responders", ">= 3.2.1"
gem "sass-rails"
gem "sentry-rails", ">= 6.6.0"
gem "sentry-ruby"
gem "terser"

group :production do
  gem "lograge", ">= 0.15.0"
  gem "logstash-event"
end

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "i18n-debug"
end

group :development, :test do
  gem "debug"
  gem "dotenv-rails"
  gem "factory_bot_rails"
  gem "i18n-tasks"
  gem "rspec-rails", ">= 8.0.5"
end

group :test do
  gem "brakeman"
  gem "capybara"
  gem "capybara-lockstep", ">= 2.4.0"
  gem "rails-controller-testing"
  gem "rubocop-govuk", require: false
  gem "selenium-webdriver", ">= 4.45.0"
  gem "simplecov", require: false
  gem "simplecov-json", require: false
end
