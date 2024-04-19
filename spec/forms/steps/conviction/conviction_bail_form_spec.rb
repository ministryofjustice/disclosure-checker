require "spec_helper"

RSpec.describe Steps::Conviction::ConvictionBailForm do
  it_behaves_like "a yes-no question form",
                  attribute_name: :conviction_bail,
                  reset_when_no: [:conviction_bail_days]
end
