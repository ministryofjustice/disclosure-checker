require "selenium-webdriver"
require "capybara"
require "capybara/dsl"
require "capybara/cucumber"
require "cucumber/rails"
require "dotenv/load"

# For some weird reason cucumber tests fail unless ActionMailer is required
require "action_mailer/railtie"

Capybara.register_driver(:chrome_headless) do |app|
  args = %w[disable-gpu no-sandbox]
  args << "headless" unless ENV["SHOW_BROWSER"]

  options = Selenium::WebDriver::Chrome::Options.new(unhandled_prompt_behavior: "ignore", args:)

  Capybara::Selenium::Driver.new(app, browser: :chrome, options:)
end

Capybara.default_driver = :chrome_headless
