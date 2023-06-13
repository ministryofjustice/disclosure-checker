class TaskGenerator < Rails::Generators::Base
  source_root File.expand_path("templates", __dir__)
  argument :task_name, type: :string

  def copy_controller
    template "controller.rb", "app/controllers/steps/#{task_name.underscore}_step_controller.rb"
  end

  def add_to_routes
    insert_into_file "config/routes.rb", after: /namespace :steps do\n/m do
      "    namespace :#{task_name.underscore} do\n    end\n"
    end
  end

  def copy_decision_tree
    template "decision_tree.rb", "app/services/#{task_name.underscore}_decision_tree.rb"
    template "decision_tree_spec.rb", "spec/services/#{task_name.underscore}_decision_tree_spec.rb"
  end
end
