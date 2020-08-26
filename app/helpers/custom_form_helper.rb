module CustomFormHelper
  def submit_button(i18n_key, opts = {}, &block)
    govuk_submit I18n.t("helpers.buttons.#{i18n_key}"), opts, &block
  end
end