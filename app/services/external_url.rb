class ExternalUrl
  GOVUK_TELL_EMPLOYER_EXTERNAL_URL = "https://www.gov.uk/tell-employer-or-college-about-criminal-record/check-your-conviction-caution".freeze

  class << self
    def govuk_service_start_page
      GOVUK_TELL_EMPLOYER_EXTERNAL_URL
    end
  end
end
