module CustomFormHelpers
  delegate :params, :hidden_field_tag, to: :template

  def continue_button(continue: :continue)
    submit_button(continue)
  end

  # Used to customise captions above the page heading
  def i18n_caption
    I18n.t(
      object.conviction_subtype, scope: scope_for_locale(:caption)
    )
  end

  # Used to customise legends when reusing the same view
  def i18n_legend
    I18n.t(
      object.i18n_attribute, scope: scope_for_locale(:legend), default: :default
    )
  end

  # Used to customise hints when reusing the same view
  # Hints support markup so ensure locale keys ends with `_html`
  def i18n_hint
    I18n.t(
      "#{object.i18n_attribute}_html", scope: scope_for_locale(:hint), default: :default_html
    ).html_safe
  end

  # Used to customise lead text when reusing the same view
  def i18n_lead_text
    I18n.t(
      object.i18n_attribute, scope: scope_for_locale(:lead_text), default: :default
    )
  end

  private

  def submit_button(i18n_key, opts = {}, &block)
    safe_join(
      [
        next_step_if_present,
        govuk_submit(I18n.t("helpers.buttons.#{i18n_key}"), **opts, &block)
      ]
    )
  end

  # Do not blindly trust the param, always whitelist
  def next_step_if_present
    next_step = case params[:next_step]
                when 'cya'
                  '/steps/check/check_your_answers'
                end

    hidden_field_tag(:next_step, next_step) if next_step
  end

  def scope_for_locale(context)
    [:helpers, context, object_name]
  end

  # This method is just to aid with testing
  # :nocov:
  def template
    @template
  end
  # :nocov:
end
