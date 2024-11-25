source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

gem "govuk-components", "~> 5.4"
gem "govuk_design_system_formbuilder"
gem "jquery-rails"
gem "ostruct"
gem "pg"
gem "puma"
gem "rails", "~> 7.2"
gem "responders"
gem "sass-rails"
gem "sentry-rails"
gem "sentry-ruby"
gem "terser"
gem "virtus"

group :production do
  gem "lograge"
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
  gem "rspec-rails"
end

group :test do
  gem "brakeman"
  gem "capybara"
  gem "cucumber", "< 10.0.0"
  gem "cucumber-rails", require: false
  gem "rails-controller-testing"
  gem "rubocop-govuk", require: false
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "simplecov-json", require: false
end
