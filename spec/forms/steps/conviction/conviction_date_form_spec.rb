require "spec_helper"

RSpec.describe Steps::Conviction::ConvictionDateForm do
  it_behaves_like "a date question form", attribute_name: :conviction_date
end
