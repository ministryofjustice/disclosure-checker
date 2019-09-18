module SecurityHandling
  extend ActiveSupport::Concern

  included do
    protect_from_forgery with: :exception, prepend: true

    before_action :check_http_credentials,
                  :drop_dangerous_headers!,
                  :ensure_session_validity

    after_action :set_security_headers

    helper_method :session_expire_in_minutes
  end

  def session_expire_in_minutes
    Rails.configuration.x.session.expires_in_minutes
  end

  def session_expire_in_seconds
    session_expire_in_minutes * 60
  end

  private

  def ensure_session_validity
    epoch = Time.now.to_i
    reset_session if epoch - session.fetch(:last_seen, epoch) > session_expire_in_seconds
    session[:last_seen] = epoch
  end

  def drop_dangerous_headers!
    request.env.except!('HTTP_X_FORWARDED_HOST') # just drop the variable
  end

  def set_security_headers
    additional_headers_for_all_requests.each do |name, value|
      response.set_header(name, value)
    end
  end

  def additional_headers_for_all_requests
    {
      'X-Frame-Options'           => 'SAMEORIGIN',
      'X-XSS-Protection'          => '1; mode=block',
      'X-Content-Type-Options'    => 'nosniff',
      'Strict-Transport-Security' => 'max-age=15768000; includeSubDomains',
    }
  end

  # :nocov:
  def authenticate_participant(username)
    return unless Participant.valid_reference?(username)

    @_current_participant = Participant.touch_or_create_by(reference: username)
  end

  def authenticate_internal_user(username, password)
    username == ENV.fetch('HTTP_AUTH_USER') && password == ENV.fetch('HTTP_AUTH_PASSWORD')
  end

  def check_http_credentials
    return unless ENV.fetch('HTTP_AUTH_ENABLED', false)

    authenticate_or_request_with_http_basic do |username, password|
      if request.fullpath.include?('backoffice')
        authenticate_internal_user(username, password)
      elsif username.eql?(password)
        authenticate_participant(username)
      else
        authenticate_internal_user(username, password)
      end
    end
  end
  # :nocov:
end
