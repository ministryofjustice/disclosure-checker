require "rails_helper"

RSpec.describe AnalyticsHelper, type: :helper do
  describe "#analytics_consent_cookie" do
    it "retrieves the analytics consent cookie" do
      expect(controller.cookies).to receive(:[]).with("dc_cookies_consent")
      helper.analytics_consent_cookie
    end
  end

  describe "#analytics_consent_accepted?" do
    before do
      allow(controller.cookies).to receive(:[]).with("dc_cookies_consent").and_return(value)
    end

    context "when cookies has been accepted" do
      let(:value) { CookieSettingsForm::CONSENT_ACCEPT }

      it { expect(helper.analytics_consent_accepted?).to be(true) }
    end

    context "when cookies has been rejected" do
      let(:value) { CookieSettingsForm::CONSENT_REJECT }

      it { expect(helper.analytics_consent_accepted?).to be(false) }
    end
  end

  describe "#analytics_allowed?" do
    before do
      allow(helper).to receive(:analytics_consent_accepted?).and_return(consent_accepted)
    end

    let(:consent_accepted) { nil }

    context "and consent has been granted by the user" do
      let(:consent_accepted) { true }

      it { expect(helper.analytics_allowed?).to be(true) }
    end

    context "and consent has not been granted by the user" do
      let(:consent_accepted) { false }

      it { expect(helper.analytics_allowed?).to be(false) }
    end
  end
end
