# Will use SENTRY_DSN environment variable if set
Sentry.init do |config|
  config.dsn = "https://d82ca719a5b246bf80342c2266fe7550@o345774.ingest.sentry.io/5373163"
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Ensure we get ActionView::MissingTemplate errors
  config.excluded_exceptions -= %w(
    ActionView::MissingTemplate
  )
end
