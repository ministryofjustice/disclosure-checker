task cucumber: :environment do
  unless system("bundle exec cucumber")
    raise "Cucumber tests failed"
  end
end
