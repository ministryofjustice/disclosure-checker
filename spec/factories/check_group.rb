# Important: factories should always produce predictable data, specially dates.
# This will avoid headaches with flaky tests.
#
FactoryBot.define do
  factory :check_group do
    disclosure_report
  end
end
