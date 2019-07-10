module ApplicationHelper
  # Render a form_for tag pointing to the update action of the current controller
  def step_form(record, options = {}, &block)
    opts = {
      url: { controller: controller.controller_path, action: :update },
      method: :put
    }.merge(options)

    # Support for appending optional css classes, maintaining the default one
    opts.merge!(
      html: { class: dom_class(record, :edit) }
    ) do |_key, old_value, new_value|
      { class: old_value.values | new_value.values }
    end

    form_for record, opts, &block
  end

  # Render a back link pointing to the user's previous step
  def step_header
    capture do
      render partial: 'step_header', locals: {
        path: controller.previous_step_path
      }
    end
  end

  def step_subsection(form_object = @form_object)
    capture do
      render partial: 'step_subsection', locals: {
        subsection: form_object.conviction_subtype
      }
    end
  end

  def error_summary(form_object = @form_object)
    return unless GovukElementsErrorsHelper.errors_exist?(form_object)

    content_for(:page_title, flush: true) do
      content_for(:page_title).insert(0, t('errors.page_title_prefix'))
    end

    GovukElementsErrorsHelper.error_summary(
      form_object,
      t('errors.error_summary.heading')
    )
  end

  def analytics_tracking_id
    ENV['GA_TRACKING_ID']
  end

  def service_name
    t('service.name')
  end

  def title(page_title)
    content_for :page_title, [page_title.presence, service_name, 'GOV.UK'].compact.join(' - ')
  end

  def fallback_title
    exception = StandardError.new("page title missing: #{controller_name}##{action_name}")
    raise exception if Rails.application.config.consider_all_requests_local

    Raven.capture_exception(exception)

    title ''
  end

  def display_result(object)
    return object unless object.instance_of?(Date)

    I18n.l(object)
  end
end
