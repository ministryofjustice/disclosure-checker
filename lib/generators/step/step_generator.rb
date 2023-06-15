class StepGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)
  argument :task_name,  type: :string
  argument :step_name,  type: :string
  class_option :type,   type: :string, required: false, default: "edit"

  # If you add a new type of step, do not forget to update this hash
  TYPE_TEMPLATES = {
    show: "show.html.erb",
    edit: "edit.html.erb",
    question: "edit.html.erb",
    date: "edit.html.erb",
  }.freeze

  def validate_options!
    TYPE_TEMPLATES.keys.include?(type) ||
      raise("Unknown value for `--type` option. Valid options: `#{TYPE_TEMPLATES.keys.join('|')}`. Default: `edit`")
  end

  def copy_controller
    template "#{type}/controller.rb", "app/controllers/steps/#{task_name.underscore}/#{step_name.underscore}_controller.rb"
    template "#{type}/controller_spec.rb", "spec/controllers/steps/#{task_name.underscore}/#{step_name.underscore}_controller_spec.rb"
  end

  def copy_template
    template "#{type}/#{template_name}", "app/views/steps/#{task_name.underscore}/#{step_name.underscore}/#{template_name}"
  end

  def copy_form
    return if type == :show # show steps doesn't have form objects

    template "#{type}/form.rb", "app/forms/steps/#{task_name.underscore}/#{step_name.underscore}_form.rb"
    template "#{type}/form_spec.rb", "spec/forms/steps/#{task_name.underscore}/#{step_name.underscore}_form_spec.rb"
  end

  def add_step_to_routes
    case type
    when :show
      add_to_routes("show_step :#{step_name.underscore}")
    else
      add_to_routes("edit_step :#{step_name.underscore}")
    end
  end

private

  def add_to_routes(step_line)
    insert_into_file("config/routes.rb", after: /namespace :#{task_name.underscore} do.+?(?=end)/m) { "  #{step_line}\n    " }
  end

  # Supplied as an optional parameter in the command line with `--type=X`
  # Default value if option not passed is `edit`
  def type
    options.type.to_sym
  end

  def template_name
    TYPE_TEMPLATES[type]
  end
end
