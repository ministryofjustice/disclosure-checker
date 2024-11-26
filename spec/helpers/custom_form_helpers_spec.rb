require "rails_helper"

RSpec.describe CustomFormHelpers, type: :helper do
  let(:form_object) { instance_double("FormObject") }

  let(:builder) do
    GOVUKDesignSystemFormBuilder::FormBuilder.new(
      :disclosure_check,
      form_object,
      self,
      {},
    )
  end

  describe "#continue_button" do
    let(:expected_markup) { '<button type="submit" formnovalidate="formnovalidate" class="govuk-button" data-module="govuk-button" data-prevent-double-click="true">Continue</button>' }
    let(:template) { instance_double("template", params:) }

    before do
      allow(builder).to receive(:template).and_return(template)
    end

    context "when there is no next step param" do
      let(:params) { {} }

      it "outputs the govuk continue button without the next step hidden tag" do
        expect(
          builder.continue_button,
        ).to eq(expected_markup)
      end
    end

    context "when the next step param is not recognised" do
      let(:params) { { next_step: "foobar" } }

      it "outputs the govuk continue button without the next step hidden tag" do
        expect(
          builder.continue_button,
        ).to eq(expected_markup)
      end
    end

    context "when there is a valid next step param" do
      let(:params) { { next_step: "cya" } }

      it "outputs the govuk continue button with the next step hidden tag" do
        allow(
          template,
        ).to receive(:hidden_field_tag).with(
          :next_step, "/steps/check/check_your_answers"
        ).and_return("<hidden_tag_here>".html_safe)

        expect(
          builder.continue_button,
        ).to eq("<hidden_tag_here>#{expected_markup}")
      end
    end
  end

  describe "#i18n_caption" do
    before do
      allow(form_object).to receive(:conviction_subtype).and_return(:foobar)
    end

    it "seeks the expected locale key" do
      expect(I18n).to receive(:t).with(
        :foobar, scope: %i[helpers caption disclosure_check]
      )

      builder.i18n_caption
    end
  end

  describe "#i18n_legend" do
    before do
      allow(form_object).to receive(:i18n_attribute).and_return(:foobar)
    end

    it "seeks the expected locale key" do
      expect(I18n).to receive(:t).with(
        :foobar, scope: %i[helpers legend disclosure_check], default: :default
      )

      builder.i18n_legend
    end
  end

  describe "#i18n_date_hint" do
    let(:found_key) { "hint text about dates" }

    before do
      allow(I18n).to receive(:t).with(
        "helpers/dictionary.date_hint_text",
      ).and_return(found_key)
    end

    describe "with lead_text argument" do
      it "seeks the expected key" do
        expect(found_key).to receive(:html_safe)

        builder.i18n_date_hint("lead text")
      end

      it "wraps lead text in p tags" do
        expect(builder.i18n_date_hint("lead text")).to include "<p>lead text</p>"
      end
    end

    describe "without lead_text argument" do
      it "gets lead text from i18n_lead_text" do
        allow(builder).to receive(:i18n_lead_text).and_return "i18n_lead_text"

        expect(builder.i18n_date_hint).to include "<p>i18n_lead_text</p>"
      end
    end
  end

  describe "#i18n_hint" do
    let(:found_locale) { instance_double("locale") }

    before do
      allow(form_object).to receive(:i18n_attribute).and_return(:foobar)
    end

    it "seeks the expected locale key" do
      allow(I18n).to receive(:t).with(
        "foobar_html", scope: %i[helpers hint disclosure_check], default: :default_html
      ).and_return(found_locale)

      expect(found_locale).to receive(:html_safe)

      builder.i18n_hint
    end
  end

  describe "#i18n_lead_text" do
    before do
      allow(form_object).to receive(:i18n_attribute).and_return(:foobar)
    end

    it "seeks the expected locale key" do
      expect(I18n).to receive(:t).with(
        :foobar, scope: %i[helpers lead_text disclosure_check], default: :default
      )

      builder.i18n_lead_text
    end
  end
end
