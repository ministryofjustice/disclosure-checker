desc "run cucumber tests"
task cucumber: :environment do
  unless system("bundle exec cucumber --tags 'not @ignore'")
    raise "Cucumber tests failed"
  end
end
