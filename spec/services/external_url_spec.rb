require 'spec_helper'

RSpec.describe ExternalUrl do
  describe '.govuk_service_start_page' do
    it 'has the correct url' do
      expect(described_class.govuk_service_start_page).to eq(
        'https://www.gov.uk/tell-employer-or-college-about-criminal-record/check-your-conviction-caution'
      )
    end
  end
end
