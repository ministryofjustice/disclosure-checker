source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read(".ruby-version").strip

# Reduces boot times through caching; required in config/boot.rb
gem "bootsnap", ">= 1.1.0", require: false
gem "govuk_design_system_formbuilder", "~> 3.1.0"
gem "jquery-rails"
gem "mimemagic", "~> 0.3.7"
gem "pg"
gem "puma"
gem "rails", "~> 7.1"
gem "responders"
gem "sass-rails", "< 6.0.0"
gem "sentry-rails"
gem "sentry-ruby"
gem "uglifier"
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
  gem "listen"
  gem "rspec-rails"
end

group :test do
  gem "brakeman"
  gem "capybara"
  gem "cucumber", "< 9.0.0"
  gem "cucumber-rails", require: false
  gem "rails-controller-testing"
  gem "rubocop-govuk", require: false
  gem "selenium-webdriver"
  gem "simplecov", require: false
  gem "simplecov-rcov"
end
