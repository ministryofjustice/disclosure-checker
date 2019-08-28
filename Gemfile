source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.6.3'

# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false
gem 'govuk_elements_form_builder', '~> 1.3.0'
gem 'gov_uk_date_fields', '~> 4.1.0'
gem 'jquery-rails'
gem 'pg', '~> 1.1.0'
gem 'puma', '~> 3.0'
gem 'rails', '~> 5.2.3'
gem 'responders'
gem 'sass-rails', '< 6.0.0'
gem 'sentry-raven'
gem 'uglifier'
gem 'virtus'

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
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'i18n-tasks', '~> 0.9.28'

  # Available in dev env for generators
  gem 'factory_bot_rails'
  gem 'rspec-rails'
end

group :test do
  gem 'brakeman'
  gem 'capybara'
  gem 'cucumber'
  gem 'cucumber-rails', require: false
  gem 'rails-controller-testing'
  gem 'rspec_junit_formatter'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
  gem 'selenium-webdriver'
  gem 'simplecov', require: false
  gem 'simplecov-rcov'
end
