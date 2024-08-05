Rails.application.config.to_prepare do
  ActionView::Base.default_form_builder = GOVUKDesignSystemFormBuilder::FormBuilder

  GOVUKDesignSystemFormBuilder.configure do |config|
    config.default_error_summary_turbo_prefix = "turbolinks"

    config.default_legend_tag   = "h1"
    config.default_legend_size  = "xl"
    config.default_caption_size = "xl"
  end

  GOVUKDesignSystemFormBuilder::FormBuilder.class_eval do
    include CustomFormHelpers
  end
end
