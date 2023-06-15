class CookiesController < ApplicationController
  def show; end

  def update
    result = CookieSettingsForm.new(
      consent: consent_param,
      cookies:,
    ).save

    redirect_back fallback_location: root_path, flash: { cookies_consent_updated: result }
  end

private

  def consent_param
    params.require(:cookies)
  end
end
