# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self
    policy.font_src    :self
    policy.img_src     :self, :https, :data
    policy.object_src  :none
    policy.script_src  :self,
                       "https://www.googletagmanager.com",
                       "https://browser.sentry-cdn.com"
    # GOV.UK Frontend components use inline style attributes, so unsafe-inline is required
    policy.style_src   :self, :unsafe_inline
    policy.frame_src   "https://www.googletagmanager.com"
    policy.connect_src :self, "https://o345774.ingest.sentry.io"
    policy.base_uri    :self
    policy.form_action :self
  end

  # Generate a fresh random nonce per request (more secure than session-based)
  config.content_security_policy_nonce_generator = ->(_request) { SecureRandom.base64(16) }
  config.content_security_policy_nonce_directives = %w[script-src]
end
