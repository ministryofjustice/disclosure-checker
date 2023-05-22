source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby File.read('.ruby-version')

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

# This gem complies with the GOV.UK Design System
# https://design-system.service.gov.uk
# https://govuk-form-builder.netlify.app
gem 'govuk_design_system_formbuilder', '~> 3.1.0'

gem 'jquery-rails'
gem 'pg'
gem 'puma'
gem 'rails', '~> 6.1'
gem 'responders'
gem 'sass-rails', '< 6.0.0'
gem 'sentry-rails'
gem 'sentry-ruby'
gem 'uglifier'
gem 'virtus'
gem 'mimemagic', '~> 0.3.7'

group :production do
  gem 'lograge'
  gem 'logstash-event'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'i18n-debug'
  gem 'web-console'
end

group :development, :test do
  gem 'dotenv-rails'
  gem 'listen'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'i18n-tasks'

  # Available in dev env for generators
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :test do
  gem 'brakeman'
  gem 'capybara'
  gem 'cucumber', '< 9.0.0'
  gem 'cucumber-rails', require: false
  gem 'rails-controller-testing'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'simplecov-rcov'
end
