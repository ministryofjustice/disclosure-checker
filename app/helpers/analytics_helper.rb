module AnalyticsHelper
  def analytics_consent_cookie
    cookies[Rails.configuration.x.cookies_consent_name]
  end

  def analytics_consent_accepted?
    analytics_consent_cookie.eql?(CookieSettingsForm::CONSENT_ACCEPT)
  end

  def analytics_allowed?
    analytics_consent_accepted?
  end
end
