if %w[development test].include?(Rails.env) && Gem.loaded_specs.key?("rubocop")
  require "rubocop/rake_task"
  RuboCop::RakeTask.new
end
