require "rails_helper"

# TestController doesn't have this method so we can't stub it nicely
class ActionView::TestCase::TestController
  def previous_step_path
    "/foo/bar"
  end
end

RSpec.describe ApplicationHelper, type: :helper do
  let(:record) { DisclosureCheck.new }

  describe "#step_form" do
    let(:expected_defaults) do
      {
        url: {
          controller: "application",
          action: :update,
        },
        html: {
          class: "edit_disclosure_check",
        },
        method: :put,
      }
    end
    let(:form_block) { proc {} }

    it "acts like FormHelper#form_for with additional defaults" do
      expect(helper).to receive(:form_for).with(record, expected_defaults) do |*_args, &block|
        expect(block).to eq(form_block)
      end
      helper.step_form(record, &form_block)
    end

    it "accepts additional options like FormHelper#form_for would" do
      expect(helper).to receive(:form_for).with(record, expected_defaults.merge(foo: "bar"))
      helper.step_form(record, { foo: "bar" })
    end

    it "appends optional css classes if provided" do
      expect(helper).to receive(:form_for).with(record, expected_defaults.merge(html: { class: %w[test edit_disclosure_check] }))
      helper.step_form(record, html: { class: "test" })
    end
  end

  describe "#step_header" do
    let(:form_object) { instance_double("Form object") } # rubocop:disable RSpec/VerifiedDoubleReference

    it "renders the expected content" do
      allow(helper).to receive(:render).with(partial: "layouts/step_header", locals: { path: "/foo/bar" }).and_return("foobar")
      assign(:form_object, form_object)

      expect(helper.step_header).to eq("foobar")
    end

    context "when a specific path is provided" do
      it "renders the back link with provided path" do
        allow(helper).to receive(:render).with(partial: "layouts/step_header", locals: { path: "/another/step" }).and_return("foobar")
        assign(:form_object, form_object)

        expect(helper.step_header(path: "/another/step")).to eq("foobar")
      end
    end
  end

  describe "#govuk_error_summary" do
    context "when no form object is given" do
      let(:form_object) { nil }

      it "returns nil" do
        expect(helper.govuk_error_summary(form_object)).to be_nil
      end
    end

    context "when a form object without errors is given" do
      let(:form_object) { BaseForm.new }

      it "returns nil" do
        expect(helper.govuk_error_summary(form_object)).to be_nil
      end
    end

    context "when a form object with errors is given" do
      let(:form_object) { BaseForm.new }
      let(:title) { helper.content_for(:page_title) }

      before do
        helper.title("A page")
        form_object.errors.add(:base, :blank)
      end

      it "returns the summary" do
        expect(
          helper.govuk_error_summary(form_object),
        ).to eq(
          '<div class="govuk-error-summary" data-module="govuk-error-summary"><div role="alert"><h2 class="govuk-error-summary__title">There is a problem on this page</h2><div class="govuk-error-summary__body"><ul class="govuk-list govuk-error-summary__list"><li><a data-turbolinks="false" href="#base-form-base-field-error">can&#39;t be blank</a></li></ul></div></div></div>',
        )
      end

      it "prepends the page title with an error hint" do
        helper.govuk_error_summary(form_object)
        expect(title).to start_with("Error: A page")
      end
    end
  end

  describe "#title" do
    let(:title) { helper.content_for(:page_title) }

    before do
      helper.title(value)
    end

    context "with a blank value" do
      let(:value) { "" }

      it { expect(title).to eq("Check when to disclose cautions or convictions - GOV.UK") }
    end

    context "with a provided value" do
      let(:value) { "Test page" }

      it { expect(title).to eq("Test page - Check when to disclose cautions or convictions - GOV.UK") }
    end
  end

  describe "#fallback_title" do
    before do
      allow(Rails).to receive_message_chain(:application, :config, :consider_all_requests_local).and_return(false) # rubocop:disable RSpec/MessageChain
      allow(helper).to receive_messages(controller_name: "my_controller", action_name: "an_action")
    end

    it "notifies in Sentry about the missing translation" do
      expect(Sentry).to receive(:capture_exception).with(
        StandardError.new("page title missing: my_controller#an_action"),
      )
      helper.fallback_title
    end

    it "calls #title with a blank value" do
      expect(helper).to receive(:title).with("")
      helper.fallback_title
    end
  end

  describe "#link_button" do
    it "builds the link markup styled as a button" do
      expect(
        helper.link_button(:start_again, root_path),
      ).to eq('<a class="govuk-button" data-module="govuk-button" href="/">New check</a>')
    end
  end

  describe "#any_completed_checks?" do
    let(:disclosure_report) { instance_double(DisclosureReport) }
    let(:disclosure_checks) { instance_double("result_set", completed: checks) } # rubocop:disable RSpec/VerifiedDoubleReference

    before do
      allow(disclosure_report).to receive(:disclosure_checks).and_return(disclosure_checks)
      allow(helper).to receive(:current_disclosure_report).and_return(disclosure_report)
    end

    context "when no checks completed" do
      let(:checks) { [] }

      it { expect(helper.any_completed_checks?).to be(false) }
    end

    context "when at least one check completed" do
      let(:checks) { [1] }

      it { expect(helper.any_completed_checks?).to be(true) }
    end
  end

  describe "#resume_check_path" do
    let(:current_disclosure_check) { instance_double(DisclosureCheck, navigation_stack:) }

    before do
      allow(helper).to receive(:current_disclosure_check).and_return(current_disclosure_check)
    end

    context "when the stack is empty" do
      let(:navigation_stack) { [] }

      it "returns the root path" do
        expect(helper.resume_check_path).to eq("/")
      end
    end

    context "when the stack has elements" do
      let(:navigation_stack) { ["/somewhere", "/over", "/the", "/rainbow"] }

      it "returns the last element" do
        expect(helper.resume_check_path).to eq("/rainbow")
      end
    end
  end

  describe "dev_tools_enabled?" do
    before do
      allow(Rails).to receive_message_chain(:env, :development?).and_return(development_env) # rubocop:disable RSpec/MessageChain
      allow(ENV).to receive(:key?).with("DEV_TOOLS_ENABLED").and_return(dev_tools_enabled)
    end

    context "with development envs" do
      let(:development_env) { true }
      let(:dev_tools_enabled) { nil }

      it { expect(helper.dev_tools_enabled?).to be(true) }
    end

    context "with envs that declare the `DEV_TOOLS_ENABLED` env variable" do
      let(:development_env) { false }
      let(:dev_tools_enabled) { true }

      it { expect(helper.dev_tools_enabled?).to be(true) }
    end

    context "with envs without `DEV_TOOLS_ENABLED` env variable" do
      let(:development_env) { false }
      let(:dev_tools_enabled) { false }

      it { expect(helper.dev_tools_enabled?).to be(false) }
    end
  end
end
