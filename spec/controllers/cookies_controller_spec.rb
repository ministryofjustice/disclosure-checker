require "rails_helper"

RSpec.describe CookiesController do
  describe "#show" do
    it "renders the expected page" do
      get :show
      expect(response).to render_template(:show)
    end
  end

  describe "#update" do
    let(:param_value) { CookieSettingsForm::CONSENT_ACCEPT }

    # NOTE: there are more in deep tests in `spec/forms/cookie_settings_form_spec.rb`
    it "saves the form and redirects setting the flash" do
      expect(
        CookieSettingsForm,
      ).to receive(:new).with(
        consent: param_value, cookies: an_instance_of(ActionDispatch::Cookies::CookieJar),
      ).and_call_original

      post :update, params: { cookies: param_value }

      expect(flash[:cookies_consent_updated]).to eq(param_value)
      expect(response).to redirect_to("/")
    end
  end
end
