require 'rails_helper'

RSpec.describe CookieSettingsForm do
  subject { described_class.new(consent: consent_value, cookies: cookies_double) }

  let(:cookies_double) { {} }

  describe '#save' do
    context 'for an `accept` value' do
      let(:consent_value) { CookieSettingsForm::CONSENT_ACCEPT }

      it 'sets the cookie and return the consent value' do
        expect(subject.save).to eq('accept')
        expect(cookies_double['dc_cookies_consent']).to eq({ expires: 1.year, value: 'accept' })
      end
    end

    context 'for a `reject` value' do
      let(:consent_value) { CookieSettingsForm::CONSENT_REJECT }

      it 'sets the cookie and return the consent value' do
        expect(subject.save).to eq('reject')
        expect(cookies_double['dc_cookies_consent']).to eq({ expires: 1.year, value: 'reject' })
      end
    end

    context 'for an unknown value' do
      let(:consent_value) { 'foobar' }

      it 'sets the cookie and defaults to `reject` consent' do
        expect(subject.save).to eq('reject')
        expect(cookies_double['dc_cookies_consent']).to eq({ expires: 1.year, value: 'reject' })
      end
    end
  end
end
