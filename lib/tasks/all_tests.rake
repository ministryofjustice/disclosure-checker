namespace :test do
  # test:all is already defined by rails
  task all_the_things: :environment do
    Rake::Task["rubocop"].invoke
    Rake::Task["brakeman"].invoke
    Rake::Task["spec"].invoke
    Rake::Task["cucumber"].invoke
  end
end

# The following is the default task to run if none specified, so:
#   `bundle exec rake`
# will be equivalent to:
#   `bundle exec rake test:all_the_things`
#
task(:default).prerequisites.clear << task("test:all_the_things")
