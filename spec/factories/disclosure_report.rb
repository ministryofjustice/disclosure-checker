# Important: factories should always produce predictable data, specially dates.
# This will avoid headaches with flaky tests.
#
FactoryBot.define do
  factory :disclosure_report do
    status { 0 }
  end
end
