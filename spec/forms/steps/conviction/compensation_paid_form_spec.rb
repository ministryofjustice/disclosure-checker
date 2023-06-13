require "spec_helper"

RSpec.describe Steps::Conviction::CompensationPaidForm do
  it_behaves_like "a yes-no question form",
                  attribute_name: :compensation_paid,
                  reset_when_no: [:compensation_payment_date]
end
