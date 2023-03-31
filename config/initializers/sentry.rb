Sentry.init do |config|
  config.dsn = Rails.application.config.sentry_dsn
  config.breadcrumbs_logger = [:active_support_logger, :http_logger]

  # Ensure we get ActionView::MissingTemplate errors
  config.excluded_exceptions -= %w(
    ActionView::MissingTemplate
  )
end
