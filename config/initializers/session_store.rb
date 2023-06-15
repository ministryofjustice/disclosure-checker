# NOTE: this will setup a session-only cookie, which will expire as soon
# as the browser is closed.
#
# There is a request-based check to expire the session if the cookie is
# too old (refer to: `/concerns/security_handling.rb`).
#
Rails.application.config.session_store :cookie_store, key: "_disclosure_checker_session"
