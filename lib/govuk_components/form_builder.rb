# rubocop:disable Metrics/ClassLength
module GovukComponents
  class FormBuilder < GovukElementsFormBuilder::FormBuilder
    delegate :t, :concat, to: :@template

    def continue_button(value: :continue, options: {})
      button t("helpers.submit.#{value}"), {
        name: nil,
        class: 'govuk-button',
        data: { module: 'govuk-button', 'prevent-double-click': true },
      }.merge(options)
    end

    # Methods below overrides the one from the original gem, and reimplement them
    # to produce new markup and style class names.
    # Also a few private methods have been reimplemented for this to work side
    # by side with the old gem.
    #
    def text_field(attribute, options = {})
      content_tag(:div, class: form_group_classes(attribute)) do
        concat input_label(attribute, options)
        concat hint(attribute, options)
        concat error(attribute)
        concat @template.text_field(@object_name, attribute, input_options(attribute, options))
      end
    end

    def radio_button_fieldset(attribute, options = {})
      wrapper_classes = ['govuk-radios']
      wrapper_classes << 'govuk-radios--inline' if options[:inline]

      radios = content_tag(:div, nil, class: wrapper_classes) do
        safe_join(radio_inputs(attribute, options), "\n")
      end

      content_tag(:div, class: form_group_classes(attribute)) do
        content_tag(:fieldset, fieldset_options(attribute, options)) do
          concat fieldset_legend(attribute, options)
          concat hint(attribute, options)
          concat error(attribute)
          concat radios
        end
      end
    end

    private

    def form_group_classes(attribute)
      classes = ['govuk-form-group']
      classes << 'govuk-form-group--error' if error_for?(attribute)
      classes
    end

    def aria_describes(attribute, options)
      aria_ids = []
      aria_ids << id_for(attribute, 'hint')  if hint(attribute, options)
      aria_ids << id_for(attribute, 'error') if error_for?(attribute)

      # If the array is empty, will return nil
      aria_ids.presence
    end

    def input_options(attribute, options)
      defaults = { class: 'govuk-input' }
      defaults['aria-describedby'] = aria_describes(attribute, options)

      merge_attributes(
        options[:input_options],
        default: defaults
      )
    end

    def fieldset_options(attribute, options)
      defaults = { class: 'govuk-fieldset' }
      defaults['aria-describedby'] = aria_describes(attribute, options)

      merge_attributes(
        options[:fieldset_options],
        default: defaults
      )
    end

    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def fieldset_legend(attribute, options)
      default_attrs = { class: 'govuk-fieldset__legend' }.freeze
      default_opts  = {
        visually_hidden: false, page_heading: true, size: 'xl'
      }.freeze

      legend_options = merge_attributes(
        options[:legend_options],
        default: default_attrs
      ).reverse_merge(
        default_opts
      )

      opts = legend_options.extract!(*default_opts.keys)

      legend_options[:class] << " govuk-fieldset__legend--#{opts[:size]}"
      legend_options[:class] << ' govuk-visually-hidden' if opts[:visually_hidden]

      text = localized_text(
        'helpers.fieldset', attribute,
        i18n_attribute: options[:i18n_attribute],
        default: default_label(attribute)
      )

      # The `page_heading` option can be false to disable "Legends as page headings"
      # https://design-system.service.gov.uk/get-started/labels-legends-headings/
      #

      if opts[:page_heading]
        content_tag(:legend, legend_options) do
          content_tag(:h1, text, class: 'govuk-fieldset__heading')
        end
      else
        content_tag(:legend, text, legend_options)
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    # Note: there is a lot of repetition here and in the `fieldset_legend` method,
    # but until we have a clear understanding of how we will refactor all this code
    # (for example, extract to a gem?) and the functionality that we can cover, it
    # is better to have a bit of duplication to iterate quicker.
    #
    # rubocop:disable Metrics/AbcSize, Metrics/MethodLength
    def input_label(attribute, options)
      default_attrs = { class: 'govuk-label' }.freeze
      default_opts  = { visually_hidden: false, page_heading: true, size: 'xl' }.freeze

      label_options = merge_attributes(
        options[:label_options],
        default: default_attrs
      ).reverse_merge(
        default_opts
      )

      opts = label_options.extract!(*default_opts.keys)

      label_options[:class] << " govuk-label--#{opts[:size]}"
      label_options[:class] << ' govuk-visually-hidden' if opts[:visually_hidden]

      text = localized_text(
        'helpers.label', attribute,
        i18n_attribute: options[:i18n_attribute],
        default: default_label(attribute)
      )

      html = Nokogiri::HTML.fragment(
        label(attribute, text, label_options)
      )

      # Remove the error span Rails introduce, as we are handling errors
      # in a different way and with different markup.
      html.at(:span)&.unlink
      label_html = html.to_html.html_safe

      # The `page_heading` option can be false to disable "Legends as page headings"
      # https://design-system.service.gov.uk/get-started/labels-legends-headings/
      #
      if opts[:page_heading]
        content_tag(:h1, label_html, class: 'govuk-label-wrapper')
      else
        label_html
      end
    end
    # rubocop:enable Metrics/AbcSize, Metrics/MethodLength

    def radio_inputs(attribute, options)
      choices = options[:choices] || [:yes, :no]
      choices.map do |choice|
        value = choice.send(options[:value_method] || :to_s)
        input = radio_button(attribute, value, class: 'govuk-radios__input')
        label = label(attribute, value: value, class: 'govuk-label govuk-radios__label') do
          if options.key? :text_method
            # :nocov:
            # TODO: This will be removed once a text method is used
            choice.send(options[:text_method])
            # :nocov:
          else
            localized_label("#{attribute}.#{choice}")
          end
        end
        radio_hint = options[:radio_hint].present? ? radio_hint(attribute, value) : ''
        content_tag(:div, class: 'govuk-radios__item') do
          input + label + radio_hint
        end
      end
    end

    def radio_hint(attribute, value)
      text = I18n.t("helpers.hint.radio_buttons.#{attribute}.#{value}")
      content_tag(:span, text, class: 'govuk-hint govuk-radios__hint', id: id_for("#{attribute}_#{value}", 'hint'))
    end

    def hint(attribute, options)
      text = localized_text(
        'helpers.hint', attribute,
        i18n_attribute: options[:i18n_attribute],
        default: ''
      )

      return unless text.present?

      content_tag(:span, text, class: 'govuk-hint', id: id_for(attribute, 'hint'))
    end

    def error(attribute)
      return unless error_for?(attribute)

      text = error_full_message_for(attribute)
      content_tag(:span, text, class: 'govuk-error-message', id: id_for(attribute, 'error'))
    end

    def id_for(attribute, suffix)
      [attribute_prefix, attribute, suffix].join('_')
    end

    # If a form view is reused but the attribute doesn't change (for example in
    # partials) an `i18n_attribute` can be used to lookup the legend or hint locales
    # based on this, instead of the original attribute.
    #
    # We prioritise the `i18n_attribute` if provided, and if no locale is found,
    # we try the 'real' attribute as a fallback and finally the default value.
    #
    def localized_text(scope, attribute, i18n_attribute: nil, default:)
      found = if i18n_attribute
                key = "#{@object_name}.#{i18n_attribute}"

                I18n.translate(key, default: '', scope: scope).presence ||
                  I18n.translate("#{key}_html", default: '', scope: scope).html_safe.presence
              end

      return found if found

      key = "#{@object_name}.#{attribute}"

      # Passes blank String as default because nil is interpreted as no default
      I18n.translate(key, default: '', scope: scope).presence ||
        I18n.translate("#{key}_html", default: default, scope: scope).html_safe.presence
    end
  end
end
# rubocop:enable Metrics/ClassLength
