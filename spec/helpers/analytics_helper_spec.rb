require "rails_helper"

RSpec.describe AnalyticsHelper, type: :helper do
  let(:record) { DisclosureCheck.new(kind:, under_age:) }
  let(:kind) { CheckKind::CAUTION }
  let(:under_age) { nil }

  before do
    allow(helper).to receive(:current_disclosure_check).and_return(record)
  end

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

  describe "#track_transaction" do
    before do
      allow(record).to receive_messages(id: "12345", kind: "caution")
    end

    it "sets the transaction attributes to track" do
      helper.track_transaction(name: "whatever")

      expect(
        helper.content_for(:transaction_data),
      ).to eq("{\"id\":\"12345\",\"name\":\"whatever\",\"sku\":\"caution\",\"quantity\":1}")
    end

    it "defaults transaction attributes if not present" do
      helper.track_transaction({})

      expect(
        helper.content_for(:transaction_data),
      ).to eq("{\"id\":\"12345\",\"name\":\"caution\",\"sku\":\"caution\",\"quantity\":1}")
    end

    context "when custom dimensions" do
      context "and spent" do
        it "sets the transaction attributes to track" do
          helper.track_transaction(name: "whatever", dimensions: { spent: "yes" })

          expect(
            helper.content_for(:transaction_data),
          ).to match(/"dimension1":"yes"/)
        end
      end

      context "when proceedings" do
        it "sets the transaction attributes to track" do
          helper.track_transaction(name: "whatever", dimensions: { proceedings: 3 })

          expect(
            helper.content_for(:transaction_data),
          ).to match(/"dimension2":3/)
        end
      end

      context "when orders" do
        it "sets the transaction attributes to track" do
          helper.track_transaction(name: "whatever", dimensions: { orders: 5 })

          expect(
            helper.content_for(:transaction_data),
          ).to match(/"dimension3":5/)
        end
      end
    end
  end

  describe "#transaction_sku" do
    before do
      allow(record).to receive(attr_name).and_return(attr_name)
    end

    context "when conviction_subtype is present" do
      let(:attr_name) { "conviction_subtype" }

      it { expect(helper.transaction_sku).to eq(attr_name) }
    end

    context "when conviction_type is present" do
      let(:attr_name) { "conviction_type" }

      it { expect(helper.transaction_sku).to eq(attr_name) }
    end

    context "when caution_type is present" do
      let(:attr_name) { "caution_type" }

      it { expect(helper.transaction_sku).to eq(attr_name) }
    end

    context "when kind is present" do
      let(:attr_name) { "kind" }

      it { expect(helper.transaction_sku).to eq(attr_name) }
    end
  end

  describe "#transaction_sku when not enough steps have been completed" do
    context "when `current_disclosure_check` is not present" do
      let(:record) { nil }

      it { expect(helper.transaction_sku).to eq("unknown") }
    end

    context "when `current_disclosure_check` is present, but `kind` is not present" do
      let(:kind) { nil }

      it { expect(helper.transaction_sku).to eq("unknown") }
    end
  end

  describe "#youth_check" do
    context "when `current_disclosure_check` is not present" do
      let(:record) { nil }

      it { expect(helper.youth_check).to eq("unknown") }
    end

    context "when `current_disclosure_check` is present, but `under_age` is not present" do
      let(:under_age) { nil }

      it { expect(helper.youth_check).to eq("unknown") }
    end

    context "when `under_age` is present" do
      let(:under_age) { "yes" }

      it { expect(helper.youth_check).to eq("yes") }
    end
  end
end
