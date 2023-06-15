namespace :test do
  # test:all is already defined by rails
  desc "run all tests and linters"
  task all_the_things: :environment do
    Rake::Task["rubocop"].invoke
    Rake::Task["brakeman"].invoke
    Rake::Task["spec"].invoke
    Rake::Task["cucumber"].invoke
  end
end
